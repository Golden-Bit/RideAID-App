import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';

const keyParseApplicationId = 'EYXNKIhqJHytdT5QAeNIlxICu4qEI5ohhrj5rd9G';
const keyParseClientKey = 'GdWTAMKD9MbXTnPMjUW2VdF6qrSuN1gY7YhVjlxx';
const keyParseServerUrl = 'https://parseapi.back4app.com';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Parse().initialize(
    keyParseApplicationId,
    keyParseServerUrl,
    clientKey: keyParseClientKey,
    autoSendSessionId: true,
    debug: !kReleaseMode,
  );
  runApp(const RaiderAidApp());
}

class RaiderAidApp extends StatelessWidget {
  const RaiderAidApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RaiderAidHome(),
    );
  }
}

class RaiderAidHome extends StatelessWidget {
  const RaiderAidHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (BuildContext context) {
                  return const _NfcScanningBottomSheet();
                },
              );
            },
            child: const Text("Scan NFC"),
          ),
        ),
      ),
    );
  }
}

class _NfcScanningBottomSheet extends StatefulWidget {
  const _NfcScanningBottomSheet({Key? key}) : super(key: key);

  @override
  State<_NfcScanningBottomSheet> createState() => _NfcScanningBottomSheetState();
}

class _NfcScanningBottomSheetState extends State<_NfcScanningBottomSheet>
    with SingleTickerProviderStateMixin {
  String nfcData = "";
  bool isSuccess = false;
  bool isError = false;
  bool isLoading = true;

  late AnimationController _pulsationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pulsationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulsationController, curve: Curves.easeInOut),
    );
    _pulsationController.repeat(reverse: true);

    _startNfcScan();
  }

  Future<void> _startNfcScan() async {
    try {
      var tag = await FlutterNfcKit.poll();

      String tagContent = "NFC tag detected, but no data found.";
      if (tag.ndefAvailable == true && tag.ndefType != null) {
        // Leggiamo il contenuto del tag NDEF
        var ndefRecords = await FlutterNfcKit.readNDEFRecords();
        if (ndefRecords.isNotEmpty) {
tagContent = ndefRecords.map((record) {
  // Assicuriamoci che payload non sia null e lo convertiamo in List<int>
  List<int> payload = record.payload?.toList() ?? [];

  if (payload.isNotEmpty) {
    int languageCodeLength = payload[0] & 0x3F; // Primi 6 bit indicano la lunghezza del codice lingua
    payload = payload.sublist(1 + languageCodeLength); // Salta il byte iniziale + codice lingua
  }

  return utf8.decode(payload);
}).join("\n");
        }
      }

      await FlutterNfcKit.finish();
      setState(() {
        nfcData = tagContent;
        isSuccess = true;
        isError = false;
        isLoading = false;
      });

      // Mostra il contenuto del tag in un popup
      _showNfcDataDialog(nfcData);

    } catch (e) {
      setState(() {
        nfcData = "Error: $e";
        isSuccess = false;
        isError = true;
        isLoading = false;
      });
    }
    _pulsationController.stop();
  }

  void _showNfcDataDialog(String data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("NFC Tag Content"),
          content: Text(data),
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
  void dispose() {
    _pulsationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color successColor = Colors.green;
    final Color errorColor = Colors.red;
    Color circleColor = Colors.blue;
    if (!isLoading) {
      if (isSuccess) {
        circleColor = successColor;
      } else if (isError) {
        circleColor = errorColor;
      }
    }

    Widget circlesWidget = SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: circleColor, width: 1.5),
            ),
          ),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: circleColor, width: 1.5),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: circleColor, width: 1.5),
            ),
            child: Icon(
              Icons.nfc,
              color: circleColor,
              size: 24,
            ),
          ),
        ],
      ),
    );

    if (isLoading) {
      circlesWidget = ScaleTransition(
        scale: _scaleAnimation,
        child: circlesWidget,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Scan NFC Band',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          isLoading
              ? const Text('Waiting for NFC signal...')
              : isError
                  ? Text(nfcData, style: const TextStyle(color: Colors.red))
                  : const Text('NFC tag detected successfully!'),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: Center(child: circlesWidget),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
