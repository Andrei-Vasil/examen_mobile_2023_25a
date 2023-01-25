import 'package:flutter/material.dart';
import 'package:my_albums_flutter/repo/shared_pref_repo.dart';
import 'package:my_albums_flutter/screens/selection/selection_view_model.dart';

import '../../models/entity.dart';
import '../../repo/entity_repo.dart';
import '../../utils.dart';
import '../../widgets/entity_list_tile.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({Key? key}) : super(key: key);

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  final SelectionViewModel _viewModel = SelectionViewModel(
    EntityRepo(),
    SharedPrefsRepo(),
  );
  String? userName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.getUserName(),
        builder: (context, snapshot) {
          userName = snapshot.data;
          return Scaffold(
            appBar: _appBar,
            body: _screen,
          );
        });
  }

  AppBar get _appBar => AppBar(
        title: Text(
          "Selection $userName",
          style: const TextStyle(fontSize: 30, color: Colors.black54),
        ),
      );

  Widget get _screen {
    return Utils.checkInternetScreenWrapper(
      onRetry: () => setState(() {}),
      child: StreamBuilder<List<Item>>(
          stream: _viewModel.getAvailableGames(),
          builder: (context, snapshot2) {
            if (snapshot2.error != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Utils.displayError(context, snapshot2.error.toString());
              });
              return Container();
            }
            return snapshot2.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: snapshot2.data!
                        .map((e) => EntityListTile(
                            entity: e,
                            onBorrow: () {
                              if (userName != null && e.id != null) {
                                _viewModel.borrowGame(
                                  e.id!,
                                  userName!,
                                );
                                Utils.displayError(
                                  context,
                                  'Game\'s been borrowed',
                                );
                              } else {
                                Utils.displayError(
                                  context,
                                  'User or book id is null $userName ${e.toJson().toString()}',
                                );
                              }
                            }))
                        .toList(),
                  );
          }),
    );
  }
}
