import 'dart:convert';
import 'package:flutter/material.dart';

void main() {
  runApp(const WinterMysteryApp());
}

class WinterMysteryApp extends StatelessWidget {
  const WinterMysteryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لعبة الغموض الشتوية',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const GameScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // بيانات القضية مستوحاة من السيناريو
  final Map<String, dynamic> gameData = {
    "case_title": "سر الكوخ المفقود",
    "puzzles": [
      {
        "puzzle_id": "P01",
        "target_card": "03",
        "question": "أدخل رمز الخزنة الرقمية (البطاقة 03):",
        "correct_answer": "16",
        "on_success_message": "ممتاز! فتحت الخزنة. اسحب البطاقة رقم (04).",
        "hints": [
          "تلميح 1: احسب عدد الأيام التي سقط فيها الثلج المذكورة في البطاقة (02).",
          "تلميح 2: الثلج سقط في 4 أيام، ودرجة الحرارة هي 4 تحت الصفر.",
          "تلميح 3: اضرب 4 في 4 للحصول على النتيجة."
        ]
      },
      {
        "puzzle_id": "P02",
        "target_card": "05",
        "question": "أدخل رقم البطاقة للمكان الذي ينبعث منه الدفء الأخير:",
        "correct_answer": "05",
        "on_success_message": "صحيح! توجهت للمدفأة واكتشفت المخبأ وحللت القضية! 🎉",
        "hints": [
          "تلميح 1: ابحث عن مكان في الكوخ يصدر منه الدفء.",
          "تلميح 2: اختر بطاقة تعبر عن مصدر الحرارة في الغرفة (المدفأة)."
        ]
      }
    ]
  };

  int currentPuzzleIndex = 0;
  final TextEditingController _answerController = TextEditingController();
  int currentHintIndex = 0;
  String feedbackMessage = "";

  void _checkAnswer() {
    final puzzle = gameData["puzzles"][currentPuzzleIndex];
    String userinput = _answerController.text.trim();

    if (userinput == puzzle["correct_answer"]) {
      setState(() {
        feedbackMessage = puzzle["on_success_message"];
        currentHintIndex = 0;
        _answerController.clear();
        
        // الانتقال للغز التالي إن وجد
        if (currentPuzzleIndex < (gameData["puzzles"].length - 1)) {
          currentPuzzleIndex++;
        }
      });
    } else {
      setState(() {
        feedbackMessage = "❌ إجابة خاطئة، حاول مرة أخرى أو اطلب تلميحاً.";
      });
    }
  }

  void _showNextHint() {
    final puzzle = gameData["puzzles"][currentPuzzleIndex];
    List hints = puzzle["hints"];
    
    if (currentHintIndex < hints.length) {
      setState(() {
        feedbackMessage = "💡 ${hints[currentHintIndex]}";
        currentHintIndex++;
      });
    } else {
      setState(() {
        feedbackMessage = "💡 لقد استنفدت جميع التلميحات لهذا اللغز!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final puzzle = gameData["puzzles"][currentPuzzleIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(gameData["case_title"]),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blueGrey[900],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "اللغز الحالي (بطاقة رقم: ${puzzle['target_card']})\n\n${puzzle['question']}",
                  style: const TextStyle(fontSize: 18, height: 1.4),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _answerController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'أدخل الحل هنا',
                filled: true,
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              onPressed: _checkAnswer,
              icon: const Icon(Icons.check),
              label: const Text('تحقق من الإجابة'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _showNextHint,
              icon: const Icon(Icons.lightbulb_outline),
              label: const Text('طلب تلميح'),
            ),
            const SizedBox(height: 25),
            if (feedbackMessage.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blueGrey),
                ),
                child: Text(
                  feedbackMessage,
                  style: const TextStyle(fontSize: 16, color: Colors.amberAccent),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
