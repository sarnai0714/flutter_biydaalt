import 'package:flutter/material.dart' hide CarouselController;
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:rive/rive.dart' as rive; // Нэршлийн алдаанаас сэргийлнэ
import 'package:shimmer/shimmer.dart';
import 'package:slider_button/slider_button.dart';
import 'dart:convert';

void main() => runApp(const MaterialApp(
  home: AdvancedShowcase(), 
  debugShowCheckedModeBanner: false
));

class AdvancedShowcase extends StatefulWidget {
  const AdvancedShowcase({super.key});
  @override
  State<AdvancedShowcase> createState() => _AdvancedShowcaseState();
}

class _AdvancedShowcaseState extends State<AdvancedShowcase> {
  int _currentIndex = 0;
  
  // 5 өөр багцыг агуулсан хуудсууд
  final List<Widget> _pages = [
    const AnimatedTextPage(),   // 1. Text Animation
    const CelebrationPage(),    // 2. Confetti & Rive
    const ActionPage(),         // 3. Slider Button & Shimmer
    const CarouselPage(),       // 4. Carousel Slider
    const HttpPage(),           // 5. HTTP API
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Showcase 2026"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Текст'),
          BottomNavigationBarItem(icon: Icon(Icons.celebration), label: 'Амжилт'),
          BottomNavigationBarItem(icon: Icon(Icons.touch_app), label: 'Үйлдэл'),
          BottomNavigationBarItem(icon: Icon(Icons.view_carousel), label: 'Слайдер'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_download), label: 'Дата'),
        ],
      ),
    );
  }
}

// 1. ТЕКСТ АНИМАЦИ (Lottie алдаа засагдсан)
class AnimatedTextPage extends StatelessWidget {
  const AnimatedTextPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Шинэ ажилладаг Lottie линк (403 алдаа гарахгүй)
          Lottie.network(
            'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json', 
            height: 200,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, color: Colors.red, size: 100);
            },
          ),
          const SizedBox(height: 20),
          DefaultTextStyle(
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal),
            child: AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                TypewriterAnimatedText("Сайн байна уу?"),
                TypewriterAnimatedText("Сонин сайхан юу байна?"),
                TypewriterAnimatedText("Сайхан амарч байна уу?"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// 2. АМЖИЛТ (Rive & Confetti)
class CelebrationPage extends StatelessWidget {
  const CelebrationPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 200, width: 200,
            child: rive.RiveAnimation.network(
              'https://cdn.rive.app/animations/vehicles.riv',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 30),
          const Text("Амжилттай!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => Confetti.launch(context, options: const ConfettiOptions(particleCount: 100, spread: 70, y: 0.6)),
            icon: const Icon(Icons.celebration),
            label: const Text("БАЯР ХҮРГЭЕ"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }
}

// 3. ҮЙЛДЭЛ (SliderButton & Shimmer)
class ActionPage extends StatelessWidget {
  const ActionPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.grey[400]!,
              highlightColor: Colors.grey[100]!,
              child: const Text(
                "БАТАЛГААЖУУЛАХ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 50),
            SliderButton(
              action: () async {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Амжилттай баталгаажлаа!")),
                );
                return true;
              },
              label: const Text("Чирж баталгаажуул", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17)),
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              buttonColor: Colors.teal,
              backgroundColor: Colors.teal.shade50,
              baseColor: Colors.teal,
              width: 280,
            ),
          ],
        ),
      ),
    );
  }
}

// 4. СЛАЙДЕР (Carousel Slider)
class CarouselPage extends StatelessWidget {
  const CarouselPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(height: 300.0, autoPlay: true, enlargeCenterPage: true),
        items: [Colors.teal, Colors.tealAccent, Colors.blueGrey].map((color) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(color: color.withOpacity(0.3), borderRadius: BorderRadius.circular(20)),
            child: Center(child: Icon(Icons.dashboard_customize, size: 100, color: color)),
          );
        }).toList(),
      ),
    );
  }
}

// 5. ДАТА (HTTP API & Shimmer)
class HttpPage extends StatefulWidget {
  const HttpPage({super.key});
  @override
  State<HttpPage> createState() => _HttpPageState();
}

class _HttpPageState extends State<HttpPage> {
  String fact = "Уншиж байна...";
  bool loading = true;

  Future<void> fetchFact() async {
    setState(() => loading = true);
    try {
      final res = await http.get(Uri.parse('https://catfact.ninja/fact'));
      setState(() {
        fact = jsonDecode(res.body)['fact'];
        loading = false;
      });
    } catch (e) {
      setState(() {
        fact = "Интернэт холболтоо шалгана уу.";
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchFact();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            loading 
              ? Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(height: 120, width: double.infinity, color: Colors.white),
                )
              : Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(color: Colors.teal.shade50, borderRadius: BorderRadius.circular(15)),
                  child: Text(fact, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
                ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: fetchFact, 
              icon: const Icon(Icons.refresh),
              label: const Text("Шинэ дата татах"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}