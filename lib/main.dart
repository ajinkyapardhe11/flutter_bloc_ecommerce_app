import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'core/repositories/auth_repository.dart';
import 'core/repositories/cart_repository.dart';
import 'core/repositories/product_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_event.dart';
import 'features/cart/bloc/cart_bloc.dart';
import 'features/cart/bloc/cart_event.dart';
import 'features/products/bloc/product_bloc.dart';
import 'features/products/bloc/product_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('authBox');
  await Hive.openBox('cartBox');

  final authRepo = AuthRepository();
  final productRepo = ProductRepository();
  final cartRepo = CartRepository();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: productRepo),
        RepositoryProvider.value(value: cartRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc(authRepo)..add(AppStarted())),
          BlocProvider(
              create: (_) => ProductBloc(productRepo)..add(LoadProducts())),
          BlocProvider(
              create: (_) => CartBloc(cartRepo)..add(LoadCart())),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
