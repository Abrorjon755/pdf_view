import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../common/utils/context_extension.dart';
import '../../home/bloc/home_bloc.dart';


class PrintScreen extends StatelessWidget {
  const PrintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoNavigationBarBackButton(
          color: context.colors.onPrimary,
        ),
        backgroundColor: context.colors.primary,
        title: Text(
          'Print Screen',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) => state.products.isEmpty
                ? const SizedBox()
                : IconButton(
                    onPressed: () {
                      context.read<HomeBloc>().add(const CreatePdf$HomeEvent());
                    },
                    icon: FaIcon(
                      FontAwesomeIcons.download,
                      color: context.colors.onPrimary,
                    ),
                  ),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) => state.products.isEmpty
            ? Center(
                child: Text(
                  "No Products to calculate",
                  style: context.textTheme.titleLarge,
                ),
              )
            : state.status.isLoading
                ? const CircularProgressIndicator.adaptive()
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        "Korzinka Go",
                        style: context.textTheme.displaySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Products:",
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 30),
                      for (var i in state.products)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              i.name,
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              i.price.toString(),
                              style: context.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      const SizedBox(height: 15),
                      const Divider(),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total:",
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            state.products
                                .map((e) => e.price)
                                .reduce((value, element) => value + element),
                            style: context.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const SizedBox(
                        width: 200,
                        child: Image(
                          image: AssetImage("assets/images/example_qr.png"),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
