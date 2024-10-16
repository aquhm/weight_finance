import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weight_finance/feature/theme/theme_bloc.dart';
import 'package:weight_finance/global/bloc/global_financial/global_financial_bloc.dart';
import 'package:weight_finance/global_api.dart';
//import 'package:weight_finance/global/bloc/global_deposit/global_deposit_bloc.dart';

class GlobalBlocProviders extends StatelessWidget {
  final Widget child;

  const GlobalBlocProviders({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeBloc>(
          create: (context) => GlobalAPI.di.get<ThemeBloc>(),
        ),
        BlocProvider<GlobalFinancialBloc>.value(
          value: GlobalAPI.di.get<GlobalFinancialBloc>(),
        ),
      ],
      child: child,
    );
  }
}
