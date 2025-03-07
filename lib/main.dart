import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart';

void main() {
  runApp(const NFCWriterApp());
}

class NFCWriterApp extends StatelessWidget {
  const NFCWriterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const NFCWriterScreen(),
    );
  }
}

class NFCWriterScreen extends StatefulWidget {
  const NFCWriterScreen({Key? key}) : super(key: key);

  @override
  State<NFCWriterScreen> createState() => _NFCWriterScreenState();
}

class _NFCWriterScreenState extends State<NFCWriterScreen> {
  final TextEditingController _textController = TextEditingController();
  bool isWriting = false;

  Future<void> _writeToNFC() async {
    String textToWrite = _textController.text.trim();

    if (textToWrite.isEmpty) {
      _showDialog("Error", "Please enter some text to write.");
      return;
    }

    setState(() {
      isWriting = true;
    });

    try {
      // Attiva la scansione NFC
      var tag = await FlutterNfcKit.poll(timeout: Duration(seconds: 10));

      if (tag.ndefWritable == false) {
        throw "This NFC tag is not writable.";
      }

      // Crea un record NDEF con il testo

      var record = NDEFRecord(
        //id: [0,0,1] as Uint8List,
        payload: Uint8List.fromList(_createTextPayload(textToWrite)),
        type: utf8.encode('T'), // 'T' indica un record di tipo testo
        tnf: TypeNameFormat.nfcWellKnown,
      );

      // Scrive il record sul tag NFC
      await FlutterNfcKit.writeNDEFRecords([record]);

      _showDialog("Success", "Text successfully written to NFC tag!");

    } catch (e) {
      _showDialog("Error", e.toString());
    } finally {
      await FlutterNfcKit.finish();
      setState(() {
        isWriting = false;
      });
    }
  }

  // Funzione per creare il payload NDEF Text Record
  List<int> _createTextPayload(String text) {
    const String languageCode = 'en'; // Imposta la lingua (es: 'en', 'it')
    List<int> languageCodeBytes = utf8.encode(languageCode);
    List<int> textBytes = utf8.encode(text);

    int statusByte = languageCodeBytes.length; // Il primo byte è la lunghezza del codice lingua
    return [statusByte, ...languageCodeBytes, ...textBytes];
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC Writer"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Enter text to write on NFC tag:",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter text here...",
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isWriting ? null : _writeToNFC,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: isWriting
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Write NFC"),
            ),
          ],
        ),
      ),
    );
  }
}
