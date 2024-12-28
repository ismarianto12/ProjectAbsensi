import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:penjualan/controllers/absenController.dart';

class FaceDetectionScreen extends StatefulWidget {
  @override
  _FaceDetectionScreenState createState() => _FaceDetectionScreenState();
}

class _FaceDetectionScreenState extends State<FaceDetectionScreen> {
  late List<CameraDescription> cameras;
  late CameraController _controller;
  final _absencontroller = new Absencontroller();
  int selected = 0;

  bool _isProcessing = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _initializeCamera();
  }

  void _updateselected(int param) {
    setState(() {
      selected = param;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    print('Current position: ${position.latitude}, ${position.longitude}');
  }

  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras.isNotEmpty) {
        _controller = CameraController(cameras[0], ResolutionPreset.medium);
        await _controller.initialize();
        if (!mounted) return;
        setState(() {
          _isCameraInitialized = true;
        });
      } else {
        throw Exception("No cameras available");
      }
    } catch (e) {
      _showDialog("Error", "Failed to initialize camera: $e");
    }
  }

  @override
  void dispose() {
    if (_isCameraInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }

  Future<void> _captureAndSendData() async {
    if (_isProcessing || !_isCameraInitialized) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      final file = await _controller.takePicture();
      final position = await Geolocator.getCurrentPosition();
      await _absencontroller.sendData(
          File(file.path), position.latitude, position.longitude);
      _showDialog("Sukses", "Data berhasil dikirim.");
    } catch (e) {
      _showDialog("Error", e.toString());
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Deteksi Wajah & Lokasi")),
      body: _isCameraInitialized
          ? Column(
              children: [
                Stack(
                  children: [
                    CameraPreview(_controller),
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _captureAndSendData,
                        child: Text(
                            _isProcessing ? "Memproses..." : "Ambil Gambar"),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 500,
                  left: 20,
                  right: 20,
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _updateselected(1);
                          },
                          child: Container(
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Icon(
                                    Icons.login,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    "ABSEN \nKELUAR",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            height: 100,
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            decoration: BoxDecoration(
                                border: selected == 1
                                    ? Border.all(
                                        width: 5,
                                        color: Color.fromARGB(255, 184, 10, 10),
                                      )
                                    : null,
                                color: Color.fromARGB(255, 8, 110, 195),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _updateselected(2);
                          },
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                                Center(
                                    child: Flexible(
                                  child: Text(
                                    "ABSEN \nMASUK",
                                    style: TextStyle(
                                      fontSize: 19,
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                              ],
                            ),
                            height: 100,
                            width: MediaQuery.sizeOf(context).width * 0.4,
                            decoration: BoxDecoration(
                              border: selected == 2
                                  ? Border.all(
                                      width: 5,
                                      color: Color.fromARGB(255, 184, 12, 12))
                                  : null,
                              color: Colors.orange,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
