import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/add_item/screen/add_item_screen.dart';
import '../../features/home/bloc/home_bloc.dart';
import '../../features/home/screen/home_screen.dart';
import '../../features/main/screen/main_screen.dart';
import '../../features/print/screen/print_screen.dart';

class AppRouter {
  const AppRouter._();

  static const String home = "/home";
  static const String main = "/main";
  static const String addItem = "/addItem";
  static const String print = "/print";
}

final navigationKey = GlobalKey<NavigatorState>();

final router = GoRouter(
  navigatorKey: navigationKey,
  initialLocation: AppRouter.main,
  routes: [
    ShellRoute(
      builder: (context, state, child) => BlocProvider(
        create: (BuildContext context) => HomeBloc()
          ..add(
            GetStorageProducts$HomeEvent(context: context),
          ),
        child: HomeScreen(child: child),
      ),
      routes: [
        GoRoute(
          path: AppRouter.main,
          name: AppRouter.main,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const MainScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: AppRouter.addItem,
          name: AppRouter.addItem,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const AddItemScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
        GoRoute(
          path: AppRouter.print,
          name: AppRouter.print,
          pageBuilder: (context, state) => CustomTransitionPage(
            key: state.pageKey,
            child: const PrintScreen(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) =>
                    FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        ),
      ],
    ),
  ],
);
