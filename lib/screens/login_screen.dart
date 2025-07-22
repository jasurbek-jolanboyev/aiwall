import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dashboard_page.dart';

// CountryCode model for code, name, and flag
class CountryCode {
  final String code;
  final String name;
  final String flag;
  CountryCode(this.code, this.name, this.flag);
}

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
  String? errorText;
  bool isLoading = false;

  // Country codes with flag and name
  final List<CountryCode> countryCodes = [
    CountryCode('+998', 'Uzbekistan', '🇺🇿'),
    CountryCode('+7', 'Russia/Kazakhstan', '🇷🇺'),
    CountryCode('+1', 'USA/Canada', '🇺🇸'),
    CountryCode('+90', 'Turkey', '🇹🇷'),
    CountryCode('+44', 'UK', '🇬🇧'),
    CountryCode('+49', 'Germany', '🇩🇪'),
    CountryCode('+81', 'Japan', '🇯🇵'),
    CountryCode('+86', 'China', '🇨🇳'),
    CountryCode('+91', 'India', '🇮🇳'),
    CountryCode('+61', 'Australia', '🇦🇺'),
    CountryCode('+33', 'France', '🇫🇷'),
    CountryCode('+39', 'Italy', '🇮🇹'),
    CountryCode('+82', 'South Korea', '🇰🇷'),
    CountryCode('+34', 'Spain', '🇪🇸'),
    CountryCode('+55', 'Brazil', '🇧🇷'),
    CountryCode('+380', 'Ukraine', '🇺🇦'),
    CountryCode('+996', 'Kyrgyzstan', '🇰🇬'),
    CountryCode('+374', 'Armenia', '🇦🇲'),
    CountryCode('+375', 'Belarus', '🇧🇾'),
    CountryCode('+995', 'Georgia', '🇬🇪'),
    CountryCode('+972', 'Israel', '🇮🇱'),
    CountryCode('+93', 'Afghanistan', '🇦🇫'),
    CountryCode('+964', 'Iraq', '🇮🇶'),
    CountryCode('+966', 'Saudi Arabia', '🇸🇦'),
    CountryCode('+971', 'UAE', '🇦🇪'),
    CountryCode('+373', 'Moldova', '🇲🇩'),
    CountryCode('+992', 'Tajikistan', '🇹🇯'),
    CountryCode('+993', 'Turkmenistan', '🇹🇲'),
    CountryCode('+994', 'Azerbaijan', '🇦🇿'),
    CountryCode('+84', 'Vietnam', '🇻🇳'),
    CountryCode('+62', 'Indonesia', '🇮🇩'),
    CountryCode('+234', 'Nigeria', '🇳🇬'),
    CountryCode('+256', 'Uganda', '🇺🇬'),
    CountryCode('+27', 'South Africa', '🇿🇦'),
  ];
  late CountryCode selectedCountry =
      countryCodes.firstWhere((c) => c.code == '+998');

  // Fields (directions)
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

  List<String> selectedFields = [];

  late AnimationController _controller;
  late Animation<double> _animation;

  void _showFieldsModal() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Yo‘nalishlar (max 12 ta):",
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: fields.map((field) {
                  final selected = selectedFields.contains(field);
                  return FilterChip(
                    label: Text(field,
                        style: TextStyle(
                            color: selected ? Colors.black : Colors.white)),
                    selected: selected,
                    backgroundColor: Colors.black54,
                    selectedColor: Colors.cyanAccent,
                    checkmarkColor: Colors.black,
                    onSelected: (val) {
                      setState(() {
                        if (selected) {
                          selectedFields.remove(field);
                        } else {
                          if (selectedFields.length < 12) {
                            selectedFields.add(field);
                          }
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  "Tanlashni yakunlash",
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          ),
        );
      },
    );
    setState(() {}); // Modal yopilganda UI yangilansin
  }

  void _showCountryPicker() async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black87,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children: countryCodes.map((country) {
            return ListTile(
              leading: Text(country.flag, style: const TextStyle(fontSize: 24)),
              title: Text(
                "${country.name} (${country.code})",
                style: const TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  selectedCountry = country;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _submit() async {
    setState(() {
      errorText = null;
      isLoading = true;
    });

    final email = emailController.text.trim();
    final password = passwordController.text;
    final phone = phoneController.text.trim();

    if (!isLogin) {
      if (phone.isEmpty || phone.length < 7) {
        setState(() {
          errorText = "To‘g‘ri telefon raqamini kiriting!";
          isLoading = false;
        });
        return;
      }
      if (selectedFields.isEmpty) {
        setState(() {
          errorText = "Iltimos, kamida bitta yo‘nalishni tanlang!";
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
                        Row(
                          children: [
                            GestureDetector(
                              onTap: _showCountryPicker,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 8),
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        color: Colors.cyanAccent, width: 2),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      selectedCountry.flag,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      selectedCountry.code,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      selectedCountry.name,
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 14),
                                    ),
                                    const Icon(Icons.arrow_drop_down,
                                        color: Colors.cyanAccent),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  labelText: 'Telefon raqami',
                                  labelStyle: TextStyle(color: Colors.white),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.cyanAccent),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _showFieldsModal,
                            icon: const Icon(Icons.list_alt,
                                color: Colors.cyanAccent),
                            label: Text(
                              selectedFields.isEmpty
                                  ? "Yo‘nalishlar (max 12 ta)"
                                  : "Tanlangan: ${selectedFields.length} ta",
                              style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if (selectedFields.isNotEmpty)
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: selectedFields
                                .map((f) => Chip(
                                      label: Text(f),
                                      backgroundColor: Colors.cyanAccent,
                                      labelStyle:
                                          const TextStyle(color: Colors.black),
                                    ))
                                .toList(),
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
