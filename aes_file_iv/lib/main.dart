// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:aes_file_iv/aes_encryptor.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'aes file iv'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _asyncRead = false; //! a bool that states if the async is already read
  final _sharedPreferenceStorage = const FlutterSecureStorage(); //! the secure storage
  Map<String, String> _storageContent = {}; //! contains a global map of all stored parameters
  late Directory _rootDirectory; //! the root directory of the dialog
  late AesEncryptor _aesEncryptor; //! the aes encryption module
  final String _examplePW = '1234'; //! this is only an example password, should be applied in testing purposes

  //* WidgetBase -------------------------------------------------------------------------------------------------------------------------------------
  @override
  void initState() {
    _onInitAsync();
    super.initState();
  }

  @override
  void dispose() async {
    await _onDisposeAsync();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_asyncRead) {
      return const SizedBox(
        height: 100,
        width: 100,
        child: CircularProgressIndicator(),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Press the button',
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _onEncryptClicked,
                  child: const Text('encrypt File'),
                ),
                TextButton(
                  onPressed: _onDecryptClicked,
                  child: const Text('decrypt File'),
                ),
                TextButton(
                  onPressed: _onEncryptFolderClicked,
                  child: const Text('encrypt Folder'),
                ),
                TextButton(
                  onPressed: _onDecryptFolderClicked,
                  child: const Text('decrypt Folder'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //* builds -----------------------------------------------------------------------------------------------------------------------------------------

  //* callbacks --------------------------------------------------------------------------------------------------------------------------------------

  void _onInitAsync() async {
    _storageContent = await _sharedPreferenceStorage.readAll();
    _rootDirectory = await getApplicationDocumentsDirectory();
    if (!_storageContent.containsKey('password') || !_storageContent.containsKey('iv')) {
      print('creates new aesEncryptor');
      _aesEncryptor = AesEncryptor(password: _examplePW);
      await _writeToSecureStorage();
    } else {
      print('aesEncryptor uses credentials from secure storage');
      _aesEncryptor = AesEncryptor(
        password: _examplePW,
      );
    }

    // finish async reading
    setState(() {
      _asyncRead = true;
    });
  }

  Future<void> _onDisposeAsync() async {
    await _writeToSecureStorage();
  }

  Future<void> _writeToSecureStorage() async {
    for (var entry in _storageContent.entries) {
      await _sharedPreferenceStorage.write(key: entry.key, value: entry.value);
    }
  }

  void _onEncryptClicked() async {
    String? path = await FilesystemPicker.openDialog(
      title: 'Open file that should be encrypted',
      context: context,
      fsType: FilesystemType.file,
      rootDirectory: _rootDirectory,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      contextActions: [
        FilesystemPickerNewFolderContextAction(),
      ],
    );
    if (path == null) {
      return;
    }
    try {
      _aesEncryptor.encryptFile(File(path));
      print('encrypted "$path"');
    } catch (e) {
      print('Error encrypting "$path": "$e"');
    }
  }

  void _onDecryptClicked() async {
    String? path = await FilesystemPicker.openDialog(
      title: 'Open file that should be decrypted',
      context: context,
      fsType: FilesystemType.file,
      rootDirectory: _rootDirectory,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      contextActions: [
        FilesystemPickerNewFolderContextAction(),
      ],
    );
    if (path == null) {
      return;
    }
    try {
      _aesEncryptor.decryptFile(File(path));
    } catch (e) {
      print('Error decrypting "$path": "$e"');
    }
  }

  void _onEncryptFolderClicked() async {
    String? path = await FilesystemPicker.openDialog(
      title: 'Open file that should be encrypted',
      context: context,
      fsType: FilesystemType.folder,
      rootDirectory: _rootDirectory,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      contextActions: [
        FilesystemPickerNewFolderContextAction(),
      ],
    );
    if (path == null) {
      return;
    }
    try {
      _aesEncryptor.encryptFolder(Directory(path), true);
    } catch (e) {
      print('Error encrypting "$path": "$e"');
    }
  }

  void _onDecryptFolderClicked() async {
    String? path = await FilesystemPicker.openDialog(
      title: 'Open file that should be decrypted',
      context: context,
      fsType: FilesystemType.folder,
      rootDirectory: _rootDirectory,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      contextActions: [
        FilesystemPickerNewFolderContextAction(),
      ],
    );
    if (path == null) {
      return;
    }
    try {
      _aesEncryptor.decryptFolder(Directory(path), true);
    } catch (e) {
      print('Error decrypting "$path": "$e"');
    }
  }
}
