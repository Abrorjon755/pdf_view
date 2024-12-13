import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../common/utils/context_extension.dart';
import '../../home/bloc/home_bloc.dart';

part '../mixin/add_item_screen_mixin.dart';

class AddItemScreen extends StatefulWidget {
  const AddItemScreen({super.key});

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> with AddItemScreenMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.colors.primary,
        title: Text(
          'Add Item',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colors.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUnfocus,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              TextFormField(
                controller: _nameController,
                focusNode: _nameNode,
                validator: validateName,
                decoration: const InputDecoration(
                  hintText: "Product name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _priceController,
                focusNode: _priceNode,
                validator: validatePrice,
                decoration: const InputDecoration(
                  hintText: "Product price",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      style: const ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          context.read<HomeBloc>().add(
                                AddItem$HomeEvent(
                                  name: _nameController.text.trim(),
                                  price: _priceController.text.contains("\$")
                                      ? _priceController.text.trim()
                                      : "${_priceController.text.trim()}\$",
                                  context: context,
                                ),
                              );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Text(
                          "Add",
                          style: context.textTheme.titleLarge?.copyWith(
                            color: context.colors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
