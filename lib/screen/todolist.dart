import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:penjualan/controllers/todolistController.dart';
import 'package:provider/provider.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final _globalkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  void _taskGet(TodolistController todolistController) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 1900,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                    height: 10,
                    width: MediaQuery.sizeOf(context).width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black12,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Tambah Tugas",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _globalkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: todolistController.judultugas,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Alasan Lain cuti wajib diisi';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            label: Text("Judul Tugas"),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: todolistController.catatan,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'status';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            // rows:2,
                            isDense: true,
                            border: OutlineInputBorder(),
                            label: Text("Catatan tugas"),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              child: TextFormField(
                                readOnly: true,
                                controller: todolistController.dari,
                                onTap: () async {
                                  await todolistController.selectTime(context,
                                      parameter: 'dari');
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Alasan Lain cuti wajib diisi';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  label: Text("Waktu Mulai"),
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              child: TextFormField(
                                readOnly: true,
                                controller: todolistController.sampai,
                                onTap: () async {
                                  await todolistController.selectTime(context,parameter:  'sampai');
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Alasan Lain cuti wajib diisi';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(),
                                  label: Text("Waktu Berakhir"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                          onPressed: () {
                            if (_globalkey.currentState!.validate()) {
                              todolistController.saveData();
                              Navigator.pop(context);
                            } else {}
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.save),
                                  Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TodolistController(),
      child: Consumer<TodolistController>(
        builder: (context, todolistController, _) {
          return Scaffold(
            backgroundColor: Colors.blue,
            floatingActionButton: FloatingActionButton(
              onPressed: () => _taskGet(todolistController),
              child: const Icon(Icons.add),
            ),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () => {
                                  Navigator.pop(context),
                                },
                            child: Icon(Icons.arrow_back, color: Colors.white)),
                        Icon(Icons.more_vert, color: Colors.white),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.assignment,
                            color: Colors.white, size: 40),
                        const SizedBox(height: 16),
                        const Text(
                          "All Task list",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          " Tugas Hari ini ..",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: todolistController.todoItems.length,
                          itemBuilder: (context, index) {
                            final item = todolistController.todoItems[index];
                            return Card(
                              child: ListTile(
                                title: Text(item['title']),
                                trailing: Text(item['notes']),
                                subtitle:
                                    Text("${item['dari']} s/d ${item['sampai']}"),
                              ),
                            );
                          },
                        ),
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
