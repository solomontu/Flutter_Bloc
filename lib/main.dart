import 'package:flutter/material.dart';
import 'package:test/presentation/service/router_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // final AppRouter _appRouter = AppRouter();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = AppRouter();
    return MaterialApp.router(
      title: 'test',
      debugShowCheckedModeBanner: true,
      routeInformationParser: appRouter.router.routeInformationParser,
      routerDelegate: appRouter.router.routerDelegate,
      routeInformationProvider: appRouter.router.routeInformationProvider,
    );
  }
}
