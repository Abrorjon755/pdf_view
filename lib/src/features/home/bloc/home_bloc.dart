import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' as m;
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

import '../../../common/constants/constants.dart';
import '../../../common/model/product_model.dart';
import '../../../common/router/app_router.dart';
import '../../../common/utils/context_extension.dart';
import '../../../common/utils/status_enum.dart';

part 'home_state.dart';

part 'home_event.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<HomeEvent>(
      (event, emit) => switch (event) {
        ChangePage$HomeEvent _ => _changePage(event, emit),
        RemoveItem$HomeEvent _ => _removeItem(event, emit),
        AddItem$HomeEvent _ => _addItem(event, emit),
        CreatePdf$HomeEvent _ => _createPdf(event, emit),
        GetStorageProducts$HomeEvent _ => _getStorageProducts(event, emit),
      },
    );
  }

  void _getStorageProducts(
      GetStorageProducts$HomeEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(status: Status.loading));
    final List<String> products =
        event.context.dependency.shp.getStringList(Constants.products) ?? [];
    emit(
      state.copyWith(
        status: Status.success,
        products:
            products.map((e) => ProductModel.fromJson(jsonDecode(e))).toList(),
      ),
    );
  }

  void _changePage(ChangePage$HomeEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(status: Status.loading));

    switch (event.index) {
      case 0:
        event.context.go(AppRouter.main);
      default:
        event.context.go(AppRouter.addItem);
    }

    emit(state.copyWith(status: Status.success, currentIndex: event.index));
  }

  Future<void> _removeItem(
      RemoveItem$HomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    final List<ProductModel> products =
        state.products.where((e) => e.id != event.index.id).toList();

    await event.context.dependency.shp.setStringList(Constants.products,
        products.map((e) => jsonEncode(e.toJson())).toList());
    emit(state.copyWith(status: Status.success, products: products));
  }

  void _addItem(AddItem$HomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    int id = event.context.dependency.shp.getInt(Constants.idCount) ?? 0;
    id++;
    final product = ProductModel.fromJson(
      {
        "id": id,
        "name": event.name,
        "price": event.price,
      },
    );
    final List<String> storage =
        event.context.dependency.shp.getStringList(Constants.products) ?? [];
    storage.add(jsonEncode(product.toJson()));
    await event.context.dependency.shp
        .setStringList(Constants.products, storage);
    await event.context.dependency.shp.setInt(Constants.idCount, id);
    final List<ProductModel> products = [...state.products, product];
    if (event.context.mounted) {
      m.ScaffoldMessenger.of(event.context).showSnackBar(
        const m.SnackBar(
          behavior: m.SnackBarBehavior.floating,
          margin: m.EdgeInsets.only(bottom: 80, left: 20, right: 20),
          content: m.Text("Added Successfully"),
        ),
      );
      _changePage(ChangePage$HomeEvent(index: 0, context: event.context), emit);
    }
    emit(state.copyWith(status: Status.success, products: products));
  }

  Future<void> _createPdf(
      CreatePdf$HomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: Status.loading));
    if (await Permission.storage.isDenied) {
      await Permission.storage.request();
    }
    final image = await rootBundle.load('assets/images/example_qr.png');
    final imageBytes = image.buffer.asUint8List();

    final ttf =
        pw.Font.ttf(await rootBundle.load('assets/fonts/Roboto-Regular.ttf'));
    final myStyle =
        pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold);

    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (context) => pw.ListView(
          padding: const pw.EdgeInsets.symmetric(horizontal: 30),
          children: [
            pw.Text(
              "Korzinka Go",
              style: myStyle,
              textAlign: pw.TextAlign.center,
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              "Products:",
              style: myStyle,
              textAlign: pw.TextAlign.start,
            ),
            for (var i in state.products)
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    i.name,
                    style: myStyle,
                  ),
                  pw.Text(
                    i.price.toString(),
                    style: myStyle,
                  ),
                ],
              ),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  "Total:",
                  style: myStyle,
                ),
                pw.Text(
                  "${state.products.map((e) => e.price.replaceAll("\$", "")).reduce((value, element) => (int.parse(value) + int.parse(element)).toString())}\$",
                  style: myStyle,
                ),
              ],
            ),
            pw.SizedBox(height: 30),
            pw.SizedBox(
              width: 200,
              child: pw.Image(
                pw.MemoryImage(imageBytes),
              ),
            ),
          ],
        ),
      ),
    );
    saveToStorage(pdf, 1);
    emit(state.copyWith(status: Status.success));
  }

  Future<void> saveToStorage(pw.Document pdf, int i) async {
    if (!await File(
            "/storage/emulated/0/Download/${state.products.first.name}${state.products.first.id}$i.pdf")
        .exists()) {
      final file = File(
          "/storage/emulated/0/Download/${state.products.first.name}${state.products.first.id}$i.pdf");
      await file.writeAsBytes(await pdf.save());
    } else {
      saveToStorage(pdf, i++);
    }
  }
}
