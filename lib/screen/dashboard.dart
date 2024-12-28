import 'dart:async';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:penjualan/screen/absens_scan.dart';
import 'package:penjualan/screen/introscreen.dart';
import 'package:penjualan/screen/kehadiran.dart';
import 'package:penjualan/screen/leaveForm.dart';
import 'package:penjualan/screen/todolist.dart';
import 'package:penjualan/utils/Pushtoslide.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _atas;

  int _selectedPage = 0;

  late Timer _timer;

  String _currentTime = '';
  String formattedDate = "";

  @override
  void initState() {
    super.initState();
    print("_selectedPage");
    print(_selectedPage);
    final now = DateTime.now();
    formattedDate = DateFormat('EEE dd MMM').format(now); // Format: Mon 25 Nov

    _updateTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });

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

  void _onTapped(int ontapped) {
    setState(() {
      _selectedPage = ontapped;
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    final formatter = DateFormat('hh:mm:ss a');
    setState(() {
      _currentTime = formatter.format(now);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              SlideTransition(
                position: _atas,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  color: Colors.blue[800],
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: AssetImage(
                                    'assets/profile.jpg'), // Ganti dengan path gambar Anda
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 40,
                              ),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        'Ismarianto',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Full stack developer',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              navigatePush(context, Introscreen(),
                                  direction: 'right');
                            },
                            child: Icon(
                              Icons.notification_add,
                              color: Colors.white,
                              size: 25,
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.14,
                  ),
                  SlideTransition(
                    position: _atas,
                    child: Container(
                      margin: EdgeInsets.all(20),
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                'Attendances',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "22 May 2024",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _currentTime,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: const [
                              Icon(Icons.wb_sunny, color: Colors.orange),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  "Good Morning Catherine. You haven't check in yet.",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                navigatePush(context, FaceDetectionScreen(),
                                    direction: "left");
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3),
                              ),
                              child: const Text(
                                'Check In',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIconButton('Attendance', Icons.calendar_today),
                GestureDetector(
                    onTap: () {
                      navigatePush(context, Kehadiran());
                    },
                    child: _buildIconButton('Meetings', Icons.people)),
                GestureDetector(
                    onTap: () {
                      navigatePush(context, Leaveform(), direction: 'top');
                    },
                    child: _buildIconButton('Leave', Icons.event_available)),
                GestureDetector(
                  onTap: () {
                    navigatePush(context, TaskScreen(), direction: 'top');
                  },
                  child: _buildIconButton('Todo List', Icons.check_box),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildActivityTile(
                    'Check In', 'Nov 24, 2024', '09:00 am', 'On Time'),
                _buildActivityTile(
                    'Break In', 'Nov 24, 2024', '1:00 pm', 'On Time'),
                _buildActivityTile(
                    'Check Out', 'Nov 24, 2024', '6:00 pm', 'On Time'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedPage,
        onTap: (int ontapped) {
          _onTapped(ontapped);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'More',
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(String label, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(icon, color: Colors.blue),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildActivityTile(
      String title, String date, String time, String status) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ],
        ),
        child: ListTile(
          leading: Icon(Icons.access_time, color: Colors.blue),
          title: Text(title),
          subtitle: Text(date),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(time, style: TextStyle(fontWeight: FontWeight.bold)),
              Text(status, style: TextStyle(color: Colors.green)),
            ],
          ),
        ),
      ),
    );
  }
}
