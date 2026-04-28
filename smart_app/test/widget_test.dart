import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Advanced Switch UI',
      theme: ThemeData(
        useMaterial3: true,
      ),
      // Апп эхлэхдээ манай шилжүүлэгч хуудсыг нээнэ
      home: const CustomDarkModeSwitch(),
    );
  }
}

class CustomDarkModeSwitch extends StatefulWidget {
  const CustomDarkModeSwitch({super.key});

  @override
  State<CustomDarkModeSwitch> createState() => _CustomDarkModeSwitchState();
}

class _CustomDarkModeSwitchState extends State<CustomDarkModeSwitch> {
  // Апп-ын төлөв (Dark эсвэл Light)
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. Дэлгэцийн өнгийг төлөвөөс хамаарч өөрчлөх
      backgroundColor: isDarkMode ? const Color(0xFF1D1D1D) : Colors.white,
      
      appBar: AppBar(
        title: const Text("Custom Styles Switch"),
        centerTitle: true,
        backgroundColor: isDarkMode ? Colors.black : Colors.blue.shade300,
        foregroundColor: Colors.white,
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Төлөвийн бичиг
            Text(
              isDarkMode ? "Dark Mode ON" : "Light Mode ON",
              style: TextStyle(
                fontSize: 26,
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            
            // 2. ЗАХИАЛГАТ АНИМАЦИТАЙ ШИЛЖҮҮЛЭГЧ (Custom Switch)
            GestureDetector(
              onTap: () {
                setState(() {
                  isDarkMode = !isDarkMode;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 120,
                height: 60,
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  // Төлөвөөс хамаарч арын өнгө өөрчлөгдөнө
                  color: isDarkMode ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                  border: Border.all(
                    color: isDarkMode ? Colors.redAccent : Colors.transparent,
                    width: 3,
                  ),
                ),
                child: AnimatedAlign(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                  alignment: isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    // Сар болон Нарны дүрс солигдох
                    child: Icon(
                      isDarkMode ? Icons.nightlight_round : Icons.wb_sunny,
                      color: isDarkMode ? Colors.blueAccent : Colors.orange,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 50),
            
            // 3. APPLE ЗАГВАРЫН ШИЛЖҮҮЛЭГЧ (CupertinoSwitch)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Cupertino Style: ",
                    style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
                  ),
                  const SizedBox(width: 10),
                  CupertinoSwitch(
                    value: isDarkMode,
                    activeColor: CupertinoColors.activeGreen,
                    onChanged: (bool value) {
                      setState(() {
                        isDarkMode = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}