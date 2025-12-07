import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/bloc/auth_state.dart';
import 'features/auth/view/login_page.dart';
import 'features/auth/view/profile_page.dart';
import 'features/cart/view/cart_page.dart';
import 'features/products/view/product_list_page.dart';
import 'widgets/app_bottom_nav.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shoe Store BLoC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFFF5F5F7),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          margin: EdgeInsets.zero,
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      home: const RootPage(),
      routes: {
        '/login': (_) => const LoginPage(),
        '/cart': (_) => const CartPage(),
        '/profile': (_) => const ProfilePage(),
      },
    );
  }
}


class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProductListPage(),
      const CartPage(),
      const ProfilePage(),
    ];

    void handleTap(int i) {
      if (i == 1) {
        // Cart tab
        final authState = context.read<AuthBloc>().state;
        if (authState is! AuthAuthenticated ||
            (authState is AuthAuthenticated && authState.user.isGuest)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login required to view cart')),
          );
          Navigator.pushNamed(context, '/login');
          return;
        }
      }
      setState(() => _index = i);
    }

    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: AppBottomNav(
        currentIndex: _index,
        onTap: handleTap,
      ),
    );
  }
}
