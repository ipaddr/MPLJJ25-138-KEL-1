import 'package:flutter/material.dart';
import '../component/form/form_register.dart';
import '../theme/app_theme.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double logoRadius = screenWidth > 600 ? 60 : 80;
    double jarak = screenWidth > 600 ? 50 : 80;
    double paddingWeb = screenWidth > 600 ? 384 : 32;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.primaryColor,
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: jarak),

              CircleAvatar(
                radius: logoRadius,
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'assets/image/logo.png',
                    width: logoRadius * 1.8, // biar proporsional dengan lingkaran
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              SizedBox(height: jarak),

              // Container login dengan tinggi fleksibel
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: paddingWeb),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.primaryColorLight,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: AppTheme.lightTheme.primaryColorLight,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                  ],
                                ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  const Text(
                                    "REGISTER",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.blueOld,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                    child: FormRegister(
                                      backgroundColor: Colors.white,
                                      textColor: Colors.orange,
                                      fieldColor: Colors.white,
                                      bottomTextColor: AppTheme.textColorBlack,
                                      bottomTextColor2: AppTheme.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
