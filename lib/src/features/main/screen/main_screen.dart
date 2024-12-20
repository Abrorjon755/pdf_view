import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../common/router/app_router.dart';
import '../../../common/utils/context_extension.dart';
import '../../home/bloc/home_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        title: Text(
          'Main Screen',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size(double.infinity, 90),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              tileColor: context.colors.primaryContainer,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              onTap: () => context.read<HomeBloc>().add(
                    ChangePage$HomeEvent(
                      index: 1,
                      context: context,
                    ),
                  ),
              title: const Text("Add Item"),
              leading: const FaIcon(FontAwesomeIcons.plus),
            ),
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: state.products.length + 1,
          itemBuilder: (BuildContext context, int index) =>
              const Divider(height: 2),
          separatorBuilder: (BuildContext context, int index) => ListTile(
            onTap: () {},
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(state.products[index].name),
                Text(state.products[index].price.toString()),
              ],
            ),
            trailing: IconButton(
              onPressed: () => context.read<HomeBloc>().add(
                    RemoveItem$HomeEvent(
                      index: state.products[index],
                      context: context,
                    ),
                  ),
              icon: const FaIcon(
                FontAwesomeIcons.xmark,
                size: 20,
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push(AppRouter.print),
        child: FaIcon(
          FontAwesomeIcons.print,
          color: context.colors.onPrimaryContainer,
        ),
      ),
    );
  }
}
