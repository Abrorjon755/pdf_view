part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Status status;
  final int currentIndex;
  final List<ProductModel> products;

  const HomeState({
    this.status = Status.initial,
    this.currentIndex = 0,
    this.products = const [],
  });

  @override
  List<Object> get props => [
        status,
        currentIndex,
        products,
      ];

  HomeState copyWith({
    Status? status,
    int? currentIndex,
    List<ProductModel>? products,
  }) {
    return HomeState(
      status: status ?? this.status,
      currentIndex: currentIndex ?? this.currentIndex,
      products: products ?? this.products,
    );
  }
}
