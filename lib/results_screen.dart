import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

import 'package:quiz_app_again/questions_summary/questions_summary.dart';
import 'package:quiz_app_again/models/quiz_question.dart';

class ResultsScreen extends StatefulWidget {
  const ResultsScreen({
    Key? key,
    required this.chosenAnswers,
    required this.onRestart,
    required this.questions,
  }) : super(key: key);

  final void Function() onRestart;
  final List<String> chosenAnswers;
  final List<QuizQuestion> questions;

  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    // Set up animation for perfect score celebration
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    if (numCorrectQuestions == widget.questions.length) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Generate summary data for the quiz results
  List<Map<String, Object>> get summaryData {
    final List<Map<String, Object>> summary = [];

    for (var i = 0; i < widget.chosenAnswers.length; i++) {
      summary.add(
        {
          'question_index': i,
          'question': widget.questions[i].text,
          'correct_answer': widget.questions[i].answers[0],
          'user_answer': widget.chosenAnswers[i]
        },
      );
    }

    return summary;
  }

  int get numTotalQuestions => widget.questions.length;

  int get numCorrectQuestions => summaryData
      .where((data) => data['user_answer'] == data['correct_answer'])
      .length;

  @override
  Widget build(BuildContext context) {
    // Build the results screen UI
    return SizedBox(
      width: double.infinity,
      child: Container(
        margin: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display the score
            Text(
              'You answered $numCorrectQuestions out of $numTotalQuestions questions correctly!',
              style: GoogleFonts.lato(
                color: const Color.fromARGB(255, 230, 200, 253),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Show celebration icon for perfect score
            if (numCorrectQuestions == numTotalQuestions)
              AnimatedBuilder(
                animation: _scaleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: const Icon(
                      Icons.celebration,
                      color: Colors.yellow,
                      size: 100,
                    ),
                  );
                },
              ),
            const SizedBox(height: 30),
            // Display summary of questions and answers
            QuestionsSummary(summaryData),
            const SizedBox(height: 30),
            // Restart quiz button
            TextButton.icon(
              onPressed: widget.onRestart,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.refresh),
              label: const Text('Restart Quiz!'),
            )
          ],
        ),
      ),
    );
  }
}