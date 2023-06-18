import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDataPage extends StatefulWidget {
  final Map<String, String> data;
  // Variabel data sebagai parameter untuk EditDataPage

  // ignore: prefer_const_constructors_in_immutables, use_key_in_widget_constructors
  EditDataPage({required this.data});
  // Konstruktor EditDataPage dengan parameter data yang harus diberikan

  @override
  // ignore: library_private_types_in_public_api
  _EditDataPageState createState() => _EditDataPageState();
  // Membuat state EditDataPage
}

class _EditDataPageState extends State<EditDataPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // Membuat objek TextEditingController untuk mengendalikan input teks pada TextField

  @override
  void initState() {
    super.initState();
    initializeControllers();
    // Memanggil fungsi initializeControllers saat initState dipanggil
  }

  void initializeControllers() {
    nameController.text = widget.data['name'] ?? '';
    emailController.text = widget.data['email'] ?? '';
    phoneNumberController.text = widget.data['phoneNumber'] ?? '';
    addressController.text = widget.data['address'] ?? '';
    // Menetapkan nilai awal pada TextEditingController berdasarkan data yang diberikan
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Mendapatkan instance SharedPreferences

    List<String> dataList = prefs.getStringList('data') ?? [];
    // Mendapatkan daftar data dari SharedPreferences, jika tidak ada maka menggunakan list kosong

    Map<String, String> newData = {
      'name': nameController.text,
      'email': emailController.text,
      'phoneNumber': phoneNumberController.text,
      'address': addressController.text,
    };
    // Membuat map newData berisi data yang diperbarui dari TextEditingController

    int dataIndex = dataList.indexOf(jsonEncode(widget.data));
    // Mencari indeks data yang akan diperbarui dalam daftar menggunakan fungsi jsonEncode

    if (dataIndex != -1) {
      dataList[dataIndex] = jsonEncode(newData);
      // Jika data ditemukan, perbarui data tersebut dengan newData
    }

    prefs.setStringList('data', dataList);
    // Menyimpan daftar data yang diperbarui ke SharedPreferences

    // ignore: use_build_context_synchronously
    Navigator.pop(context);
    // Kembali ke halaman sebelumnya setelah data disimpan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'email'),
              ),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(labelText: 'phoneNumber'),
              ),
              TextFormField(
                controller: addressController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
              ElevatedButton(
                onPressed: saveData,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
