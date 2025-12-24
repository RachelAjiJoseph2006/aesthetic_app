import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';

import 'package:photo_manager/photo_manager.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'secondpage_widget.dart';

class ResultPage extends StatefulWidget {
  final double score;
  final String feedback;
  final String originalImagePath;
  final String editedImageBase64;

  const ResultPage({
    super.key,
    required this.score,
    required this.feedback,
    required this.originalImagePath,
    required this.editedImageBase64,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  double rectanglePosition = -1.0;
  double progress = 0.0;
  bool showEdited = false;
  late final MemoryImage editedImage;

  @override
  void initState() {
    super.initState();

    editedImage = MemoryImage(base64Decode(widget.editedImageBase64));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() => rectanglePosition = 0.0);
    });

    Timer.periodic(const Duration(milliseconds: 20), (timer) {
      if (progress >= widget.score / 10) {
        timer.cancel();
      } else {
        setState(() => progress += 0.01);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: Image.asset(
              'assets/images/slay6.png',
              fit: BoxFit.cover,
            ),
          ),

          Positioned(
            top: 40,
            left: 20,
            right: 20,
            height: h * 0.32,
            child: GestureDetector(
              onTap: () => setState(() => showEdited = !showEdited),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: showEdited
                      ? editedImage
                      : FileImage(File(widget.originalImagePath)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            bottom: rectanglePosition * h,
            left: 0,
            right: 0,
            height: h * 0.6,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircularPercentIndicator(
                        radius: w * 0.2,
                        lineWidth: 20,
                        percent: progress,
                        center: Text(
                          "${widget.score.toStringAsFixed(2)} /10",
                          style: TextStyle(
                            fontSize: w * 0.04,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        progressColor: Colors.pinkAccent,
                        backgroundColor: Colors.grey.shade300,
                        circularStrokeCap: CircularStrokeCap.round,
                      ),

                      const SizedBox(width: 16),

                      Column(
                        children: [
                          const SizedBox(height: 12),
                          _actionButton("SAVE", () async {
                          try {
                            await saveEditedImage(widget.editedImageBase64);
                            _showSnack("Saved to gallery ✅");
                          } catch (e) {
                            _showSnack("Save failed ❌");
                          }
                        }),
                          const SizedBox(height: 12),
                          _actionButton("UPLOAD AGAIN", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SecondPageWidget(),
                              ),
                            );
                          }),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.feedback,
                        style: GoogleFonts.oswald(
                          fontSize: w * 0.045,
                          color: Colors.pinkAccent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================
  // SAVE IMAGE (ANDROID 11+ SAFE)
  // =========================
  Future<void> saveEditedImage(String base64Image) async {
    // 1️⃣ Request permission
    final permission = await PhotoManager.requestPermissionExtend();
    if (!permission.isAuth) {
      throw Exception("Gallery permission denied");
    }

    // 2️⃣ Decode Base64 → bytes
    Uint8List bytes = base64Decode(base64Image);

    // 3️⃣ Save to gallery
    await PhotoManager.editor.saveImage(
    bytes,
    filename: "edited_${DateTime.now().millisecondsSinceEpoch}.jpg",
  );
  }

  // =========================
  // SNACKBAR
  // =========================
  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  Widget _actionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: 195,
      height: 40,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pinkAccent.withOpacity(0.85),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
