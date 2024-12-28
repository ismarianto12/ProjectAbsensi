import 'package:flutter/material.dart';
import 'package:penjualan/helper/Dbhelper.dart';

class TodolistController extends ChangeNotifier {
  final DBHelper _dbHelper = new DBHelper();
  List<Map<String, dynamic>> _todoItems = [];
  List<Map<String, dynamic>> get todoItems => _todoItems;

  TimeOfDay selectedTime = TimeOfDay.now();
  final TextEditingController timeController = TextEditingController();
  TextEditingController judultugas = TextEditingController();
  TextEditingController status = TextEditingController();
  TextEditingController catatan = TextEditingController();
  TextEditingController dari = TextEditingController();
  TextEditingController sampai = TextEditingController();

  void kosongform() {
    timeController.clear();
    judultugas.clear();
    status.clear();
    catatan.clear();
    dari.clear();
    sampai.clear();
    notifyListeners();
  }

  TodolistController() {
    timeController.text = _formatTime(selectedTime);
    _init();
  }

  void _init() async {
    await getData();
  }

  String _formatTime(TimeOfDay time) {
    final hours = time.hour.toString().padLeft(2, '0');
    final minutes = time.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }

  Future<void> selectTime(BuildContext context,
      {String parameter = 'dari'}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      if (parameter.contains("dari")) {
        dari.text = _formatTime(selectedTime);
      } else if (parameter.contains("sampai")) {
        sampai.text = _formatTime(selectedTime);
      } 
      notifyListeners();
    }
  }

  Future<dynamic> getData() async {
    final data = await _dbHelper.read("app_todolist");
    print("get data ===");
    print(data);
    _todoItems = List<Map<String, dynamic>>.from(data);
    notifyListeners();
    return _todoItems;
  }

  Future<void> saveData() async {
    await _dbHelper.initDatabase();
    // await _dbHelper.deleteAll("app_todolist");
    try {
      await _dbHelper.insert('app_todolist', {
        'title': judultugas.text,
        'notes': catatan.text,
        'status': "1",
        'dari': dari.text,
        'sampai': sampai.text,
      });
      kosongform();
      await getData();
      notifyListeners();
    } catch (e) {
      print("error response");
      print(e);
    }
  }
}
