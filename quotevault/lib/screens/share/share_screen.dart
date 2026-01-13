import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareQuoteScreen extends StatefulWidget {
  final String quote;
  final String author;

  const ShareQuoteScreen(this.quote, this.author, {super.key});

  @override
  State<ShareQuoteScreen> createState() => _ShareQuoteScreenState();
}

class _ShareQuoteScreenState extends State<ShareQuoteScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color(0xFF6B5CF6),
                  Color(0xFF4BC6B9),
                  Color(0xFF8E2DE2),
                ],
                stops: [
                  0.0,
                  0.5 + (_controller.value * .2),
                  1.0
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),

                  const Spacer(),

                  _glassCard(),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Share.share(
                                  '"${widget.quote}" — ${widget.author}');
                            },
                            icon: const Icon(Icons.share),
                            label: const Text("Share"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                              const Color(0xFF6B5CF6),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _glassCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.2),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: Colors.white.withOpacity(.3)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.quote,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.playfairDisplay(
                    color: Theme.of(context).cardColor,
                    fontSize: 24,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "— ${widget.author}",
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 16,
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
