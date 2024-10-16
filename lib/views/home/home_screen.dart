import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/icon_park_solid.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:iconify_flutter/icons/fa.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  // 각 버튼의 정보를 리스트로 정의
  final List<Map<String, dynamic>> categoryItems = [
    {
      'icon': Iconify(Fa.bank, color: Colors.lightBlue[400], size: 42),
      'title': 'bank_interest_rate',
      'backgroundColor': Colors.lightBlue[100]!,
      'fontColor': Colors.lightBlue[800]!,
    },
    {
      'icon': Iconify(IconParkSolid.exchange_two, color: Colors.lightGreen[400], size: 42),
      'title': 'exchange_rate',
      'backgroundColor': Colors.lightGreen[100]!,
      'fontColor': Colors.lightGreen[800]!,
    },
    {
      'icon': Iconify(Mdi.gold, color: Colors.orange[400], size: 42),
      'title': 'gold_price',
      'backgroundColor': Colors.orange[100]!,
      'fontColor': Colors.yellow[900]!,
    },
    {
      'icon': Iconify(IconParkSolid.oil_industry, color: Colors.brown[400], size: 42),
      'title': 'oil_price',
      'backgroundColor': Colors.brown[100]!,
      'fontColor': Colors.brown[800]!,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _fadeAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.1 * index,
            0.4 + (0.1 * index),
            curve: Curves.easeInOutBack,
          ),
        ),
      );
    });

    _scaleAnimations = List.generate(4, (index) {
      return Tween<double>(begin: 0.5, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.1 * index,
            0.4 + (0.1 * index),
            curve: Curves.easeInOutBack,
          ),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome back, Lily!'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategorySection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Category', style: TextStyle(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: Text('See all')),
          ],
        ),
        SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 1.4,
          ),
          itemCount: categoryItems.length, // 리스트의 아이템 개수만큼 생성
          itemBuilder: (context, index) {
            return _buildAnimatedCategoryItem(index);
          },
        ),
      ],
    );
  }

  Widget _buildAnimatedCategoryItem(int index) {
    // 인덱스에 맞는 아이템 데이터 가져오기
    final item = categoryItems[index];
    return FadeTransition(
      opacity: _fadeAnimations[index],
      child: ScaleTransition(
        scale: _scaleAnimations[index],
        child: _buildCategoryItem(
          item['icon'],
          item['title'],
          item['backgroundColor'],
          item['fontColor'],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(Widget icon, String title, Color color, Color fontColor) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.all(5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        switch (title) {
          case 'bank_interest_rate':
            context.push('/banking_products');
          case 'exchange_rate':
            context.push('/exchange_rate_list');
          // case 'gold_price':
          //   context.go('/gold_price'); // 예시: 금 가격 페이지로 이동
          // case 'oil_price':
          //   context.go('/oil_price'); // 예시: 석유 가격 페이지로 이동
          default:
            // 기본 동작 또는 에러 처리
            print('Unknown category: $title');
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(height: 8),
          Text(title, style: TextStyle(fontSize: 16, color: fontColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
