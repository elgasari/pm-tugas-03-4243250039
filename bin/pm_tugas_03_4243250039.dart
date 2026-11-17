
import 'dart:io';

// ==========================================
// 1. CLASS DATA MATA KULIAH
// ==========================================

class MataKuliah {
  String nama;
  int sks;
  String nilai;

  MataKuliah(this.nama, this.sks, this.nilai);
}

// ==========================================
// 2. FUNGSI MENGUBAH NILAI MENJADI BOBOT
// ==========================================


int bobot(String huruf) {
  switch (huruf.toUpperCase()) {
    case 'A':
      return 4;
    case 'B':
      return 3;
    case 'C':
      return 2;
    case 'E':
      return 0;
    default:
      throw FormatException('Nilai huruf tidak valid');
  }
}

// ==========================================
// 3. FUNGSI VALIDASI INPUT
// ==========================================

void validasi(int sks, String nilai) {
  if (sks < 1 || sks > 6) {
    throw FormatException('SKS harus berupa angka 1-6');
  }

  bobot(nilai);
}

// ==========================================
// 4. FUNGSI MENGHITUNG IP SEMESTER
// ==========================================

double hitungIp(List<MataKuliah> data) {
  int totalSks = data.fold(
    0,
    (jumlah, mk) => jumlah + mk.sks,
  );

  int totalBobot = data.fold(
    0,
    (jumlah, mk) =>
        jumlah + (mk.sks * bobot(mk.nilai)),
  );

  if (totalSks == 0) {
    return 0;
  }

  return totalBobot / totalSks;
}

// ==========================================
// 5. FUNGSI MENENTUKAN PREDIKAT IP
// ==========================================

String predikat(double ip) {
  if (ip >= 3.50) {
    return 'Sangat Memuaskan';
  } else if (ip >= 3.00) {
    return 'Memuaskan';
  } else if (ip >= 2.00) {
    return 'Cukup';
  } else {
    return 'Perlu Perbaikan';
  }
}

// ==========================================
// 6. FUNGSI MENCETAK KARTU HASIL STUDI
// ==========================================

void cetakKhs(
  List<MataKuliah> data, {
  bool urutkan = false,
}) {
  var daftar = List<MataKuliah>.from(data);

  // Mengurutkan nilai dari tertinggi
  if (urutkan) {
    daftar.sort(
      (a, b) => bobot(b.nilai).compareTo(
        bobot(a.nilai),
      ),
    );
  }

  print('\n========================================');
  print('          KARTU HASIL STUDI');
  print('========================================');

  print('Mata Kuliah              SKS   Nilai');
  print('----------------------------------------');

  for (var mk in daftar) {
    print(
      '${mk.nama.padRight(25)} ${mk.sks}      ${mk.nilai}',
    );
  }

  // Menghitung total SKS
  int totalSks = daftar.fold(
    0,
    (jumlah, mk) => jumlah + mk.sks,
  );

  // Menghitung IP
  double ip = hitungIp(daftar);

  print('----------------------------------------');
  print('Total SKS : $totalSks');
  print('IP        : ${ip.toStringAsFixed(2)}');
  print('Predikat  : ${predikat(ip)}');

  // Menampilkan mata kuliah dengan bobot di bawah 2
  var perluDiperbaiki = daftar.where(
    (mk) => bobot(mk.nilai) < 2,
  ).toList();

  if (perluDiperbaiki.isNotEmpty) {
    print('\nPerlu diperbaiki:');

    for (var mk in perluDiperbaiki) {
      print('- ${mk.nama}');
    }
  }

  print('========================================');
}

// ==========================================
// 7. PROGRAM UTAMA
// ==========================================

void main() {
  List<MataKuliah> data = [];

  print('========================================');
  print('       KALKULATOR IP SEMESTER');
  print('========================================');

  print('Masukkan data mata kuliah.');
  print('Kosongkan nama mata kuliah untuk selesai.');

  while (true) {
    stdout.write('\nNama MK : ');
    String nama = stdin.readLineSync() ?? '';

    if (nama.trim().isEmpty) {
      break;
    }

    try {
      stdout.write('SKS     : ');
      int? sks = int.tryParse(
        stdin.readLineSync() ?? '',
      );

      if (sks == null) {
        throw FormatException(
          'SKS harus berupa angka',
        );
      }

      stdout.write('Nilai   : ');
      String nilai = (stdin.readLineSync() ?? '')
          .trim()
          .toUpperCase();

      // Memvalidasi data
      validasi(sks, nilai);

      // Menambahkan data mata kuliah
      data.add(
        MataKuliah(nama.trim(), sks, nilai),
      );

      print('Data berhasil ditambahkan.');

    } catch (e) {
      print('Data diabaikan: $e');
    }
  }

  // Menampilkan KHS yang sudah diurutkan
  cetakKhs(data, urutkan: true);

  print('\nProgram Kalkulator IP Semester selesai.');
}
