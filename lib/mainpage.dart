import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:lab10/app/model/user.dart';
import 'package:lab10/app/page/detailwidget.dart';
import 'package:lab10/app/route/billwidget.dart';
import 'package:lab10/app/route/cartwidget.dart';
import 'package:lab10/app/route/categorywidget.dart';
import 'package:badges/badges.dart' as badges;
import 'package:lab10/app/route/page3.dart';
import 'package:lab10/app/route/productwidget.dart';
import 'app/page/defaultwidget.dart';
import 'app/data/sharepre.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Mainpage extends StatefulWidget {
  const Mainpage({super.key, this.selectedIndex = 0});
  final int? selectedIndex;
  @override
  State<Mainpage> createState() => _MainpageState();
}

class _MainpageState extends State<Mainpage> {
  User user = User.userEmpty();
  int _selectedIndex = 0;

  getDataUser() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String strUser = pref.getString('user')!;

    user = User.fromJson(jsonDecode(strUser));
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = widget.selectedIndex!;
    getDataUser();
    print(user.imageURL);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _loadWidget(int index) {
    var nameWidgets = "Home";
    switch (index) {
      case 0:
        nameWidgets = "Home";
        return DetailMain(
          nameWidget: nameWidgets,
          user: user,
          isAdmin: false,
        );

      case 1:
        nameWidgets = "Bill";
        return const BillDefault();
      case 2:
        nameWidgets = "Cart";
        List<CartModel> getCartItems = FlutterCart().cartItemsList;
        return CartDefault(
          listCartItems: getCartItems,
          user: user,
        );
      case 3:
        {
          nameWidgets = "Detail";
          return DetailMain(
            nameWidget: nameWidgets,
          );
        }
      default:
        nameWidgets = "None";
        break;
    }
    return DefaultWidget(title: nameWidgets);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HL Mobile"),
        actions: [
          // _selectedIndex == 2
          //     ? Padding(
          //         padding: const EdgeInsets.only(right: 16),
          //         child: badges.Badge(
          //           badgeContent: Text(FlutterCart().cartLength.toString()),
          //           child: const Icon(Icons.shopping_cart),
          //         ),
          //       )
          //     : Container()
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade800,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  user.imageURL!.length < 5
                      ? const SizedBox()
                      : CircleAvatar(
                          backgroundColor: Colors.blue.shade900,
                          radius: 48,
                          child: CircleAvatar(
                            backgroundColor: Colors.blue.shade100,
                            radius: 46,
                            child: CircleAvatar(
                              backgroundImage: user.imageURL != null
                                  ? NetworkImage(user.imageURL!)
                                  : const AssetImage(
                                          "assets/images/hlphone_logo.png")
                                      as ImageProvider,
                              radius: 44,
                            ),
                          ),
                        ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    user.fullName!,
                    style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('History'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 1;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Cart'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 2;
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.pages),
              title: const Text('Loại sản phẩm (admin)'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryDefault(
                              user: user,
                              isAdmin: true,
                            )));
              },
            ),
            ListTile(
              leading: const Icon(Icons.pages),
              title: const Text('Danh sách sản phẩm (admin)'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductDefault(
                              user: user,
                              isAdmin: true,
                            )));
              },
            ),
            ListTile(
              leading: const Icon(Icons.pages),
              title: const Text('Page3'),
              onTap: () {
                Navigator.pop(context);
                _selectedIndex = 0;
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Page3()));
              },
            ),
            const Divider(
              color: Colors.black,
            ),
            user.accountId == ''
                ? const SizedBox()
                : ListTile(
                    leading: const Icon(Icons.exit_to_app),
                    title: const Text('Logout'),
                    onTap: () {
                      logOut(context);
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue.shade900,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
      body: _loadWidget(_selectedIndex),
    );
  }
}
