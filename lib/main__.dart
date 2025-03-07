import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:ride_aid_app/info_page.dart';
import 'package:ride_aid_app/riders_list.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart'; // Importa la libreria flutter_nfc_kit


const keyParseApplicationId = 'EYXNKIhqJHytdT5QAeNIlxICu4qEI5ohhrj5rd9G';
const keyParseClientKey = 'GdWTAMKD9MbXTnPMjUW2VdF6qrSuN1gY7YhVjlxx';
const keyParseServerUrl = 'https://parseapi.back4app.com';

//String  object_id = MVPQKynZdr

// Aggiungiamo la SplashPage come prima pagina mostrata
void main() async {
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
      // Impostiamo la SplashPage come home iniziale
      home: const SplashPage(),
    );
  }
}

/// SplashPage: mostra il logo AIMC al centro, sfondo bianco.
/// Dopo 2 secondi, passa automaticamente alla RaiderAidHome.
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Durata totale per animazione di ingresso e uscita
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1), // parte dal basso
      end: const Offset(0, 0),   // posizione finale: centro
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _fadeAnimation = Tween<double>(
      begin: 0,  // inizia trasparente
      end: 1,    // diventa opaco
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Avvia animazione di ingresso
    _controller.forward();

    // Dopo 2 secondi, avvia l'animazione di uscita e poi naviga
    Future.delayed(const Duration(seconds: 2), () async {
      await _controller.reverse(); // Animazione inversa per sfumare in uscita
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const RaiderAidHome()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        // Applica SlideTransition e FadeTransition al logo
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              'assets/images/aimc_logo.png', // Percorso del logo
              width: 200,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

/// La pagina principale (RaiderAidHome) rimane per lo più invariata,
/// salvo che non è più l'home diretta ma viene richiamata dalla SplashPage.
class RaiderAidHome extends StatelessWidget {
  const RaiderAidHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Misure e colori di base
    const Color primaryCircleColor = Color(0xFFE7ECF3); // Cerchio esterno
    const Color secondaryCircleColor = Color(0xFF0E4DA4); // Cerchio interno
    const double outerCircleSize = 220;
    const double innerCircleSize = 140;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Barra superiore con le icone a destra
              Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Icona UTENTE -> apre la lista RiderCardPage
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RidersCardPage(),
                          ),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: secondaryCircleColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.person,
                          color: secondaryCircleColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Icona INFO -> Apri InfoPage
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const InfoPage()),
                        );
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: secondaryCircleColor,
                            width: 2,
                          ),
                        ),
                        child: Icon(
                          Icons.info,
                          color: secondaryCircleColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Titolo principale
              const Text(
                'Raider AID',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              // Sottotitolo
              const Text(
                'The first aid ally',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              // Testo esplicativo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: const Text(
                  'Hold the device close to the NFC bracelet to access essential first aid information. Every second counts.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
                ),
              ),
              const SizedBox(height: 40),
              // Cerchio esterno + cerchio interno (entrambi cliccabili)
              GestureDetector(
                onTap: () {
                  // Al tap, mostriamo il bottom sheet per la scansione NFC
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
                child: Container(
                  width: outerCircleSize,
                  height: outerCircleSize,
                  decoration: BoxDecoration(
                    color: primaryCircleColor,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Container(
                      width: innerCircleSize,
                      height: innerCircleSize,
                      decoration: const BoxDecoration(
                        color: secondaryCircleColor,
                        shape: BoxShape.circle,
                      ),
                      // Colonna con icona e testo
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.nfc, color: Colors.white, size: 32),
                          SizedBox(height: 8),
                          Text(
                            'Scan NFC',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// _NfcScanningBottomSheet: quando attivato, inizia la lettura NFC utilizzando la libreria flutter_nfc_kit.
/// Se il tag NFC viene letto correttamente, i cerchi concentrici diventano verdi e viene mostrato un menu scrollabile in basso;
/// in caso di errore, i cerchi diventano rossi e viene mostrato un messaggio d'errore.
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
    // Inizializza il controller per l'animazione pulsante (effetto "molla")
    _pulsationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _scaleAnimation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _pulsationController, curve: Curves.easeInOut),
    );
    // Avvia l'animazione in loop (pulsazione)
    _pulsationController.repeat(reverse: true);

    _startNfcScan();
  }

  Future<void> _startNfcScan() async {
    try {
      // Avvia il polling NFC utilizzando flutter_nfc_kit
      var tag = await FlutterNfcKit.poll();
      await FlutterNfcKit.finish();
      setState(() {
        nfcData = tag.id; // oppure usa tag.toString() se preferisci
        isSuccess = true;
        isError = false;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        nfcData = e.toString();
        isSuccess = false;
        isError = true;
        isLoading = false;
      });
    }
    // Ferma gradualmente l'animazione pulsante
    _pulsationController.stop();
  }

  @override
  void dispose() {
    _pulsationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color secondaryColor = const Color(0xFF0E4DA4);
    final Color successColor = Colors.green;
    final Color errorColor = Colors.red;
    Color circleColor = secondaryColor;
    if (!isLoading) {
      if (isSuccess) {
        circleColor = successColor;
      } else if (isError) {
        circleColor = errorColor;
      }
    }

    // Costruzione dei cerchi concentrici
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

    // Se siamo in attesa, applica l'animazione di pulsazione (ScaleTransition)
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
          // Handle (barra) in alto per indicare che il modal è trascinabile
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
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Stato della scansione NFC
          isLoading
              ? const Text(
                  'Waiting for NFC signal...',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                )
              : isError
                  ? Text(
                      'Error: $nfcData',
                      style: const TextStyle(fontSize: 16, color: Colors.red),
                    )
                  : const Text(
                      'NFC tag detected successfully!',
                      style: TextStyle(fontSize: 16, color: Colors.green),
                    ),
          const SizedBox(height: 24),
          // Mostra i cerchi concentrici al centro occupando tutta la larghezza disponibile
          SizedBox(
            width: double.infinity,
            child: Center(child: circlesWidget),
          ),
          const SizedBox(height: 24),
          // Se la lettura NFC è andata a buon fine, mostra il menu scrollabile a tutta larghezza
        ],
      ),
    );
  }
}

Future<Map<String, dynamic>> getDati(String objectId) async {
    ParseObject? cartellaClinica;
    final apiResponse =
        await ParseObject('CartellaClinica').getObject(objectId);
    if (apiResponse.success && apiResponse.results != null) {
      for (var o in apiResponse.results!) {
        cartellaClinica = o as ParseObject;
      }
    }

    String dati = cartellaClinica?.get<String>('dati') ?? "{}";
    Map<String, dynamic> datiSanitari = jsonDecode(dati);
    return datiSanitari;
  }