import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreerAnnoncePage extends StatefulWidget {
  const CreerAnnoncePage({super.key});

  @override
  State<CreerAnnoncePage> createState() => _CreerAnnoncePageState();
}

class _CreerAnnoncePageState extends State<CreerAnnoncePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titreController = TextEditingController();
  final TextEditingController _produitController = TextEditingController();
  final TextEditingController _quantiteController = TextEditingController();
  final TextEditingController _prixController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _placeController = TextEditingController();

  String _type = "Offre";

  Future<void> _saveAnnonce() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Veuillez vous connecter.')));
      return;
    }

    await FirebaseFirestore.instance.collection('annonces').add({
      'titre': _titreController.text.trim(),
      'produit': _produitController.text.trim(),
      'quantite': int.parse(_quantiteController.text.trim()),
      'prix': int.parse(_prixController.text.trim()),
      'contact': _contactController.text.trim(),
      'place': _placeController.text.trim(),
      'type': _type,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': user.uid,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Créer une annonce'),
        centerTitle: true,

        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: _titreController,
                    decoration: const InputDecoration(
                      labelText: "Titre de l'annonce",
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _produitController,
                    decoration: const InputDecoration(labelText: 'Produit'),
                    validator: (value) =>
                        value!.isEmpty ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _quantiteController,
                    decoration: const InputDecoration(
                      labelText: 'Quantité (kg)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _prixController,
                    decoration: const InputDecoration(
                      labelText: 'Prix souhaité (CFA)',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value!.isEmpty ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8),

                  TextFormField(
                    controller: _contactController,
                    decoration: const InputDecoration(labelText: 'Contact'),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        value!.isEmpty ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _placeController,
                    decoration: const InputDecoration(
                      labelText: 'Emplacement Exacte',
                    ),
                    validator: (value) =>
                        value!.isEmpty ? 'Ce champ est requis' : null,
                  ),
                  const SizedBox(height: 8),

                  DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(
                      labelText: 'Type d\'annonce',
                    ),
                    items: const [
                      DropdownMenuItem(value: "Offre", child: Text("Offre")),
                      DropdownMenuItem(
                        value: "Demande",
                        child: Text("Demande"),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _type = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    onPressed: _saveAnnonce,
                    child: const Text(
                      'Publier l\'annonce',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
