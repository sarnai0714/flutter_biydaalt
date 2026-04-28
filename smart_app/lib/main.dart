import 'package:flutter/material.dart' hide CarouselController;
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:rive/rive.dart' as rive; // Нэршлийн алдаанаас сэргийлнэ
import 'package:shimmer/shimmer.dart';
import 'package:pinput/pinput.dart';
import 'package:socket_io_client/socket_io_client.dart';
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
    const PinputPage(),         // 3. Slider Button & Shimmer
    const CarouselPage(),       // 4. Carousel Slider
    const ChatPage(),           // 5. HTTP API
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
          BottomNavigationBarItem(icon: Icon(Icons.lock), label: 'Код'),
          BottomNavigationBarItem(icon: Icon(Icons.view_carousel), label: 'Слайдер'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Чат'),
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

/* ===================== 3. PINPUT (NEW) ===================== */

class PinputPage extends StatefulWidget {
  const PinputPage({super.key});

  @override
  State<PinputPage> createState() => _PinputPageState();
}

class _PinputPageState extends State<PinputPage> {
  final pinController = TextEditingController();
  final correctPin = "1234";

  void checkPin(String pin) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(pin == correctPin ? "Амжилттай нэвтэрлээ ✅" : "Буруу код ❌"),
        backgroundColor: pin == correctPin ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.blueGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "PIN оруулна уу",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Pinput(
                  length: 4,
                  controller: pinController,
                  obscureText: true,
                  onCompleted: checkPin,
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(fontSize: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                      color: Colors.teal,
                      width: 1.5,
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

// ================= SIMPLE CHAT =================
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController controller = TextEditingController();
  List<String> messages = [];

  late Socket socket;

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  void initSocket() {
    socket = io(
      'http://127.0.0.1:3000',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('Connected ✅');
    });

    socket.on('message', (data) {
      setState(() {
        messages.add(data.toString());
      });
    });

    socket.onDisconnect((_) {
      print('Disconnected ❌');
    });
  }

  void send() {
    if (controller.text.trim().isEmpty) return;

    final msg = controller.text.trim();

    socket.emit('message', msg);

    setState(() {
      messages.add(msg);
    });

    controller.clear();
  }

  @override
  void dispose() {
    socket.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.teal, Colors.blueGrey],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Chat 💬",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            Expanded(
              child: messages.isEmpty
                  ? const Center(
                      child: Text(
                        "No messages yet...",
                        style: TextStyle(color: Colors.white70),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: messages.length,
                      itemBuilder: (_, i) {
                        final isMe = i % 2 == 0;

                        return Align(
                          alignment: isMe
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isMe
                                  ? Colors.purple
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              messages[i],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Type message...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.teal),
                    onPressed: send,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}