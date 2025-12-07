import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repo;

  ProductBloc(this.repo) : super(ProductInitial()) {
    on<LoadProducts>(_onLoad);
    on<RefreshProducts>(_onRefresh);
  }

  Future<void> _onLoad(
      LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoadInProgress());
    try {
      final products = await repo.fetchProducts();
      emit(ProductLoadSuccess(products));
    } catch (e) {
      emit(ProductLoadFailure(e.toString()));
    }
  }

  Future<void> _onRefresh(
      RefreshProducts event, Emitter<ProductState> emit) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    add(LoadProducts());
  }
}
