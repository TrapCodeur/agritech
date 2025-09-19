import 'package:agritech/pages/component/annonces/add_announcement.dart';
import 'package:agritech/pages/component/annonces/update_announcement.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScreenAnnonces extends StatelessWidget {
  const ScreenAnnonces({super.key});

  Color _getTypeColor(String type) {
    return type == "Offre" ? Colors.green : Colors.orange;
  }

  Future<void> _deleteAnnonce(String id) async {
    await FirebaseFirestore.instance.collection('annonces').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Annonces',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('annonces')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Aucune annonce n'est disponible pour le moment..."),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final type = data['type'] ?? 'Offre';
              final isOwner =
                  currentUser != null && data['userId'] == currentUser.uid;

              return Stack(
                children: [
                  Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data['titre'] ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (isOwner)
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ModifierAnnoncePage(
                                                  annonceId: doc.id,
                                                  data:
                                                      doc.data()
                                                          as Map<
                                                            String,
                                                            dynamic
                                                          >,
                                                ),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                "Voulez-vous supprimer cette anonnce",
                                              ),
                                              content: SingleChildScrollView(
                                                child: ListBody(
                                                  children: <Widget>[
                                                    Text(
                                                      "Cette action est irrévéssible",
                                                    ),
                                                    Text(
                                                      "Cliquer sur supprimer pour confirmer la suppression",
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    _deleteAnnonce(doc.id);
                                                  },
                                                  child: Text("Supprimer"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Annuler"),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text("Produit : ${data['produit']}"),
                          Text("Quantité : ${data['quantite']} kg"),
                          Text("Prix : ${data['prix']} CFA/kg"),
                          Row(
                            children: [
                              Text(data['place']),
                              SizedBox(width: 20),
                              Text("Contact : ${data['contact']}"),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Il y'a "),
                              SizedBox(width: 8),
                              Text(FieldValue.serverTimestamp() as String),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Badge Offre ou Demande
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: _getTypeColor(type),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        type,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          );
        },
      ),
      // bouton pour creer une annonce
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreerAnnoncePage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Créer une annonce'),
      ),
    );
  }
}
