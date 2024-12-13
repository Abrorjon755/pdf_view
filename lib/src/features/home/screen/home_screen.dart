import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils/context_extension.dart';
import '../bloc/home_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => BottomNavigationBar(
          backgroundColor: context.colors.primary,
          fixedColor: context.colors.onPrimary,
          currentIndex: state.currentIndex,
          onTap: (value) => context.read<HomeBloc>().add(
                ChangePage$HomeEvent(
                  index: value,
                  context: context,
                ),
              ),
          iconSize: 30,
          unselectedLabelStyle: context.textTheme.titleMedium,
          selectedLabelStyle: context.textTheme.titleMedium,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'Add Item',
            ),
          ],
        ),
      ),
    );
  }
}
