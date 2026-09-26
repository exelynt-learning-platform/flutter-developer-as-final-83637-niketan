import 'package:employee_management/config/router/routes.dart';
import 'package:employee_management/modules/authentication/presentation/bloc/auth_bloc.dart';
import 'package:employee_management/utils/injectible.dart';
import 'package:employee_management/utils/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final MyAppRouter appRouter = MyAppRouter();

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: serviceLocator<AuthBloc>()..add(AuthStarted()),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: AppThemeController.themeMode,
        builder: (_, themeMode, __) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData.light(useMaterial3: true),
            darkTheme: ThemeData.dark(useMaterial3: true),
            routerConfig: appRouter.router,
          );
        },
      ),
    );
  }
}
