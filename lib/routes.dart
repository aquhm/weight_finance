import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weight_finance/feature/bank_rate/deposit/domain/entities/deposit_entity.dart';
import 'package:weight_finance/feature/bank_rate/common/banking_products_screen.dart';
import 'package:weight_finance/feature/bank_rate/deposit/presentation/pages/deposit_rate_screen.dart';
import 'package:weight_finance/feature/bank_rate/saving/domain/entities/saving_entity.dart';
import 'package:weight_finance/feature/bank_rate/saving/presentation/pages/saving_rate_detail_screen.dart';
import 'package:weight_finance/feature/bank_rate/saving/presentation/pages/saving_rate_screen.dart';
import 'package:weight_finance/feature/exchange/presentation/pages/exchange_rate_screen.dart';
import 'package:weight_finance/feature/bank_rate/deposit/presentation/pages/deposit_rate_detail_screen.dart';
import 'package:weight_finance/feature/metal_price/domain/entities/commodity_entity.dart';
import 'package:weight_finance/feature/metal_price/presentation/pages/commodity_price_detail_screen.dart';
import 'package:weight_finance/feature/metal_price/presentation/pages/commodity_price_screen.dart';
import 'package:weight_finance/views/onboarding/onboarding_screen.dart';
import 'package:weight_finance/views/splash/splash_screen.dart';
import 'package:weight_finance/views/home/home_screen.dart';

class CommodityDetailArgs {
  final String metal;
  final MetalEntity metalEntity;
  final String currency;
  final String unit;

  CommodityDetailArgs({
    required this.metal,
    required this.metalEntity,
    required this.currency,
    required this.unit,
  });
}

class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("DidPush: $route");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("DidPop: $route");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("DidRemove: $route");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print("DidReplace: $newRoute");
  }
}

class AppPages {
  AppPages._();

  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    observers: [RouterObserver()],
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/banking_products',
        builder: (context, state) => BankingProductsScreen(),
      ),
      GoRoute(
        path: '/exchange_rate_list',
        builder: (context, state) => ExchangeRateScreen(),
      ),
      GoRoute(
        path: '/finance_deposit',
        builder: (context, state) => DepositRatesScreen(),
      ),
      GoRoute(
        path: '/finance_saving',
        builder: (context, state) => SavingRatesScreen(),
      ),
      GoRoute(
        path: '/finance_deposit_detail',
        builder: (context, state) {
          final product = state.extra as DepositProductEntity?;
          return DepositRatesDetailScreen(product: product!);
        },
      ),
      GoRoute(
        path: '/finance_saving_detail',
        builder: (context, state) {
          final product = state.extra as SavingProductEntity?;
          return SavingRatesDetailScreen(product: product!);
        },
      ),
      GoRoute(
        path: '/finance_commodity',
        builder: (context, state) => CommodityPricesScreen(),
      ),
      GoRoute(
        path: '/finance_commodity_detail',
        builder: (context, state) {
          final args = state.extra as CommodityDetailArgs;
          return CommodityDetailScreen(
            metal: args.metal,
            metalData: args.metalEntity,
            currency: args.currency,
            unit: args.unit,
          );
        },
      ),
    ],
  );
}
