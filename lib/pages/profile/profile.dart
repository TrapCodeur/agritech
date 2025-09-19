import 'package:agritech/auth/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _domainController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();

  List<String> _selectedProduits = [];

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    if (user == null) return;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        _fullnameController.text = data["fullname"] ?? "";
        _phoneController.text = data["phone"] ?? "";
        _domainController.text = data["domaine"] ?? "";
        _whatsappController.text = data["whatsapp"] ?? "";
        _selectedProduits = List<String>.from(data["produits"] ?? []);
      });
    }
  }

  Future<void> _saveUserData() async {
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .update({
            "fullname": _fullnameController.text.trim(),
            "phone": _phoneController.text.trim(),
            "domaine": _domainController.text.trim(),
            "whatsapp": _whatsappController.text.trim(),
            "produits": _selectedProduits,
          });

      setState(() => _isEditing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Informations mises à jour avec succès"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Erreur : $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_isEditing) {
                _saveUserData();
              } else {
                setState(() => _isEditing = true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("assets/images/images.png"),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _fullnameController,
                decoration: const InputDecoration(labelText: "Prénom & Nom"),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: "Numéro de téléphone",
                ),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _domainController,
                decoration: const InputDecoration(
                  labelText: "Domaine d'activité",
                ),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _whatsappController,
                decoration: InputDecoration(
                  labelText: "Numéro WhatsApp",
                  prefixIcon: Image.asset("assets/images/whatsapp_logo.png"),
                ),
                enabled: _isEditing,
              ),
              const SizedBox(height: 10),
              MultiSelectDialogField(
                items: [
                  MultiSelectItem("Maïs", "Maïs"),
                  MultiSelectItem("Riz", "Riz"),
                  MultiSelectItem("Mil", "Mil"),
                  MultiSelectItem("Arachide", "Arachide"),
                  MultiSelectItem("Pomme de Cajou", "Pomme de Cajou"),
                  MultiSelectItem("Bissap Rouge", "Bissap Rouge"),
                  MultiSelectItem("Bissap Blanc", "Bissap Blanc"),
                  MultiSelectItem("Pomme de Terre", "Pomme de Terre"),
                  MultiSelectItem("Orange", "Orange"),
                  MultiSelectItem("Mangue", "Mangue"),
                  MultiSelectItem("Banana", "Banana"),
                  MultiSelectItem("Fraize", "Fraize"),
                ],
                title: const Text("Produits cultivés"),
                buttonText: const Text("Sélectionner les produits"),
                initialValue: _selectedProduits,
                onConfirm: (values) {
                  setState(() {
                    _selectedProduits = values.cast<String>();
                  });
                },
                searchable: true,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text("Déconnexion"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
