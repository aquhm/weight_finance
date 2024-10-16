import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flag/flag.dart';
import 'package:weight_finance/extension/flag_extension.dart';
import 'package:weight_finance/feature/exchange/presentation/bloc/exchange_rate_bloc.dart';
import 'package:weight_finance/global_api.dart'; // 국기 아이콘을 위한 패키지

class ExchangeRateScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GlobalAPI.di.get<ExchangeRateBloc>()..add(FetchExchangeRateEvent()),
      child: ExchangeRateView(),
    );
  }
}

class ExchangeRateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('환율 정보'),
      ),
      body: BlocBuilder<ExchangeRateBloc, ExchangeRateState>(
        builder: (context, state) {
          if (state is ExchangeRateLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ExchangeRateLoaded) {
            return ListView.builder(
              itemCount: state.exchangeRates.length,
              itemBuilder: (context, index) {
                final rate = state.exchangeRates[index];
                return ListTile(
                  leading: Flag.fromCode(
                    FlagsCodeExtension.fromCurrencyCode(rate.currencyCode!),
                    height: 30,
                    width: 40,
                    fit: BoxFit.fill,
                  ),
                  title: Text('${rate.countryName} (${rate.currencyCode})'),
                  trailing: Text(
                    rate.baseRate!,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            );
          } else if (state is ExchangeRateError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(child: Text('환율 정보를 불러와주세요.'));
        },
      ),
    );
  }
}
