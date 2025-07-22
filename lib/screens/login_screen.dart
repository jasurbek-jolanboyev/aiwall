import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart'; // neon uslubda ikonlar uchun
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLogin = true;
  bool showPassword = false;
  String? selectedField;
  String? errorText;
  bool isLoading = false;

  final List<String> fields = [
    // IT sohalari
    'Dasturchi',
    'Frontend dasturchi',
    'Backend dasturchi',
    'Fullstack dasturchi',
    'Mobil dasturchi',
    'Game developer',
    'Sun’iy intellekt mutaxassisi',
    'Data Scientist',
    'Data Analyst',
    'Machine Learning Engineer',
    'Kiberxavfsizlik mutaxassisi',
    'DevOps',
    'Tester',
    'QA Engineer',
    'IT o‘qituvchi',
    'IT Support',
    'Network Engineer',
    'System Administrator',
    'Cloud Engineer',
    'Blockchain Developer',
    'AR/VR Developer',
    'IoT Developer',
    'Embedded Systems Engineer',
    'UI/UX dizayner',
    'Grafik dizayner',
    'Motion dizayner',
    '3D dizayner',
    'Web dizayner',
    'Product Manager',
    'Project Manager',
    'Biznes-analitik',
    'Texnik yozuvchi',
    'SEO mutaxassisi',
    'SMM',
    'Kopirayter',
    'Kontent-menejer',
    'Scrum Master',
    'Loyiha menejeri',
    'Raqamli marketing mutaxassisi',
    'CRM mutaxassisi',
    'ERP mutaxassisi',
    'Boshqa IT yo‘nalishi',

    // Media va kreativ sohalar
    'Jurnalist',
    'Media mutaxassisi',
    'Video montajchi',
    'Operator',
    'Fotograf',
    'Mobilograf',
    'Produser',
    'Bloger',
    'PR menejer',
    'Ssenarist',
    'Rejissyor',
    'Ovoz rejissyori',
    'Diktor',
    'Radio boshlovchisi',
    'TV boshlovchisi',
    'Podkast yaratuvchisi',
    'Animatsiya ustasi',
    'Rassom',
    'Illyustrator',
    'Sahna dizayneri',
    'Moda dizayneri',
    'San’at menejeri',
    'Reklama agenti',
    'Brand menejer',
    'Media monitoring mutaxassisi',
    'SMM menejer',
    'Kontent yaratuvchi',
    'Influencer',
    'Boshqa media yo‘nalishi',
  ];

  late AnimationController _controller;
  late Animation<double> _animation;

  void _submit() async {
    setState(() {
      errorText = null;
      isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text;
    final phone = phoneController.text.trim();

    if (!isLogin) {
      // Sign Up: check phone and field
      if (phone.isEmpty || phone.length < 7) {
        setState(() {
          errorText = "To‘g‘ri telefon raqamini kiriting!";
          isLoading = false;
        });
        return;
      }
      if (selectedField == null) {
        setState(() {
          errorText = "Iltimos, yo‘nalishni tanlang!";
          isLoading = false;
        });
        return;
      }
    }

    if (email.isEmpty || !email.contains('@')) {
      setState(() {
        errorText = "To‘g‘ri email kiriting!";
        isLoading = false;
      });
      return;
    }
    if (password.length < 6) {
      setState(() {
        errorText = "Parol kamida 6 ta belgidan iborat bo‘lishi kerak!";
        isLoading = false;
      });
      return;
    }

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon, color: Colors.cyanAccent, size: 28),
      onPressed: () {
        // TODO: link ochish uchun url_launcher qo‘shing
        debugPrint("Open $url");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Neon background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.8),
                    border:
                        Border.all(color: Colors.deepPurpleAccent, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurpleAccent.withOpacity(0.4),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        isLogin ? '🔐 Log In' : '📝 Sign Up',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyanAccent,
                          shadows: [
                            Shadow(
                              blurRadius: 10,
                              color: Colors.cyan,
                              offset: Offset(1, 1),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyanAccent),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: !showPassword,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyanAccent),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.cyanAccent,
                            ),
                            onPressed: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                          ),
                        ),
                      ),
                      if (!isLogin) ...[
                        const SizedBox(height: 16),
                        TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            labelText: 'Telefon raqami',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyanAccent),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: selectedField,
                          dropdownColor: Colors.black87,
                          decoration: const InputDecoration(
                            labelText: 'Yo‘nalishni tanlang',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.cyanAccent),
                            ),
                          ),
                          items: fields
                              .map((field) => DropdownMenuItem(
                                    value: field,
                                    child: Text(
                                      field,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedField = value;
                            });
                          },
                        ),
                      ],
                      if (errorText != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorText!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),
                      const SizedBox(height: 24),
                      isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.cyanAccent)
                          : ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 32, vertical: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text(
                                isLogin ? 'LOGIN' : 'SIGN UP',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                            errorText = null;
                          });
                        },
                        child: Text(
                          isLogin
                              ? "Don't have an account? Sign Up"
                              : "Already have an account? Login",
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Bizni kuzatib boring:',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildSocialIcon(FontAwesomeIcons.youtube,
                              "https://www.youtube.com/@Jasurbek_Jolanboyev"),
                          _buildSocialIcon(FontAwesomeIcons.telegram,
                              "https://t.me/Vscoderr"),
                          _buildSocialIcon(FontAwesomeIcons.instagram,
                              "https://www.instagram.com/jasurbek.official.uz"),
                          _buildSocialIcon(FontAwesomeIcons.linkedin,
                              "https://www.linkedin.com/in/jasurbek-jo-lanboyev-74b758351?utm_source=share&utm_campaign=share_via&utm_content=profile&utm_medium=android_app"),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
