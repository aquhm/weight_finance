import 'package:weight_finance/models/base_model.dart';

class OnboardingInfo {
  final String title;
  final String description;
  final String image;

  OnboardingInfo(
      {required this.title, required this.description, required this.image});
}

class OnboardingModel implements BaseModel {
  List<OnboardingInfo> data = [];

  @override
  void init() {
    // 데이터 로드 (초기화)
    data = [
      OnboardingInfo(
          title: 'Welcome to the App!',
          description: "Get started with our amazing features.",
          image: "working.png"),
      OnboardingInfo(
          title: "Track your finances!",
          description: "Stay updated with the latest financial news.",
          image: "presentation.png"),
      OnboardingInfo(
          title: "Set notifications!",
          description: "Never miss an important update.",
          image: "presentation1.png"),
    ];
  }

  @override
  void clear() {
    // 데이터 클리어
    data.clear();
  }
}
