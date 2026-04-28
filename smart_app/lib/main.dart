import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart' hide CarouselController;
void main() => runApp(const MaterialApp(home: AdvancedShowcase(), debugShowCheckedModeBanner: false));

class AdvancedShowcase extends StatefulWidget {
  const AdvancedShowcase({super.key});
  @override
  State<AdvancedShowcase> createState() => _AdvancedShowcaseState();
}

class _AdvancedShowcaseState extends State<AdvancedShowcase> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const LottiePage(),
    const ShimmerPage(),
    const GlassPage(),
    const CarouselPage(),
    const HttpPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.animation), label: 'Lottie'),
          BottomNavigationBarItem(icon: Icon(Icons.hourglass_empty), label: 'Shimmer'),
          BottomNavigationBarItem(icon: Icon(Icons.blur_on), label: 'Glass'),
          BottomNavigationBarItem(icon: Icon(Icons.view_carousel), label: 'Slider'),
          BottomNavigationBarItem(icon: Icon(Icons.cloud_sync), label: 'HTTP'),
        ],
      ),
    );
  }
}

// 1. LOTTIE: Вэбээс анимаци шууд тоглуулах
class LottiePage extends StatelessWidget {
  const LottiePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Lottie Animation", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Lottie.network('https://assets10.lottiefiles.com/packages/lf20_u4j3ucnx.json'),
        ],
      ),
    );
  }
}

// 2. SHIMMER: Дата уншиж байх үеийн "Skeleton" эффект
class ShimmerPage extends StatelessWidget {
  const ShimmerPage({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListTile(
          leading: const CircleAvatar(backgroundColor: Colors.white, radius: 30),
          title: Container(height: 10, color: Colors.white),
          subtitle: Container(height: 10, width: 40, color: Colors.white),
        ),
      ),
    );
  }
}

// 3. GLASSMORPHISM: "Шилэн" дизайн
class GlassPage extends StatelessWidget {
  const GlassPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(image: DecorationImage(image: NetworkImage("https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1000&auto=format&fit=crop"), fit: BoxFit.cover)),
      child: Center(
        child: GlassmorphicContainer(
          width: 300, height: 200, borderRadius: 20, blur: 20, alignment: Alignment.bottomCenter,
          border: 2, linearGradient: LinearGradient(colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)]),
          borderGradient: LinearGradient(colors: [Colors.white.withOpacity(0.5), Colors.purple.withOpacity(0.5)]),
          child: const Center(child: Text("Glass Effect", style: TextStyle(color: Colors.white, fontSize: 24))),
        ),
      ),
    );
  }
}

// 4. CAROUSEL SLIDER: Гүйдэг зургууд
class CarouselPage extends StatelessWidget {
  const CarouselPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CarouselSlider(
        options: CarouselOptions(height: 400.0, autoPlay: true, enlargeCenterPage: true),
        items: [1,2,3].map((i) {
          return Builder(builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(color: Colors.purple.shade100, borderRadius: BorderRadius.circular(20)),
              child: Center(child: Text('Зураг $i', style: const TextStyle(fontSize: 16.0))),
            );
          });
        }).toList(),
      ),
    );
  }
}

// 5. HTTP: Сүлжээнээс дата авах
class HttpPage extends StatefulWidget {
  const HttpPage({super.key});
  @override
  State<HttpPage> createState() => _HttpPageState();
}

class _HttpPageState extends State<HttpPage> {
  String fact = "Татах...";
  fetchFact() async {
    final res = await http.get(Uri.parse('https://catfact.ninja/fact'));
    setState(() => fact = jsonDecode(res.body)['fact']);
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_download, size: 50, color: Colors.blue),
          const SizedBox(height: 20),
          Text(fact, textAlign: TextAlign.center),
          ElevatedButton(onPressed: fetchFact, child: const Text("Мэдээлэл шинэчлэх"))
        ],
      ),
    );
  }
}