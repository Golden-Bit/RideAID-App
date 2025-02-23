import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rider\'s Card Demo',
      debugShowCheckedModeBanner: false,
      home: const RidersCardPage(),
    );
  }
}

class RidersCardPage extends StatelessWidget {
  const RidersCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colori personalizzabili
    const Color primaryColor = Colors.white;
    const Color secondaryColor = Color(0xFF0E4DA4); // Blu scuro
    const Color cardBackgroundColor = Color(0xFFE7ECF3); // Azzurrino chiaro

    // Lista di pazienti (esempio ripetuto 5 volte)
    final List<Map<String, String>> patients = [
      {
        'name': 'Valentino Rossi',
        'date': '12/01/25 - data incidente',
      },
      {
        'name': 'Valentino Rossi',
        'date': '12/01/25 - data incidente',
      },
      {
        'name': 'Valentino Rossi',
        'date': '12/01/25 - data incidente',
      },
      {
        'name': 'Valentino Rossi',
        'date': '12/01/25 - data incidente',
      },
      {
        'name': 'Valentino Rossi',
        'date': '12/01/25 - data incidente',
      },
    ];

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            // TODO: Implementare logica di "torna indietro"
          },
        ),
        title: const Text(
          'Rider\'s card',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: cardBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    // Icona di “borsa medica” o “folder”
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.medical_services, // Sostituisci con l'icona desiderata
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Testo con nome e data
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            patient['date'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icona di “visualizzazione” (occhio)
                    IconButton(
                      onPressed: () {
                        // TODO: Azione da definire
                      },
                      icon: Icon(
                        Icons.remove_red_eye_outlined,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
