import 'package:flutter/material.dart';
import 'package:port/data/api_caller.dart'; // Ensure this matches your project structure

class BlogAddScreen extends StatefulWidget {
  const BlogAddScreen({super.key});

  @override
  State<BlogAddScreen> createState() => _BlogAddScreenState();
}

class _BlogAddScreenState extends State<BlogAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isUploading = false;

  Future<void> _handlePost() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      _showGlassToast("Please fill in both title and content", isError: true);
      return;
    }

    setState(() => _isUploading = true);

    bool success = await ApiCaller.addBlog(title, content);

    if (mounted) {
      setState(() => _isUploading = false);
      if (success) {
        _showGlassToast("Research update posted successfully!", isError: false);
        _titleController.clear();
        _contentController.clear();
      } else {
        _showGlassToast("Upload failed. Check logs.", isError: true);
      }
    }
  }

  void _showGlassToast(String text, {required bool isError}) {
    OverlayState? overlayState = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50, // Positioned at the top
        left: MediaQuery.of(context).size.width * 0.1,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.translate(
                offset: Offset(0, -20 * (1 - value)),
                child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              decoration: BoxDecoration(
                color: const Color(0xCC1A1A1A),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isError
                      ? Colors.redAccent.withValues(alpha: 0.5)
                      : Colors.white10,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isError ? Icons.error_outline : Icons.check_circle_outline,
                    color: isError ? Colors.redAccent : const Color(0xFF4FACFE),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3)).then((value) {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Research Update"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.withValues(alpha: 0.2),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withValues(alpha: 0.2),
              ),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Post Title"),
                  const SizedBox(height: 10),
                  _buildTextField(
                    _titleController,
                    "e.g., Pt Cluster Relaxation Progress",
                    1,
                  ),
                  const SizedBox(height: 30),
                  _buildLabel("Content"),
                  const SizedBox(height: 10),
                  _buildTextField(
                    _contentController,
                    "Describe your simulation findings...",
                    10,
                  ),
                  const SizedBox(height: 40),
                  _buildSubmitButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white70,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    int lines,
  ) {
    return TextField(
      controller: controller,
      maxLines: lines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white24),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: _isUploading ? null : _handlePost,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isUploading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                "Post Update",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
      ),
    );
  }
}
