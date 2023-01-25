import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_albums_flutter/screens/add/add_edit_screen.dart';
import 'package:my_albums_flutter/screens/main/main_view_model.dart';
import 'package:my_albums_flutter/theme/app_colors.dart';
import 'package:my_albums_flutter/widgets/category_list_tile.dart';

import '../../repo/entity_repo.dart';
import '../../utils.dart';
import '../../widgets/entity_list_tile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainViewModel _viewModel = MainViewModel(EntityRepo());
  final TextEditingController _textEditingController = TextEditingController();
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _screen,
    );
  }

  Widget get _screen => SingleChildScrollView(
        child: Utils.checkInternetScreenWrapper(
          onRetry: () => setState(() {}),
          onUseLocal: () => setState(() {
            EntityRepo.useLocal = true;
          }),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _categoriesWidget(),
              const Divider(
                color: Colors.white70,
                thickness: 2,
              ),
              const SizedBox(height: 10),
              Text(
                selectedCategory == null
                    ? "Category not selected!"
                    : selectedCategory!,
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
              if (selectedCategory != null) ...[
                Text(
                  "Items of category ${selectedCategory!}:",
                  style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                const SizedBox(
                  height: 25,
                ),
                _categoryItemsWidget(selectedCategory!)
              ]
            ],
          ),
        ),
      );

  Widget _categoriesWidget() => StreamBuilder(
      stream: _viewModel.getCategories(),
      builder: (context2, snapshot2) {
        return snapshot2.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot2.data!
                    .map((e) => CategoryListTile(category: e))
                    .toList(),
              );
      });

  Widget _categoryItemsWidget(String category) => StreamBuilder(
      stream: _viewModel.getItemsForCategory(category),
      builder: (context2, snapshot2) {
        return snapshot2.connectionState == ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot2.data!
                    .map((e) => EntityListTile(
                          entity: e,
                          onDelete: () {
                            _viewModel.deleteItem(e.id!).first.then((_) {
                              Utils.displayMessage(
                                context,
                                'Success on delete',
                              );
                              setState(() {});
                            }).onError((error, stackTrace) {
                              Utils.displayError(
                                context,
                                'Error on delete.',
                              );
                              setState(() {});
                            });
                          },
                        ))
                    .toList(),
              );
      });

  AppBar get _appBar => AppBar(
        title: const Text(
          "Main",
          style: TextStyle(fontSize: 30, color: Colors.black54),
        ),
        actions: [
          if (EntityRepo.hasInternet)
            IconButton(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (BuildContext context) => const AddEditScreen()))
                  .then((_) {
                setState(() {});
              }),
              icon: const Icon(Icons.add_circle, color: Colors.black54),
            ),
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
        selectedCategory = _textEditingController.text;
        setState(() {
          _textEditingController.clear();
        });
      };

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
