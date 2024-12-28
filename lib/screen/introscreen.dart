import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:penjualan/bloc/login_bloc.dart';
import 'package:penjualan/screen/dashboard.dart';
import 'package:penjualan/screen/kehadiran.dart';
import 'package:penjualan/screen/resetPass.dart';
import 'package:penjualan/utils/Pushtoslide.dart';

class Introscreen extends StatefulWidget {
  const Introscreen({super.key});

  @override
  State<Introscreen> createState() => _IntroscreenState();
}

class _IntroscreenState extends State<Introscreen>
    with SingleTickerProviderStateMixin {
  final _formkey =
      GlobalKey<FormState>(); // Update the GlobalKey type to FormState

  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late Animation<Offset> _atas;

  @override
  void initState() {
    super.initState();

    // Inisialisasi AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Durasi transisi
      vsync: this,
    );

    // Inisialisasi Tween untuk menentukan arah transisi
    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0), // Mulai dari luar layar di kanan
      end: Offset(0.0, 0.0), // Berhenti di posisi normal
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Gunakan kurva animasi
    ));

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
  void dispose() {
    _controller
        .dispose(); // Pastikan controller dihapus untuk menghindari kebocoran memori
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          ScaffoldMessenger.of(context).clearSnackBars();
          if (state is LoginSucces) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text('Login successful'), // Correct message
              ),
            );
            navigatePush(context, Dashboard(), direction: 'left');
          } else if (state is LoginFail) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Username or password is incorrect'),
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 150, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _animation,
                  child: Image.network(
                    "https://bimamedia-gurusiana.ap-south-1.linodeobjects.com/99d09686dfbaabdc5ea35c42baafce85/2022/08/03/l-bg-finger20220803032340.png",
                    width: 200,
                  ),
                ),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontFamily: "Tahoma",
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Login to yout account.",
                  style: TextStyle(
                    fontFamily: "Tahoma",
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SlideTransition(
                        position: _atas,
                        child: TextFormField(
                          decoration: InputDecoration(
                            isDense: true,
                            border: OutlineInputBorder(),
                            label: Text("Username"),
                          ),
                          controller: usernamecontroller,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          label: Text("Password"),
                        ),
                        controller: passwordcontroller,
                      ),
                      SizedBox(height: 20),
                      SlideTransition(
                        position: _animation,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.blue),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                Colors.white), // Correct text color
                          ),
                          onPressed: () {
                            if (_formkey.currentState?.validate() ?? false) {
                              context.read<LoginBloc>().add(LoginEventReset());
                              context.read<LoginBloc>().add(
                                    LoginEventSubmit(
                                      username: usernamecontroller.text,
                                      password: passwordcontroller.text,
                                    ),
                                  );
                            }
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: GestureDetector(
                    onTap: () =>
                        {navigatePush(context, Resetpass(), direction: 'lef')},
                    child: Text(
                      "Forget Password",
                      style: TextStyle(
                        fontFamily: "Tahoma",
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
