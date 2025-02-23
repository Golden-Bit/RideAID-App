import 'package:flutter/material.dart';
import 'package:ride_aid_app/raider_viewer.dart';

class RidersCardPage extends StatelessWidget {
  const RidersCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colori personalizzabili
    const Color primaryColor = Colors.white;
    const Color secondaryColor = Color(0xFF0E4DA4); // Blu scuro
    const Color cardBackgroundColor = Color(0xFFE7ECF3); // Azzurrino chiaro

    // Lista di pazienti (corridori). Ognuno con TUTTI i dati richiesti
    final List<Map<String, dynamic>> patients = [
      {
        'name': 'Valentino Rossi',
        'birthDate': '05/07/1997',
        'emergencyContactName': 'Paolo Merletto',
        'emergencyContactPhone': '+39 456 5467 567',
        'bloodType': 'A-',
        'coagulationDisorders':
            'Hemophilia A (clotting disorder). Regular factor replacement therapy.',
        'allergies':
            'I am allergic to dust and pollen, which can trigger respiratory issues. I carry antihistamines with me in case of an allergic attack.',
        'relevantConditions':
            'I have a history of asthma, triggered by high levels of dust or smoke. I always have my inhaler on hand.',
        'ongoingTreatments': 'Smoker: Yes',
        'typeOfSurgery':
            'I underwent knee surgery in 2018 due to an ACL tear. The recovery was successful, and I have no complications so far.',
        'incidentDate': '12/01/25 - data incidente',
      },
      {
        'name': 'Jorge Lorenzo',
        'birthDate': '04/05/1987',
        'emergencyContactName': 'Luca Bianchi',
        'emergencyContactPhone': '+39 123 4567 890',
        'bloodType': '0+',
        'coagulationDisorders': 'No known disorders.',
        'allergies': 'Allergic to bee stings.',
        'relevantConditions': 'None.',
        'ongoingTreatments': 'Smoker: No',
        'typeOfSurgery': 'No past surgeries.',
        'incidentDate': '15/02/25 - data incidente',
      },
      {
        'name': 'Marc Marquez',
        'birthDate': '17/02/1993',
        'emergencyContactName': 'Ana Garcia',
        'emergencyContactPhone': '+34 555 7890 123',
        'bloodType': 'B+',
        'coagulationDisorders': 'No known disorders.',
        'allergies':
            'Allergic to certain antibiotics. Must avoid penicillin-based medications.',
        'relevantConditions': 'History of minor shoulder dislocations.',
        'ongoingTreatments': 'Physiotherapy for shoulder reinforcement.',
        'typeOfSurgery':
            'Shoulder surgery in 2020 due to repeated dislocations. Fully recovered.',
        'incidentDate': '20/03/25 - data incidente',
      },
      {
        'name': 'Dani Pedrosa',
        'birthDate': '29/09/1985',
        'emergencyContactName': 'Marco Rossi',
        'emergencyContactPhone': '+39 987 6543 210',
        'bloodType': 'AB+',
        'coagulationDisorders': 'No known disorders.',
        'allergies': 'Mild dust allergy.',
        'relevantConditions': 'Tends to have low blood pressure.',
        'ongoingTreatments': 'None currently.',
        'typeOfSurgery':
            'Fractured collarbone surgery in 2015. No further complications.',
        'incidentDate': '10/04/25 - data incidente',
      },
      {
        'name': 'Casey Stoner',
        'birthDate': '16/10/1985',
        'emergencyContactName': 'Andrea Verdi',
        'emergencyContactPhone': '+39 444 1111 222',
        'bloodType': 'A+',
        'coagulationDisorders': 'No known disorders.',
        'allergies':
            'Allergic to shellfish, which can cause severe reactions if ingested.',
        'relevantConditions': 'Some episodes of chronic fatigue.',
        'ongoingTreatments': 'Vitamin supplements and rest.',
        'typeOfSurgery': 'No major surgeries in the past.',
        'incidentDate': '25/05/25 - data incidente',
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
            // Ritorna alla pagina precedente
            Navigator.pop(context);
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
                        Icons.medical_services, // Puoi sostituire con l'icona desiderata
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
                            patient['incidentDate'] ?? '',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Icona di “visualizzazione” (occhio) -> pagina dettaglio
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RiderDetailPage(riderData: patient),
                          ),
                        );
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
