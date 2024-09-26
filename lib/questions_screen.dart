import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';

import 'package:quiz_app_again/answer_button.dart';
import 'package:quiz_app_again/models/quiz_question.dart';

class QuestionsScreen extends StatefulWidget {
  // Constructor
  const QuestionsScreen({
    super.key,
    required this.onSelectAnswer,
    required this.questions,
  });

  final void Function(String answer) onSelectAnswer;
  final List<QuizQuestion> questions;

  @override
  State<QuestionsScreen> createState() {
    return _QuestionsScreenState();
  }
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  var currentQuestionIndex = 0;
  int _timeLeft = 15;
  late Timer _timer;
  late List<String> _shuffledAnswers;

  @override
  void initState() {
    super.initState();
    _shuffleCurrentAnswers();
    _startTimer();
  }

  // Shuffle the answers for the current question
  void _shuffleCurrentAnswers() {
    _shuffledAnswers = widget.questions[currentQuestionIndex].getShuffledAnswers();
  }

  // Start the timer for each question
  void _startTimer() {
    _timeLeft = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer.cancel();
          _nextQuestion(''); // Move to next question if time runs out
        }
      });
    });
  }

  // Move to the next question
  void _nextQuestion(String selectedAnswer) {
    _timer.cancel();
    widget.onSelectAnswer(selectedAnswer);
    setState(() {
      currentQuestionIndex++;
      if (currentQuestionIndex < widget.questions.length) {
        _shuffleCurrentAnswers();
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = widget.questions[currentQuestionIndex];

    // Build the question screen UI
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Timer display
            Text(
              'Time left: $_timeLeft seconds',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Progress indicator
            LinearProgressIndicator(
              value: (currentQuestionIndex) / widget.questions.length,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            // Question text
            Text(
              currentQuestion.text,
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 201, 153, 251),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Answer buttons
            ..._shuffledAnswers.map((answer) {
              return AnswerButton(
                answerText: answer,
                onTap: () {
                  _nextQuestion(answer);
                },
              );
            })
          ],
        ),
      ),
    );
  }
}