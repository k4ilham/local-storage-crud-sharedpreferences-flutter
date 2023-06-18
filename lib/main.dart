import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_storage_crud/add_data_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'edit_data_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DataContact(),
    );
  }
}

// ignore: use_key_in_widget_constructors
class DataContact extends StatefulWidget {
  @override
  State<DataContact> createState() => _DataContactState();
}

class _DataContactState extends State<DataContact> {
  //variabel data untuk menampung data dari local storage
  List<Map<String, String>> data = [];

  @override
  void initState() {
    super.initState();

    //saat state berubah jalankan fungsi getData
    getData();
  }

  // fungsi untuk mengambil data dari SharedPreferences
  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //digunakan untuk mendapatkan nilai dari SharedPreferences dengan kunci 'data'
    List<String> dataList = prefs.getStringList('data') ?? [];

    //variabel untuk menampung data yang sudah diparse
    List<Map<String, String>> parsedData = [];

    //melakukan perulangan dari dataList
    for (String dataItem in dataList) {
      //jsonDecode berfungsi untuk mengkonversi data json menjadi dart objek
      //data yang sudah dikonversi akan disimpan ke dalam variabel decoodedData
      Map<String, dynamic> decodedData = jsonDecode(dataItem);

      Map<String, String> parsedItem = {};

      //melakukan perulangan pada decodedData
      decodedData.forEach((key, value) {
        parsedItem[key] = value.toString();
      });

      //data yang sudah diparse ditambahkan ke parsedData
      parsedData.add(parsedItem);
    }

    //perubahan state, perbarui data
    setState(() {
      data = parsedData;
    });
  }

  //metode untuk menghapus data
  Future<void> deleteData(int index) async {
    //adalah metode yang digunakan untuk mendapatkan instance (instansiasi) objek SharedPreferences dalam Flutter.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //digunakan untuk mendapatkan nilai dari SharedPreferences dengan kunci 'data'
    List<String> dataList = prefs.getStringList('data') ?? [];

    //menghilangkan data dari dataList berdasarkan index
    dataList.removeAt(index);

    //set ulang local storage dengan data yang diperbarui
    prefs.setStringList('data', dataList);

    //jalankan fungsi getData
    getData();
  }

  //membuka halaman EditPage
  void openEditPage(Map<String, String> data) {
    Navigator.push(
      context,
      //fungsi untuk berpindah halaman
      MaterialPageRoute(
        //data adalah parameter yang dikirimkan dan akan ditampilkan di halaman openeditpage
        builder: (context) => EditDataPage(data: data),
      ),

      //fungsi yang akan dijalankan setelah proses update dijalankan
    ).then((_) {
      getData();
    });
  }

  //fungsi untuk membuka halaman addpage
  void openAddPage() {
    Navigator.push(
      context,
      //fungsi untuk berpindah halaman
      MaterialPageRoute(
        builder: (context) => AddDataPage(),
      ),

      //fungsi yang akan dijalankan setelah proses update dijalankan
    ).then((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact App'),
      ),
      //jika data kosong maka tampilkan tulisan belum ada data di tengah layar
      //jika data ada maka tampilkan datanya dengan listview builder
      body: data.isEmpty
          ? const Center(
              child: Text('Belum ada data'),
            )
          : ListView.builder(
              // Menampilkan daftar kontak dalam bentuk ListView
              itemCount: data.length, //total panjang data
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ListTile(
                    title:
                        Text('Name: ${data[index]['name']}'), //menampilkan nama
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            'Email: ${data[index]['email']}'), //menampilkan email
                        Text(
                            'Phone: ${data[index]['phoneNumber']}'), //menampilkan nomor telpon
                        Text(
                            'Address: ${data[index]['address']}'), //menampilkan alamat
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tombol edit untuk mengedit data
                        // saat ditekan akan menjalankan fungsi openEditPage dan membawa parameter
                        IconButton(
                          icon: const Icon(Icons.edit), //icon edit
                          onPressed: () => openEditPage(data[index]),
                        ),

                        // Tombol hapus untuk menghapus data
                        // saat ditekan akan menjalankan fungsi deleteData dan membawa parameter
                        IconButton(
                          icon: const Icon(Icons.delete), //icon delete
                          onPressed: () => deleteData(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openAddPage(),
        // ignore: sort_child_properties_last
        child: const Icon(Icons.add), // Ikona FAB
        backgroundColor: Colors.blue, // Warna latar belakang FAB
      ),
    );
  }
}
