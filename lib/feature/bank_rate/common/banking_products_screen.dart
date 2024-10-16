import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BankingProductsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('금융 상품 선택'),
      ),
      body: Column(children: [
        SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(context, '예금 상품', '/finance_deposit'),
            SizedBox(width: 10),
            _buildButton(context, '적금 상품', '/finance_saving'),
          ],
        ),
      ]),
    );
  }

  Widget _buildButton(BuildContext context, String title, String navigation) {
    return Card(
      elevation: 4, // 그림자 효과
      child: InkWell(
        onTap: () {
          context.push(navigation);
        },
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
