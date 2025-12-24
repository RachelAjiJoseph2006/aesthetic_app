import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'result_page.dart';

class SecondPageWidget extends StatefulWidget {
  const SecondPageWidget({super.key});

  @override
  State<SecondPageWidget> createState() => _SecondPageWidgetState();
}

class _SecondPageWidgetState extends State<SecondPageWidget> {
  final ImagePicker _picker = ImagePicker();
  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image == null) return;

    setState(() => _loading = true);

    try {
      // 🔗 Backend URL
      final uri = Uri.parse('http://192.168.241.146:8000/upload');

      final request = http.MultipartRequest('POST', uri);
      request.files.add(
        await http.MultipartFile.fromPath('file', image.path),
      );

      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode != 200) {
        throw Exception('Server error ${streamedResponse.statusCode}');
      }

      final decoded = jsonDecode(responseBody);

      final double score = (decoded['score'] as num).toDouble();
      final String feedback = decoded['feedback'] as String;
      final String editedImageBase64 = decoded['edited_image_base64'] as String;


      if (!mounted) return;

      // ✅ Pass LOCAL image path
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultPage(
            score: score,
            feedback: feedback,
            originalImagePath: image.path,
            editedImageBase64: editedImageBase64,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/slay2.png',
              fit: BoxFit.cover,
            ),
          ),

          // Back button
          Positioned(
            top: 50,
            left: 20,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'BACK',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          // Description text
          Align(
            alignment: const Alignment(0, 0.20),
            child: Text(
              'Let AI judge the vibe.\nUpload a photo to get an aesthetic score',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          ),

          // Take photo
          Align(
            alignment: const Alignment(0, -0.15),
            child: _actionButton(
              text: 'TAKE PHOTO',
              onTap: _loading ? null : () => _pickImage(ImageSource.camera),
            ),
          ),

          // Choose photo
          Align(
            alignment: const Alignment(0, -0.03),
            child: _actionButton(
              text: 'CHOOSE PHOTO',
              onTap: _loading ? null : () => _pickImage(ImageSource.gallery),
            ),
          ),

          // Loading spinner
          if (_loading)
            const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String text,
    VoidCallback? onTap,
  }) {
    return SizedBox(
      width: 300,
      height: 42,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white.withOpacity(0.35),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          text,
          style: GoogleFonts.interTight(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
