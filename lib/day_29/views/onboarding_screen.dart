import 'dart:ui';

import 'package:flutter/material.dart';

import 'character_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingSlide> _slides = [
    _OnboardingSlide(
      title: 'Interdimensional Madness',
      subtitle: 'SCI-FI COMEDY FILE 001',
      description:
          'Rick and Morty follows genius scientist Rick Sanchez and his grandson Morty across bizarre planets, chaotic timelines, and portal-powered disasters.',
      imagePath: 'assets/images/rick (2).jpg',
      accentColor: Color(0xFF7CF7C9),
      stats: [
        _SlideStat(label: 'Genre', value: 'Sci-Fi Comedy'),
        _SlideStat(label: 'Core Duo', value: 'Rick + Morty'),
      ],
    ),
    _OnboardingSlide(
      title: 'Release Timeline',
      subtitle: 'BROADCAST HISTORY',
      description:
          'The series premiered in 2013 and has continued through multiple seasons, building a long-running multiverse saga with evolving animation and storytelling.',
      imagePath: 'assets/images/morty (2).jpg',
      accentColor: Color(0xFF58D7FF),
      stats: [
        _SlideStat(label: 'First Released', value: '2013'),
        _SlideStat(label: 'Era', value: '2013 - Present'),
      ],
    ),
    _OnboardingSlide(
      title: 'Why Fans Love It',
      subtitle: 'POPULAR HIGHLIGHTS',
      description:
          'People love the sharp humor, wild worldbuilding, unforgettable catchphrases, and emotional twists hiding inside the weirdest adventures in the multiverse.',
      imagePath: 'assets/images/rick (2).jpg',
      accentColor: Color(0xFFB8FF5C),
      stats: [
        _SlideStat(label: 'Signature', value: 'Portal Gun'),
        _SlideStat(label: 'Vibe', value: 'Smart + Absurd'),
      ],
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex == _slides.length - 1) {
      _goToCharacters();
      return;
    }

    _pageController.nextPage(
      duration: Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void _goToCharacters() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => CharacterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF03131D), Color(0xFF072634), Color(0xFF02070D)],
          ),
        ),
        child: Stack(
          children: [
            _BackgroundGlow(
              top: -size.width * 0.18,
              left: -size.width * 0.1,
              size: size.width * 0.55,
              color: Color(0xFF7CF7C9).withValues(alpha: 0.18),
            ),
            _BackgroundGlow(
              bottom: size.height * 0.18,
              right: -size.width * 0.2,
              size: size.width * 0.7,
              color: Color(0xFF58D7FF).withValues(alpha: 0.14),
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _goToCharacters,
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: _slides.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          final slide = _slides[index];
                          return _OnboardingCard(slide: slide);
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (index) => AnimatedContainer(
                          duration: Duration(milliseconds: 250),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          width: _currentIndex == index ? 28 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            color: _currentIndex == index
                                ? _slides[index].accentColor
                                : Colors.white24,
                            boxShadow: _currentIndex == index
                                ? [
                                    BoxShadow(
                                      color: _slides[index].accentColor
                                          .withValues(alpha: 0.45),
                                      blurRadius: 12,
                                      spreadRadius: 1,
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _slides[_currentIndex].accentColor,
                          foregroundColor: Color(0xFF03131D),
                          padding: EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          _currentIndex == _slides.length - 1
                              ? 'Enter The Multiverse'
                              : 'Next Transmission',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
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
      ),
    );
  }
}

class _OnboardingCard extends StatelessWidget {
  const _OnboardingCard({required this.slide});

  final _OnboardingSlide slide;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final imageHeight = constraints.maxHeight * 0.44;

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                Container(
                  height: imageHeight.clamp(220.0, 320.0),
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: slide.accentColor.withValues(alpha: 0.35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: slide.accentColor.withValues(alpha: 0.12),
                        blurRadius: 28,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(34),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          slide.imagePath,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/morty.jpg',
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            );
                          },
                        ),
                        DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.10),
                                Colors.black.withValues(alpha: 0.72),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 18,
                          left: 18,
                          child: _GlassChip(
                            color: slide.accentColor,
                            label: slide.subtitle,
                          ),
                        ),
                        Positioned(
                          right: 20,
                          top: 22,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: slide.accentColor.withValues(
                                  alpha: 0.55,
                                ),
                              ),
                              color: Colors.black.withValues(alpha: 0.22),
                            ),
                            child: Icon(
                              Icons.auto_awesome,
                              color: slide.accentColor,
                              size: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            slide.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            slide.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 15.5,
                              height: 1.55,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: slide.stats
                                .map(
                                  (stat) => Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        right: stat == slide.stats.last
                                            ? 0
                                            : 12,
                                      ),
                                      child: _StatPanel(
                                        stat: stat,
                                        accentColor: slide.accentColor,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GlassChip extends StatelessWidget {
  const _GlassChip({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: color.withValues(alpha: 0.45)),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatPanel extends StatelessWidget {
  const _StatPanel({required this.stat, required this.accentColor});

  final _SlideStat stat;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            accentColor.withValues(alpha: 0.22),
            Colors.white.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stat.label,
            style: TextStyle(
              color: Colors.white60,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            stat.value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({
    required this.size,
    required this.color,
    this.top,
    this.left,
    this.right,
    this.bottom,
  });

  final double size;
  final Color color;
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [color, color.withValues(alpha: 0)],
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.imagePath,
    required this.accentColor,
    required this.stats,
  });

  final String title;
  final String subtitle;
  final String description;
  final String imagePath;
  final Color accentColor;
  final List<_SlideStat> stats;
}

class _SlideStat {
  const _SlideStat({required this.label, required this.value});

  final String label;
  final String value;
}
