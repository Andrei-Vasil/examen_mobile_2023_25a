import 'dart:async';

import 'package:flutter/material.dart';import 'package:floor/floor.dart';

import 'package:my_albums_flutter/models/entity.dart';
import 'package:my_albums_flutter/repo/entity_repo.dart';

import '../../../utils.dart';
import 'add_edit_view_model.dart';

class AddEditScreen extends StatefulWidget {
  final Item? entityToUpdate;
  final String? userName;

  const AddEditScreen({Key? key, this.entityToUpdate, this.userName}) : super(key: key);

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final AddEditViewModel _viewModel = AddEditViewModel(EntityRepo());
  late TextFieldDescriptor _nameDescriptor;
  late TextFieldDescriptor _statusDescriptor;
  late TextFieldDescriptor _sizeDescriptor;
  late TextFieldDescriptor _popScoreDescriptor;
  late bool _isInEditMode;
  StreamSubscription? _subscription;

  @override
  void initState() {
    super.initState();
    _isInEditMode = widget.entityToUpdate != null;
    _nameDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
        ..text = widget.entityToUpdate?.name ?? "",
      decoration: _getDecoration("Name"),
    );
    _statusDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
        ..text = widget.entityToUpdate?.description ?? "",
      decoration: _getDecoration("Status"),
    );
    _sizeDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
        ..text = widget.entityToUpdate?.units.toString() ?? "",
      decoration: _getDecoration("Size"),
      numericInput: true,
    );
    _popScoreDescriptor = TextFieldDescriptor(
      controller: TextEditingController()
        ..text = widget.entityToUpdate?.price.toString() ?? "",
      decoration: _getDecoration("Popularity Score"),
      numericInput: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar,
      body: _body,
    );
  }

  Widget get _body => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _textFieldFromDescriptor(_nameDescriptor),
              _textFieldFromDescriptor(_statusDescriptor),
              _textFieldFromDescriptor(_sizeDescriptor),
              _textFieldFromDescriptor(_popScoreDescriptor),
            ],
          ),
        ),
      );

  AppBar get _appBar => AppBar(
        foregroundColor: Colors.black54,
        title: Text(
          _isInEditMode ? "EDIT" : "ADD",
          style: const TextStyle(fontSize: 30, color: Colors.black54),
        ),
        actions: [
          IconButton(
            onPressed: _onDonePressed,
            icon: const Icon(
              Icons.check,
              color: Colors.black54,
            ),
          )
        ],
      );

  VoidCallback get _onDonePressed => () {
        listener(response) {
          if (response == "ok") {
            Navigator.of(context).pop();
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Utils.displayError(context, response.toString());
            });
          }
        }

        var plane = Item(
          id: _isInEditMode ? widget.entityToUpdate!.id : null,
          name: _nameDescriptor.controller.text,
          description: _statusDescriptor.controller.text,
          units: _sizeDescriptor.controller.text.isNotEmpty
              ? int.parse(_sizeDescriptor.controller.text)
              : 0,
          category: widget.userName,
          price: _popScoreDescriptor.controller.text.isNotEmpty
              ? int.parse(_popScoreDescriptor.controller.text)
              : 0,
        );

        if (_isInEditMode) {
          _subscription = _viewModel.updateEntity(plane).listen(listener);
        } else {
          _subscription = _viewModel.addEntity(plane).listen(listener);
        }
      };

  Widget _textFieldFromDescriptor(TextFieldDescriptor descriptor) => TextField(
        decoration: descriptor.decoration,
        controller: descriptor.controller,
        keyboardType:
            descriptor.numericInput ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.white),
      );

  InputDecoration _getDecoration(String title) => InputDecoration(
        labelText: title,
        labelStyle: const TextStyle(color: Colors.grey),
      );

  @override
  void dispose() {
    _subscription?.cancel();
    _nameDescriptor.controller.dispose();
    _statusDescriptor.controller.dispose();
    _popScoreDescriptor.controller.dispose();
    _sizeDescriptor.controller.dispose();
    super.dispose();
  }
}

class TextFieldDescriptor {
  final TextEditingController controller;
  final InputDecoration decoration;
  final bool numericInput;

  TextFieldDescriptor({
    required this.controller,
    required this.decoration,
    this.numericInput = false,
  });
}
