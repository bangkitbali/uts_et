import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../main.dart'; // ambil active_user

class DetailProfile extends StatefulWidget {
  final String user_id;

  const DetailProfile({super.key, required this.user_id});

  @override
  State<DetailProfile> createState() => _DetailProfileState();
}

class _DetailProfileState extends State<DetailProfile> {
  Map<String, dynamic>? _user;

  @override
  void initState() {
    super.initState();
    bacaData();
  }

  // ================= FETCH DATA =================
  Future<void> bacaData() async {
    final response = await http.post(
      Uri.parse("https://ubaya.cloud/flutter/160422163/uas/get_profile.php"),
      body: {'user_id': widget.user_id},
    );

    if (response.statusCode == 200) {
      setState(() {
        _user = jsonDecode(response.body);
      });
    }
  }

  // ================= ADD FRIEND =================
  void addFriend() async {
    final response = await http.post(
      Uri.parse("https://ubaya.cloud/flutter/160422163/uas/add_friend.php"),
      body: {
        'sender_id': active_user,        // 🔥 SAMA PERSIS PHP
        'receiver_id': widget.user_id,   // 🔥 SAMA PERSIS PHP
      },
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      if (!mounted) return;

      if (json['result'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Permintaan pertemanan dikirim"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(json['message'] ?? "Gagal"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ================= TAMPIL DATA (UI DIPERBAGUS) =================
  Widget tampilData() {
    if (_user == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Column(
      children: [
        // Kartu Profil Utama
        Card(
          margin: const EdgeInsets.all(16),
          // Shape otomatis mengikuti tema global di main.dart
          child: Column(
            children: [
              // Bagian Header Foto & Nama
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.05),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).primaryColor,
                          width: 3,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.white,
                        backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?u=${_user!['user_id']}",
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _user!['user_name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "NRP: ${_user!['user_id']}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              // Bagian Detail Info
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.school, color: Colors.blue),
                      ),
                      title: const Text(
                        "Program / Lab",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _user!['user_program'] ?? "-",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const Divider(indent: 70, endIndent: 20),
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.text_snippet, color: Colors.amber),
                      ),
                      title: const Text(
                        "Biografi",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _user!['user_bio'] ?? "-",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ================= BUILD =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Profil")),
      body: ListView(
        children: [
          tampilData(),

          // ✏️ EDIT PROFILE (DIRI SENDIRI)
          if (widget.user_id == active_user)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    "Edit Profile",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      'edit_profile',
                    ).then((_) => bacaData());
                  },
                ),
              ),
            ),

          // ➕ ADD FRIEND (ORANG LAIN)
          if (widget.user_id != active_user)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                  ),
                  icon: const Icon(Icons.person_add),
                  label: const Text(
                    "Add Friend",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: addFriend,
                ),
              ),
            ),
          
          const SizedBox(height: 30), // Spasi bawah biar tidak mepet
        ],
      ),
    );
  }
}