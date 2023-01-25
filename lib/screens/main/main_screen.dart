import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_albums_flutter/repo/shared_pref_repo.dart';
import 'package:my_albums_flutter/screens/add/add_edit_screen.dart';
import 'package:my_albums_flutter/screens/main/main_view_model.dart';
import 'package:my_albums_flutter/theme/app_colors.dart';

import '../../repo/entity_repo.dart';
import '../../utils.dart';
import '../../widgets/entity_list_tile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainViewModel _viewModel =
      MainViewModel(SharedPrefsRepo(), EntityRepo());
  final TextEditingController _textEditingController = TextEditingController();
  StreamSubscription? _subscription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _screen,
    );
  }

  Widget get _screen => SingleChildScrollView(
        child: StreamBuilder(
            stream: _viewModel.getUserName(),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Utils.checkInternetScreenWrapper(
                      onRetry: () => setState(() {}),
                      onUseLocal: () => setState(() {
                        EntityRepo.useLocal = true;
                      }),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Center(
                              child: Icon(
                            Icons.account_circle,
                            size: 200,
                          )),
                          Text(
                            snapshot.data == null
                                ? "User name is not set!"
                                : snapshot.data!,
                            style: const TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
                          TextField(
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.zero,
                              labelStyle: const TextStyle(color: Colors.grey),
                              suffix: IconButton(
                                onPressed: _onSave,
                                icon: const Icon(
                                  Icons.check,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                            ),
                            controller: _textEditingController,
                            style: const TextStyle(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          if (snapshot.data != null) ...[
                            Text(
                              "${snapshot.data}'s games:",
                              style: const TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            const SizedBox(
                              height: 25,
                            ),
                            _userGamesWidget(snapshot.data!)
                          ]
                        ],
                      ),
                    );
            }),
      );

  Widget _userGamesWidget(String owner) => StreamBuilder(
      stream: _viewModel.getUserGames(owner),
      builder: (context2, snapshot2) {
        return snapshot2.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot2.data!
                    .map((e) => EntityListTile(entity: e))
                    .toList(),
              );
      });

  AppBar get _appBar => AppBar(
        title: const Text(
          "User",
          style: TextStyle(fontSize: 30, color: Colors.black54),
        ),
        actions: [
          StreamBuilder(
              stream: _viewModel.getUserName(),
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return Container();
                }
                return IconButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              AddEditScreen(userName: snapshot.data!)))
                      .then((_) {
                    setState(() {});
                  }),
                  icon: const Icon(Icons.add_circle, color: Colors.black54),
                );
              }),
          if (EntityRepo.useLocal)
            IconButton(
              onPressed: () => setState(() {
                EntityRepo.useLocal = false;
              }),
              icon: const Icon(Icons.cloud, color: Colors.black54),
            ),
        ],
      );

  VoidCallback get _onSave => () {
        _subscription =
            _viewModel.setUserName(_textEditingController.text).listen((event) {
          if (!event) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Utils.displayError(
                  context, "There was an error setting the name!");
            });
          } else {
            setState(() {
              _textEditingController.clear();
            });
          }
        });
      };

  @override
  void dispose() {
    _subscription?.cancel();
    _textEditingController.dispose();
    super.dispose();
  }
}
