import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _namaController = TextEditingController(
    text: "Trianda Zevania",
  );
  final TextEditingController _bioController = TextEditingController(
    text:
        "Mahasiswa semester 6 Teknik Informatika dengan minat di bidang pengembangan web dan mobile. Aktif dalam organisasi kampus dan menyukai tantangan baru.",
  );

  // daftar pilihan program
  String? _selectedProgram = "Teknik Informatika";
  final List<String> _programList = <String>[
    "Teknik Informatika",
    "Teknik Komputer",
    "Sistem Informasi",
    "Teknologi Informasi",
  ];

  // fungsi untuk menampilkan pop-up dan kembali ke home
  void _saveProfile() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Berhasil"),
          content: const Text("Data berhasil diperbarui"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // tutup dialog
                Navigator.popAndPushNamed(context, 'home'); // kembali ke home
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Update Profil"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/300?img=68",
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Nama Lengkap
            buildTextField("Nama Lengkap", _namaController, Icons.person),
            const SizedBox(height: 16),

            // Program / Lab (combo box)
            InputDecorator(
              decoration: const InputDecoration(
                labelText: "Program/Lab",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.school),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedProgram ?? "Teknik Informatika",
                  isExpanded: true,
                  items: _programList.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedProgram = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Biografi
            TextField(
              controller: _bioController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Biografi",
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.text_snippet),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),

            // Tombol Batal & Simpan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Simpan Perubahan"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    TextEditingController controller,
    IconData icon,
  ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
