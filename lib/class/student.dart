class Student {
  final String id;
  final String name;
  final String program;
  final String nrp;
  final String photo;
  final String bio;

  Student({
    required this.id,
    required this.name,
    required this.program,
    required this.nrp,
    required this.photo,
    required this.bio,
  });
}

List<Student> students = [
  Student(
    id: "1",
    name: "Ahmad Rizki Pratama",
    program: "Teknik Informatika",
    nrp: "5025211001",
    photo: "https://i.pravatar.cc/150?img=11",
    bio:
        "Mahasiswa semester 6 Teknik Informatika dengan minat di bidang pengembangan web dan mobile. Aktif dalam organisasi kemahasiswaan dan memiliki pengalaman dalam proyek pengembangan aplikasi. Senang belajar teknologi baru dan berkolaborasi dalam tim.",
  ),
  Student(
    id: "2",
    name: "Made Arya Dharma",
    program: "Teknik Informatika",
    nrp: "5025211002",
    photo: "https://i.pravatar.cc/150?img=12",
    bio:
        "Mahasiswa yang bersemangat dalam dunia mobile development dan desain UI/UX. Memiliki pengalaman dalam membuat aplikasi Flutter dan tertarik mengembangkan solusi digital yang bermanfaat.",
  ),
  Student(
    id: "3",
    name: "Komang Dita Putri",
    program: "Teknik Informatika",
    nrp: "5025211003",
    photo: "https://i.pravatar.cc/150?img=13",
    bio:
        "Mahasiswi yang memiliki ketertarikan pada bidang kecerdasan buatan dan data science. Rajin mengikuti pelatihan dan kompetisi IT untuk meningkatkan kemampuan analisis data.",
  ),
];
