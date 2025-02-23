import 'package:flutter/material.dart';

class RiderDetailPage extends StatelessWidget {
  final Map<String, dynamic> riderData;

  const RiderDetailPage({Key? key, required this.riderData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colori per lo stile richiesto
    final Color borderColor = Colors.grey[800]!;       // Bordi grigio scuro
    final Color backgroundCardColor = Colors.grey[200]!; // Sfondo grigio chiaro
    final Color textColor = Colors.black54;              // Testo secondario
    final Color sectionTitleColor = Colors.black87;      // Titoli di sezione

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            // Riquadro con bordo grigio scuro e sfondo grigio chiaro
            decoration: BoxDecoration(
              color: backgroundCardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(0),
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(color: borderColor, width: 1.5),
            ),
            child: Stack(
              children: [
                // Contenuto principale
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Riga con nome a sinistra e icona di chiusura in alto a destra
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              riderData['name'] ?? '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              size: 24,
                              color: Colors.black87,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Sezione: Rider's data
                      const Text(
                        "Rider's data",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletLine("Birth date ${riderData['birthDate'] ?? ''}", textColor),
                      _buildBulletLine(
                        "Emergency contact ${riderData['emergencyContactName'] ?? ''} "
                        "${riderData['emergencyContactPhone'] ?? ''}",
                        textColor,
                      ),
                      const SizedBox(height: 16),

                      // Sezione: Essential medical information
                      const Text(
                        "Essential medical information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletLine("Blood type ${riderData['bloodType'] ?? ''}", textColor),
                      _buildBulletLine(
                        "Coagulation disorders ${riderData['coagulationDisorders'] ?? ''}",
                        textColor,
                      ),
                      _buildBulletLine(riderData['allergies'] ?? '', textColor),
                      const SizedBox(height: 16),

                      // Sezione: Pre-existing health conditions
                      const Text(
                        "Pre-existing health conditions",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletLine(
                        "Relevant conditions ${riderData['relevantConditions'] ?? ''}",
                        textColor,
                      ),
                      _buildBulletLine(
                        "Ongoing treatments ${riderData['ongoingTreatments'] ?? ''}",
                        textColor,
                      ),
                      const SizedBox(height: 16),

                      // Sezione: Past surgical operations
                      const Text(
                        "Past surgical operations",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildBulletLine(
                        "Type of surgery ${riderData['typeOfSurgery'] ?? ''}",
                        textColor,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Widget di comodo per visualizzare una riga con "•" (bullet)
  Widget _buildBulletLine(String text, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "• ",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
