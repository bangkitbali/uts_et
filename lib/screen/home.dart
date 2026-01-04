import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detail.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  void fetchUsers() async {
    final response = await http.get(
      Uri.parse("https://ubaya.cloud/flutter/160422163/uas/get_users.php"),
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);
      setState(() {
        users = json['data'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Saya ganti strukturnya sedikit agar scroll lebih mulus pakai ListView.builder
    // dan menghapus warna background hitam agar sesuai tema aplikasi (Light Theme)
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background abu muda biar Card menonjol
      body: users.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        // Avatar dengan Border Warna Tema
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              width: 3,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              "https://i.pravatar.cc/150?u=${user['user_id']}",
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Nama User
                        Text(
                          user['user_name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        
                        // NRP
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: Text(
                            "NRP: ${user['user_id']}",
                            style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Tombol Lihat Detail
                        SizedBox(
                          width: double.infinity, // Tombol selebar kartu
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor, // Warna Biru Tema
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      DetailProfile(user_id: user['user_id']),
                                ),
                              );
                            },
                            child: const Text(
                              "Lihat Detail Profil",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}