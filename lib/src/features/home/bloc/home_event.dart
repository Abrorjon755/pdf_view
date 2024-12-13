part of 'home_bloc.dart';

sealed class HomeEvent {
  const HomeEvent();
}

final class ChangePage$HomeEvent extends HomeEvent {
  final int index;
  final m.BuildContext context;

  const ChangePage$HomeEvent({
    required this.index,
    required this.context,
  });
}

final class RemoveItem$HomeEvent extends HomeEvent {
  final ProductModel index;
  final m.BuildContext context;

  const RemoveItem$HomeEvent({
    required this.index,
    required this.context,
  });
}

final class AddItem$HomeEvent extends HomeEvent {
  final String name;
  final String price;
  final m.BuildContext context;

  const AddItem$HomeEvent({
    required this.name,
    required this.price,
    required this.context,
  });
}

final class CreatePdf$HomeEvent extends HomeEvent {
  const CreatePdf$HomeEvent();
}

final class GetStorageProducts$HomeEvent extends HomeEvent {
  final m.BuildContext context;

  const GetStorageProducts$HomeEvent({required this.context});
}
