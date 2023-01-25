import 'package:flutter/material.dart';
import 'package:my_albums_flutter/repo/entity_repo.dart';
import 'package:my_albums_flutter/screens/status/status_view_model.dart';
import 'package:my_albums_flutter/widgets/generic_list_tile.dart';

import '../../utils.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  final StatusViewModel _viewModel = StatusViewModel(EntityRepo());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: Utils.checkInternetScreenWrapper(
        onRetry: () => setState(() {}),
        child: _screen,
      ),
    );
  }

  Widget get _screen => StreamBuilder(
        stream: _viewModel.getEntities(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(children: [
              const SizedBox(height: 10),
              const Text(
                "Top 10 most popular games",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const Divider(
                color: Colors.white70,
                thickness: 2,
              ),
              ...(_viewModel
                  .getTop10MostPopularGames(snapshot.data!)
                  .map((e) => GenericListTile(
                        title: e.name!,
                        subtitles: [
                          e.price!.toString(),
                          e.description!,
                          e.units.toString(),
                          e.category!,
                        ],
                      ))
                  .toList()),
              const SizedBox(height: 30),
            ]);
          }
        },
      );

  AppBar get _appBar => AppBar(
        title: const Text(
          "Leaderboard",
          style: TextStyle(fontSize: 30, color: Colors.black54),
        ),
      );
}
