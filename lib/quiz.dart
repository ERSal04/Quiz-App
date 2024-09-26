import 'package:flutter/material.dart';
import 'package:quiz_app_again/models/quiz_question.dart';
import 'dart:math';

import 'package:quiz_app_again/start_screen.dart';
import 'package:quiz_app_again/questions_screen.dart';
import 'package:quiz_app_again/data/questions.dart';
import 'package:quiz_app_again/results_screen.dart';

// Main Quiz widget
class Quiz extends StatefulWidget {
  const Quiz({super.key});

  @override
  State<Quiz> createState() {
    return _QuizState();
  }
}

class _QuizState extends State<Quiz> {
  List<String> _selectedAnswers = [];
  var _activeScreen = 'start-screen';
  late List<QuizQuestion> _shuffledQuestions;

  @override
  void initState() {
    super.initState();
    _shuffleQuestions();
  }

  // Shuffle the questions
  void _shuffleQuestions() {
    _shuffledQuestions = List.of(questions);
    _shuffledQuestions.shuffle(Random());
  }

  // Switch to the questions screen
  void _switchScreen() {
    setState(() {
      _activeScreen = 'questions-screen';
    });
  }

  // Handle answer selection
  void _chooseAnswer(String answer) {
    _selectedAnswers.add(answer);

    if (_selectedAnswers.length == _shuffledQuestions.length) {
      setState(() {
        _activeScreen = 'results-screen';
      });
    }
  }

  // Restart the quiz
  void restartQuiz() {
    setState(() {
      _selectedAnswers = [];
      _activeScreen = 'questions-screen';
      _shuffleQuestions();
    });
  }

  @override
  Widget build(context) {
    // Determine which screen to show
    Widget screenWidget = StartScreen(_switchScreen);

    if (_activeScreen == 'questions-screen') {
      screenWidget = QuestionsScreen(
        onSelectAnswer: _chooseAnswer,
        questions: _shuffledQuestions,
      );
    }

    if (_activeScreen == 'results-screen') {
      screenWidget = ResultsScreen(
        chosenAnswers: _selectedAnswers,
        onRestart: restartQuiz,
        questions: _shuffledQuestions,
      );
    }

    // Build the main app UI
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: screenWidget,
        ),
      ),
    );
  }
}