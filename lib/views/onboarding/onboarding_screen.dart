import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Widget> _onboardingPages = [];

  @override
  void initState() {
    _onboardingPages = [
      _buildPage("Welcome to the App!", "Get started with our amazing features.", "working.png"),
      _buildPage("Track your finances!", "Stay updated with the latest financial news.", "presentation.png"),
      _buildPage("Set notifications!", "Never miss an important update.", "presentation1.png"),
    ];

    super.initState();
  }

  Widget _buildPage(String title, String description, String imageName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/${imageName}',
          height: 200,
          width: 200,
        ),
        SizedBox(height: 20),
        Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        Text(description, textAlign: TextAlign.center),
      ],
    );
  }

  void _nextPage() {
    if (_currentPage < _onboardingPages.length - 1) {
      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      // 마지막 페이지에서 로고 화면으로 이동
      context.pushReplacement("/home");
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  Container _buildDot(int index) {
    return Container(
      height: 10,
      width: _currentPage == index ? 25 : 10,
      margin: EdgeInsets.symmetric(horizontal: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: _currentPage == index ? Colors.blue : Colors.grey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingPages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _onboardingPages[index];
            },
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_onboardingPages.length, (index) {
                return _buildDot(index);
              }),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: TextButton(
              onPressed: _prevPage,
              child: Text("Prev"),
            ),
          ),
          Positioned(
            bottom: 40,
            right: 20,
            child: TextButton(
              onPressed: _nextPage,
              child: Text(_currentPage == _onboardingPages.length - 1 ? "Finish" : "Next"),
            ),
          ),
          Positioned(
            top: 70,
            right: 20,
            child: TextButton(
              onPressed: () {
                // 스킵 버튼 클릭 시 로고 화면으로 이동
                //context.pushReplacement(() => LogoScreen());
              },
              child: Text("Skip"),
            ),
          ),
        ],
      ),
    );
  }
}

class LogoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Your Logo Here", style: TextStyle(fontSize: 32)),
      ),
    );
  }
}
