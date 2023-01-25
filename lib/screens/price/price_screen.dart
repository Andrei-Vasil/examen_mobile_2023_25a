import 'package:flutter/material.dart';
import 'package:my_albums_flutter/screens/price/price_view_model.dart';

import '../../models/entity.dart';
import '../../repo/entity_repo.dart';
import '../../utils.dart';
import '../../widgets/entity_list_tile.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  final PriceViewModel _viewModel = PriceViewModel(
    EntityRepo(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _screen,
    );
  }

  AppBar get _appBar => AppBar(
        title: const Text(
          "Price",
          style: TextStyle(fontSize: 30, color: Colors.black54),
        ),
      );

  Widget get _screen {
    return Utils.checkInternetScreenWrapper(
      onRetry: () => setState(() {}),
      child: StreamBuilder<List<Item>>(
          stream: _viewModel.getDiscounted(),
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
                            onInc: () {
                              if (e.id != null) {
                                _viewModel.updatePrice(e.id!, e.price! + 1);
                                Utils.displayMessage(
                                  context,
                                  'Success on price increment',
                                );
                                setState(() {});
                              } else {
                                Utils.displayError(
                                  context,
                                  'Error on price increment.',
                                );
                                setState(() {});
                              }
                            }))
                        .toList(),
                  );
          }),
    );
  }
}
