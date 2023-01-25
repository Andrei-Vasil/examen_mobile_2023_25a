import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_albums_flutter/screens/home/home_view_model.dart';
import 'package:my_albums_flutter/screens/price/price_screen.dart';

import '../../utils.dart';
import '../main/main_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final HomeViewModel _viewModel = HomeViewModel();
  StreamSubscription? _subscription;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    _subscription = _viewModel.listenForAddedItems().listen((entity) {
      Future.delayed(const Duration(milliseconds: 300)).then((_) => showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("A new item was added!"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entity.name ?? ""),
                    Text(entity.description ?? ""),
                    Text(entity.image ?? ""),
                    Text(entity.category ?? ""),
                    Text(entity.units.toString()),
                    Text(entity.price.toString()),
                  ],
                ),
              )));
    })
      ..onError((error) {
        Utils.displayError(context, error.toString());
      });
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentScreen,
      bottomNavigationBar: _bottomNavBar,
    );
  }

  Widget get _currentScreen {
    switch (_selectedTabIndex) {
      case 0:
        return const MainScreen();
      case 1:
        return const PriceScreen();
      default:
        return const PriceScreen();
    }
  }

  Widget get _bottomNavBar => BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black12,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Register',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Manage',
          ),
        ],
        currentIndex: _selectedTabIndex,
        onTap: (index) => setState(() {
          _selectedTabIndex = index;
        }),
      );

  @override
  void dispose() {
    _subscription?.cancel();
    _viewModel.dispose();
    super.dispose();
  }
}
