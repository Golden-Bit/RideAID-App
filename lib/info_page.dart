import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar con freccia indietro e titolo "Info"
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Info',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Logo in alto (placeholder)
              Center(child: Image.asset(
                'assets/images/aimc_logo.png', // <-- Sostituisci con percorso reale
                height: 100,
                fit: BoxFit.contain,
              )),
              const SizedBox(height: 24),

              // Testo centrale
              const Text(
                'For information and assistance,\ncontacts:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Email
              const Text(
                'Email: info@aaimc.eu',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),

              // Whatsapp
              const Text(
                'Whatsapp: 0039 345 5163677',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              // Privacy Policy
              const Text(
                'Privacy Policy',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blue, // Se vuoi evidenziare che è un link
                  decoration: TextDecoration.underline, // Se vuoi sottolinearlo
                ),
              ),

              const SizedBox(height: 40),

              // Logo in basso (placeholder)
              Center(child: Image.asset(
                'assets/images/cyberneid_logo.png', // <-- Sostituisci con percorso reale
                height: 80,
                fit: BoxFit.contain,
              )),

              const SizedBox(height: 8),

              // Testo sotto al logo
              /*const Text(
                'cyberneid and electronic identity turned on',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),*/

              const SizedBox(height: 40),

              // Versione
              const Text(
                'Versione: 1.0.0',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
