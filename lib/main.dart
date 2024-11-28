import 'package:flutter/material.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


void main(){
  runApp(CryptoText())
}

class CryptoText extends StatelessWidget {
  const CryptoText({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CryptoText',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final encrypt.Key _key = encrypt.Key.fromLength(32);
  final iv = encrypt.IV.fromLength(16);

  String _encryptedText = ' ';
  String _decryptedText = ' ';
  String? _errorText;
  bool _isDecryptButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CryptoText"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _textEditingController,
            decoration: InputDecoration(
              labelText: 'InputText',
              errorText: _errorText,
              border: const OutlineInputBorder()
            ),
            onChanged: _onTextChanged,
          ),
          const SizedBox(height: 20,),
          ElevatedButton(onPressed: () {
            String inputText = _textEditingController.text;

            if(inputText.isNotEmpty){
              _encryptText(inputText);
            }else{
              setState(() {
                _errorText = 'Input Cannot be Empty';
              });
            }
          }, child: const Text('Encrypt')),
          const SizedBox(height: 10,),
          const Text(
            'Decrypted Text: $_decryptedText'
          ),
          const SizedBox(),
          const ElevatedButton(onPressed: onPressed, child: child)
        ],
      ),
    );
  }

  void _onTextChanged(String text) {
    setState(() {
    _isDecryptButtonEnabled = text.isNotEmpty;
    _encryptedText = '';
    _decryptedText = '';
    _errorText = null;
    });
  }

  void _encryptText(String text){
    try{
      if(text.isNotEmpty){
        final encrypter = encrypt.Encrypter(encrypt.AES(_key));
        final encrypted = encrypter.encrypt(text, iv: iv);
        setState(() {
          _encryptedText = encrypted.base64;
        });
      }
      else{
        print('Text to Encrypt Cannot be Empty');
      }
    }
    catch(e, stackTrace){
        print('Error encrypting text : $e, stackTrace: $stackTrace');
    }
  }
}



