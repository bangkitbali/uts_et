import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class RequestsScreen extends StatefulWidget {
  const RequestsScreen({super.key});

  @override
  State<RequestsScreen> createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<RequestsScreen> {
  List requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequests();
  }

  // ================= GET REQUEST =================
  Future<void> fetchRequests() async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString("user_id") ?? "";

    // Debugging print tetap ada sesuai aslinya
    print("DEBUG: Mengirim NRP = $userId");

    try {
      final response = await http.post(
        Uri.parse("https://ubaya.cloud/flutter/160422163/uas/get_requests.php"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode({"user_id": userId}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("DATA DITERIMA: $data");
        
        // Pastikan widget masih mounted sebelum setState (best practice)
        if (mounted) {
          setState(() {
            requests = data;
          });
        }
      } else {
        print("ERROR SERVER: ${response.statusCode}");
        print("BODY: ${response.body}");
      }
    } catch (e) {
      print("ERROR KONEKSI: $e");
    }
  }

  // ================= UPDATE STATUS =================
  Future<void> updateRequest(int id, String status) async {
    await http.post(
      Uri.parse("https://ubaya.cloud/flutter/160422163/uas/update_friend.php"),
      body: {'id': id.toString(), 'status': status},
    );

    fetchRequests(); // refresh list setelah update
  }

  // ================= UI (DIPERBAGUS) =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background abu muda
      appBar: AppBar(title: const Text("Friend Requests")),
      body: requests.isEmpty
          ? Center(
              // Tampilan kosong lebih menarik
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  const Text(
                    "Tidak ada permintaan pertemanan",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: requests.length,
              itemBuilder: (context, index) {
                final req = requests[index];

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      children: [
                        // Bagian Info User
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).primaryColor,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                "https://i.pravatar.cc/150?u=${req['sender_id']}",
                              ),
                            ),
                          ),
                          title: Text(
                            req['user_name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text("NRP: ${req['sender_id']}"),
                        ),
                        
                        const Divider(),
                        
                        // Bagian Tombol Aksi (Terima / Tolak)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Tombol Tolak
                            OutlinedButton.icon(
                              onPressed: () {
                                updateRequest(req['id'], 'rejected');
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              icon: const Icon(Icons.close, size: 18),
                              label: const Text("Tolak"),
                            ),
                            const SizedBox(width: 10),
                            
                            // Tombol Terima
                            ElevatedButton.icon(
                              onPressed: () {
                                updateRequest(req['id'], 'accepted');
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                              ),
                              icon: const Icon(Icons.check, size: 18),
                              label: const Text("Terima"),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}