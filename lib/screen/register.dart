import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Variabel Global (Tetap sesuai gaya koding awal)
String _user_id = "";        // NRP
String _user_name = "";
String _user_email = "";
String _user_password = "";
String _repeat_password = "";
String _error_register = "";

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  void doRegister() async {
    // 🔒 validasi repeat password
    if (_user_password != _repeat_password) {
      setState(() {
        _error_register = "Password dan Repeat Password tidak sama";
      });
      return;
    }

    final response = await http.post(
      Uri.parse("https://ubaya.cloud/flutter/160422163/uas/register.php"),
      body: {
        'user_id': _user_id,        // NRP
        'user_name': _user_name,    // Nama
        'user_email': _user_email,  // Email
        'user_password': _user_password,
      },
    );

    if (response.statusCode == 200) {
      Map json = jsonDecode(response.body);

      if (json['result'] == 'success') {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Register berhasil, silakan login"),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // balik ke login
      } else {
        setState(() {
          _error_register = "Register gagal";
        });
      }
    } else {
      setState(() {
        _error_register = "Gagal terhubung ke server";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Background abu muda
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ================= HEADER ICON =================
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.person_add_outlined,
                size: 50,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Text(
              "Daftar Akun Baru",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "Lengkapi data diri mahasiswa",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // ================= FORM CARD =================
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    // NAMA LENGKAP
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap",
                        prefixIcon: const Icon(Icons.badge_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (v) => _user_name = v,
                    ),
                    const SizedBox(height: 15),

                    // NRP
                    TextField(
                      decoration: InputDecoration(
                        labelText: "NRP (User ID)",
                        prefixIcon: const Icon(Icons.school_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (v) => _user_id = v,
                    ),
                    const SizedBox(height: 15),

                    // EMAIL
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      onChanged: (v) => _user_email = v,
                    ),
                    const SizedBox(height: 15),

                    // PASSWORD
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Password",
                        prefixIcon: const Icon(Icons.lock_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      obscureText: true,
                      onChanged: (v) => _user_password = v,
                    ),
                    const SizedBox(height: 15),

                    // REPEAT PASSWORD
                    TextField(
                      decoration: InputDecoration(
                        labelText: "Ulangi Password",
                        prefixIcon: const Icon(Icons.lock_reset),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      obscureText: true,
                      onChanged: (v) => _repeat_password = v,
                    ),

                    // ERROR MESSAGE
                    const SizedBox(height: 10),
                    if (_error_register.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _error_register,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    else
                      const SizedBox(height: 10),

                    const SizedBox(height: 10),

                    // TOMBOL REGISTER
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          doRegister();
                        },
                        child: const Text(
                          "REGISTER",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}