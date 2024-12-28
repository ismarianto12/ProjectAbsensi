import 'package:flutter/material.dart';

class Kehadiran extends StatefulWidget {
  @override
  _KehadiranState createState() => _KehadiranState();
}

class _KehadiranState extends State<Kehadiran> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('November'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.arrow_drop_down),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: 30,
              itemBuilder: (context, index) {
                return Center(
                  child: Text(
                    (index + 1).toString(),
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),
            const SizedBox(height: 16.0),
            // Attendance Summary
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Attendance Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: CircularProgressIndicator(
                                  value: 0.98,
                                  strokeWidth: 10,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.blue,
                                  ),
                                ),
                              ),
                              const Text(
                                '98%',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Total Days: 20'),
                              Text('Days Worked: 15'),
                              Text('Total Hours: 120h'),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        AttendanceStatusCard(
                          color: Colors.green,
                          title: '15',
                          subtitle: 'Present',
                        ),
                        AttendanceStatusCard(
                          color: Colors.blue,
                          title: '04',
                          subtitle: 'Early Leave',
                        ),
                        AttendanceStatusCard(
                          color: Colors.orange,
                          title: '02',
                          subtitle: 'Late',
                        ),
                        AttendanceStatusCard(
                          color: Colors.red,
                          title: '01',
                          subtitle: 'Absents',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttendanceStatusCard extends StatelessWidget {
  final Color color;
  final String title;
  final String subtitle;

  const AttendanceStatusCard({
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(subtitle),
      ],
    );
  }
}
