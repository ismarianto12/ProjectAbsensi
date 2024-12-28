import 'package:flutter/material.dart';
import 'package:penjualan/controllers/resetPasword.dart';
import 'package:provider/provider.dart';

class Resetpass extends StatefulWidget {
  const Resetpass({super.key});

  @override
  State<Resetpass> createState() => _ResetpassState();
}

class _ResetpassState extends State<Resetpass>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slidekeatas;
  TextEditingController emailcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(microseconds: 100),
      vsync: this,
    );

    _slidekeatas = Tween<Offset>(
      begin: const Offset(0, -1), // Mulai dari luar atas layar
      end: const Offset(0, 0), // Berakhir di posisi normal
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.bounceInOut, // Efek memantul
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.arrow_back)),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "Reset My Password",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            ChangeNotifierProvider(
              create: (_) => Resetpassword(),
              child: Consumer<Resetpassword>(
                  builder: (context, resetPasswordController, _) {
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network(
                          "https://cdni.iconscout.com/illustration/premium/thumb/forgot-password-illustration-download-in-svg-png-gif-file-formats--lock-pin-security-reset-social-media-pack-people-illustrations-6061606.png?f=webp"),
                      TextFormField(
                        decoration: InputDecoration(
                          isDense: true,
                          border: OutlineInputBorder(),
                          label: Text("Email"),
                        ),
                        controller: emailcontroller,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.blue),
                          foregroundColor: MaterialStateProperty.all<Color>(
                              Colors.white), // Correct text color
                        ),
                        onPressed: resetPasswordController.isLoading
                            ? null
                            : () async {
                                try {
                                  await resetPasswordController
                                      .sendDatatoapi(emailcontroller.text);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Reset password berhasil!"),
                                    ),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text("Terjadi kesalahan: $e"),
                                    ),
                                  );
                                }
                              },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: resetPasswordController.isLoading
                              ? CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                )
                              : Center(child: Text("Send")),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
