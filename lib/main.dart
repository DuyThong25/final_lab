import 'package:flutter/material.dart';
import 'package:flutter_cart/cart.dart';
import 'package:lab10/app/page/auth/login.dart';

Future<void> main() async {
  // Khởi tạo cart
  WidgetsFlutterBinding.ensureInitialized();
  var cart = FlutterCart();
  await cart.initializeCart(isPersistenceSupportEnabled: true);
  
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
      // initialRoute: "/",
      // onGenerateRoute: AppRoute.onGenerateRoute,  -> su dung auto route (pushName)
    );
  }
}
