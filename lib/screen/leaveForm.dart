import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:penjualan/bloc/cuti_bloc.dart';

class Leaveform extends StatefulWidget {
  const Leaveform({super.key});

  @override
  State<Leaveform> createState() => _LeaveformState();
}

class _LeaveformState extends State<Leaveform>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tujuanController = TextEditingController();
  final TextEditingController _tanggalMulaiController = TextEditingController();
  final TextEditingController _tanggalAkhirController = TextEditingController();

  TextEditingController _dilimpahkanke = TextEditingController();
  TextEditingController _keterangan = TextEditingController();

  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<Offset> _atas;

  Future<String?> selectDate({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2100),
    );
    if (pickedDate != null) {
      return "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Durasi transisi
      vsync: this,
    );
    _atas = Tween<Offset>(
      begin: Offset(0.0, -1.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Gunakan kurva animasi
    ));

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<CutiBloc, CutiState>(
        listener: (context, state) {
          if (state is CutistateSucces) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content:
                    Text('Form Cuti Berhasil di submit'), // Correct message
              ),
            );
          } else if (state is CutistateFail) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text('Form Cuti gagal di submit'), // Correct message
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Form Cuti Karyawan",
                          style: TextStyle(
                            fontSize: 25,
                          ),
                        ),
                        Text(
                          "Form Cuti Karyawan",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nama Karyawan"),
                      TextFormField(
                        controller: _namaController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text("Tujuan Cuti"),
                      TextFormField(
                        controller: _tujuanController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tujuan cuti wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text("Tanggal Mulai Cuti"),
                      TextFormField(
                        onTap: () async {
                          String? selectedDate = await selectDate(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (selectedDate != null) {
                            _tanggalMulaiController.text = selectedDate;
                          }
                        },
                        controller: _tanggalMulaiController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          hintText: "YYYY-MM-DD",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal mulai wajib diisi';
                          }
                          // Optional: Tambahkan validasi format tanggal
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text("Tanggal Akhir Cuti"),
                      TextFormField(
                        onTap: () async {
                          String? selectedDate = await selectDate(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );

                          if (selectedDate != null) {
                            _tanggalAkhirController.text = selectedDate;
                          }
                        },
                        controller: _tanggalAkhirController,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          hintText: "YYYY-MM-DD",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tanggal akhir wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      Text("Di limpahkan atas"),
                      TextFormField(
                        controller: _dilimpahkanke,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Tujuan cuti wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      Text("Catatan : "),
                      TextFormField(
                        controller: _keterangan,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3, // Text area dengan 5 baris
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Alasan Lain cuti wajib diisi';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      SlideTransition(
                        position: _atas,
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              final data = {
                                'nama': _namaController.text,
                                'tujuan': _tujuanController.text,
                                'tanggalMulai': _tanggalMulaiController.text,
                                'tanggalAkhir': _tanggalAkhirController.text,
                              };
                              context
                                  .read<CutiBloc>()
                                  .add(CutiEventSubmit(data: data));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                'Save Data',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
