// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  final _sharedPreferenceStorage =
      const FlutterSecureStorage(); //! the secure storage
  Map<String, String> _storageContent = {}; //! contains the
  late enc.IV _iv; //! the iv for aes encryption
  late enc.Encrypter _encrypter; //! the aes encryption module
  late Directory _rootDirectory; //! the root directory of the dialog
  final String _tmpPW = '1234'; //! the tmp password

  @override
  void initState() {
    _onInitAsync();
    super.initState();
  }

  @override
  void dispose() {
    _onDisposeAsync();
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
                  child: const Text('encrypt'),
                ),
                TextButton(
                  onPressed: _onDecryptClicked,
                  child: const Text('decrypt'),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: _onExportKeyClicked,
                  child: const Text('export Key'),
                ),
                TextButton(
                  onPressed: _onImportKeyClicked,
                  child: const Text('import Key'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onInitAsync() async {
    _storageContent = await _sharedPreferenceStorage.readAll();
    _rootDirectory = await getApplicationDocumentsDirectory();

    if (!_storageContent.containsKey('key')) {
      print('create new ciphers');
      _storageContent['key'] = enc.Key.fromLength(32).base64;
      _storageContent['iv'] = enc.IV.fromSecureRandom(16).base64;
      await _sharedPreferenceStorage.write(
          key: 'key', value: _storageContent['key']);
      await _sharedPreferenceStorage.write(
          key: 'iv', value: _storageContent['iv']);
    }
    var key = enc.Key.fromBase64(_storageContent['key']!);
    _iv = enc.IV.fromBase64(_storageContent['iv']!);
    _encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));

    // finish async reading
    setState(() {
      _asyncRead = true;
    });
  }

  void _onDisposeAsync() async {
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
      File file = File(path);
      file.writeAsBytesSync(
          _encrypter.encryptBytes(file.readAsBytesSync(), iv: _iv).bytes);
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
      File file = File(path);

      file.writeAsBytesSync(_encrypter
          .decryptBytes(enc.Encrypted(file.readAsBytesSync()), iv: _iv));
    } catch (e) {
      print('Error decrypting "$path": "$e"');
    }
  }

  void _onExportKeyClicked() async {
    String? path = await FilesystemPicker.openDialog(
      title: 'where should the keyfile be saved?',
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
      File file = File('$path/key.json');
      Map<String, String> map = {};
      map['key'] = _storageContent['key']!;
      map['iv'] = _storageContent['iv']!;
      file.writeAsStringSync(jsonEncode(map));
      print('exported key');
    } catch (e) {
      print('Error writing "$path": "$e"');
    }
  }

  void _onImportKeyClicked() async {
    String? path = await FilesystemPicker.openDialog(
      title: 'where should the keyfile be saved?',
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
      File file = File(path);
      var map = jsonDecode(file.readAsStringSync());
      for (var entry in map.entries) {
        _storageContent.update(entry.key, (value) => entry.value);
        await _sharedPreferenceStorage.write(
            key: entry.key, value: entry.value);
      }
      var key = enc.Key.fromBase64(_storageContent['key']!);
      _iv = enc.IV.fromBase64(_storageContent['iv']!);
      _encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
      print('imported key');
    } catch (e) {
      print('Error importing "$path": "$e"');
    }
  }
}
