import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_albums_flutter/repo/entity_repo.dart';

class Utils {
  static Future<bool> get checkInternetConnection async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        EntityRepo.hasInternet = true;
        return true;
      }
      EntityRepo.hasInternet = false;
      return false;
    } on SocketException catch (_) {
      EntityRepo.hasInternet = false;
      return false;
    }
  }

  static void displayError(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("ERROR"),
          content: Text(error),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK")),
          ]),
    );
  }

  static void displayMessage(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text("Special message just 4 u"),
          content: Text(error),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK")),
          ]),
    );
  }

  static Widget checkInternetScreenWrapper({
    required Widget child,
    required VoidCallback onRetry,
    VoidCallback? onUseLocal,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: FutureBuilder<bool>(
        future: Utils.checkInternetConnection,
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : snapshot.data == false && !EntityRepo.useLocal
                    ? _noInternetWidget(onRetry, onUseLocal)
                    : child,
      ),
    );
  }

  static Widget _noInternetWidget(
    VoidCallback onRetry,
    VoidCallback? onUseLocal,
  ) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "It seems there is a problem with your internet connection.",
            style: TextStyle(
              fontSize: 21,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          TextButton(
            onPressed: onRetry,
            child: const Text(
              "Retry",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
          if (onUseLocal != null)
            TextButton(
              onPressed: onUseLocal,
              child: const Text(
                "Use local db",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
        ],
      );
}
