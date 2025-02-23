import 'package:flutter/material.dart';
import 'package:ride_aid_app/info_page.dart';
import 'package:ride_aid_app/riders_list.dart';

// Aggiungiamo la SplashPage come prima pagina mostrata
void main() {
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

class _SplashPageState extends State<SplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    // Durata totale per animazione di ingresso e uscita
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    
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


/// La tua pagina principale rimane invariata,
//  salvo che non è più l'home diretta ma è richiamata
//  dalla SplashPage dopo 2 secondi.
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                          MaterialPageRoute(
                            builder: (context) => const InfoPage(),
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
              Text(
                'Raider AID',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 8),

              // Sottotitolo
              Text(
                'The first aid ally',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 32),

              // Testo esplicativo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  'Hold the device close to the NFC bracelet to access '
                  'essential first aid information. Every second counts.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Cerchio esterno + cerchio interno (entrambi cliccabili)
              GestureDetector(
                onTap: () {
                  // Al tap, mostriamo il bottom sheet
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
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
                        children: [
                          const Icon(
                            Icons.nfc,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Scan NFC',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Spazio finale
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

/// Widget che costruisce il contenuto del bottom sheet mostrato
/// quando si clicca su "Scan NFC".
class _NfcScanningBottomSheet extends StatelessWidget {
  const _NfcScanningBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color secondaryCircleColor = Color(0xFF0E4DA4);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Piccolo "handle" in alto per indicare che è un modal
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Titolo
          const Text(
            'Scan NFC Band',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          // Stato di scansione
          const Text(
            'Still looking...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 24),
          // Simulazione di un'animazione di scanning con più cerchi concentrici
          SizedBox(
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
                    border: Border.all(color: secondaryCircleColor, width: 1.5),
                  ),
                ),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: secondaryCircleColor, width: 1.5),
                  ),
                ),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: secondaryCircleColor, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.nfc,
                    color: secondaryCircleColor,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Testo descrittivo
          const Text(
            'Try moving NFC Band around to find the NFC reader on your device.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
