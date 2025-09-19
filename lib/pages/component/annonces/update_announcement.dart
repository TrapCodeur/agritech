import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ModifierAnnoncePage extends StatefulWidget {
  final String annonceId;
  final Map<String, dynamic> data;

  const ModifierAnnoncePage({
    super.key,
    required this.annonceId,
    required this.data,
  });

  @override
  State<ModifierAnnoncePage> createState() => _ModifierAnnoncePageState();
}

class _ModifierAnnoncePageState extends State<ModifierAnnoncePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titreController;
  late TextEditingController _produitController;
  late TextEditingController _quantiteController;
  late TextEditingController _prixController;
  late TextEditingController _contactController;

  String _type = "Offre";

  @override
  void initState() {
    super.initState();
    _titreController = TextEditingController(text: widget.data['titre']);
    _produitController = TextEditingController(text: widget.data['produit']);
    _quantiteController = TextEditingController(
      text: widget.data['quantite'].toString(),
    );
    _prixController = TextEditingController(
      text: widget.data['prix'].toString(),
    );
    _contactController = TextEditingController(text: widget.data['contact']);
    _type = widget.data['type'];
  }

  Future<void> _updateAnnonce() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance
        .collection('annonces')
        .doc(widget.annonceId)
        .update({
          'titre': _titreController.text.trim(),
          'produit': _produitController.text.trim(),
          'quantite': int.parse(_quantiteController.text.trim()),
          'prix': int.parse(_prixController.text.trim()),
          'contact': _contactController.text.trim(),
          'type': _type,
          'updatedAt': FieldValue.serverTimestamp(),
        });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'annonce'),
        centerTitle: true,

        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titreController,
                decoration: const InputDecoration(
                  labelText: "Titre de l'annonce",
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _produitController,
                decoration: const InputDecoration(labelText: 'Produit'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantiteController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Quantité (kg)'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _prixController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Prix (CFA)'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Contact'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _type,
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: "Offre", child: Text("Offre")),
                  DropdownMenuItem(value: "Demande", child: Text("Demande")),
                ],
                onChanged: (value) => setState(() => _type = value!),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: _updateAnnonce,
                child: const Text(
                  'Modifier l\'annonce',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
