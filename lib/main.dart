import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'screen/contacts.dart';
import 'screen/requests.dart';

import 'screen/home.dart';
import 'screen/edit_profile.dart';
import 'screen/login.dart';

String active_user = "";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  checkUser().then((String result) {
    if (result == '') {
      runApp(const MyLogin());
    } else {
      active_user = result; // SIMPAN NRP
      runApp(const MyApp());
    }
  });
}

Future<String> checkUser() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString("user_id") ?? '';
}

void doLogout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove("user_id");
  main();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UAS Flutter Project',
      // 🔥 UPDATE TEMA GLOBAL DI SINI
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A237E), // Biru Tua Indigo
          secondary: Colors.amber, // Warna aksen
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100], // Background abu muda
        
        // Mengatur gaya AppBar secara global
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A237E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        
        // Mengatur gaya Drawer
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      home: const MyHomePage(title: 'Daftar Mahasiswa'),
      routes: {
        'home': (context) => const MyHomePage(title: 'Daftar Mahasiswa'),
        'edit_profile': (context) => const EditProfileScreen(),
        'contacts': (context) => const ContactsScreen(),
        'requests': (context) => const RequestsScreen(),
        'login': (context) => const MyLogin(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // 🔥 DATA DRAWER (DARI DATABASE)
  String drawerName = "";
  String drawerEmail = "";

  @override
  void initState() {
    super.initState();
    loadDrawerUser();
  }

  // 🔥 AMBIL DATA USER LOGIN
  Future<void> loadDrawerUser() async {
    final prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString("user_id") ?? "";

    try {
      final response = await http.post(
        Uri.parse("https://ubaya.cloud/flutter/160422163/uas/get_profile.php"),
        body: {'user_id': user_id},
      );

      if (response.statusCode == 200) {
        Map json = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            drawerName = json['user_name'] ?? "Mahasiswa";
            drawerEmail = json['user_email'] ?? user_id;
          });
        }
      }
    } catch (e) {
      print("Error loading drawer: $e");
    }
  }

  Drawer myDrawer() {
    return Drawer(
      elevation: 16,
      child: Column(
        children: <Widget>[
          // HEADER DRAWER DIPERCANTIK
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1A237E), Color(0xFF3949AB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            accountName: Text(
              drawerName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            accountEmail: Text(drawerEmail),
            currentAccountPicture: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const CircleAvatar(
                backgroundImage: NetworkImage("https://i.pravatar.cc/150"),
              ),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            onTap: () {
              // Jika sudah di home, cukup tutup drawer (UX lebih baik)
              Navigator.pop(context); 
            },
          ),

          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Profile"),
            onTap: () {
              Navigator.popAndPushNamed(context, 'edit_profile');
            },
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Contacts"),
            onTap: () {
              Navigator.popAndPushNamed(context, 'contacts');
            },
          ),

          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text("Requests"),
            onTap: () {
              Navigator.popAndPushNamed(context, 'requests');
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove("user_id");

              if (!mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const MyLogin()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // Warna diambil otomatis dari Theme global
      ),
      drawer: myDrawer(),
      body: const Home(),
    );
  }
}