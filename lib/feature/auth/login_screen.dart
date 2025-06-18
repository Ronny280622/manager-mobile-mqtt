import 'package:manager_mqtt/feature/auth/login_controller.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = LoginController();
  bool isViewPass = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Iniciar Sesión')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 200),
              Center(
                child: Column(
                  children: [
                    Text('Manager', style:
                      TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800]
                      ),
                    ),
                    Text(
                      'Project',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.blue[800],
                      ),
                    ),
                    const SizedBox(height: 50),
                    // Título INICIAR SESION
                    Text(
                      'INICIAR SESION',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Campo Usuario
                    TextFormField(
                      onChanged: (value) => {controller.username = value },
                      decoration: InputDecoration(
                        labelText: 'Usuario*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Campo Contraseña
                    TextFormField(
                      obscureText: isViewPass,
                      onChanged: (value) => { controller.password = value },
                      decoration: InputDecoration(
                        labelText: 'Contraseña*',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isViewPass = !isViewPass;
                            });
                          },
                          icon: Icon(isViewPass ? Icons.visibility_off_outlined : Icons.visibility_outlined)
                        )
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)
                          )
                        ),
                        onPressed: () => controller.login(context),
                        child: const Text(
                          'Ingresar',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    )
                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}