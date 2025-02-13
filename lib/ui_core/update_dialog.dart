import 'package:flutter/material.dart';

class UpdateDialog extends StatelessWidget {
  const UpdateDialog({super.key});

  static Future<void> show({
    required BuildContext context,
  }) async =>
      showDialog(
          context: context,
          builder: (context) => const UpdateDialog()
      );

  @override
  Widget build(BuildContext context) {
    return  Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Text(
                '新しいバージョンが\nリリースされました！',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Text(
              '新機能が公開されたので、\nアプリをバージョンアップしましょう！',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 5,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 18,
                    ),
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
