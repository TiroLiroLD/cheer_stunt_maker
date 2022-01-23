import 'package:flutter/material.dart';

import '../strings.dart';

class StuntSettingsModal extends StatefulWidget {
  final Function createStunt;
  const StuntSettingsModal({Key? key, required this.createStunt}) : super(key: key);

  @override
  _StuntSettingsModalState createState() => _StuntSettingsModalState();
}

class _StuntSettingsModalState extends State<StuntSettingsModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(newSequenceConfig),
            ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    widget.createStunt();
                    Navigator.pop(context);
                  },
                  child: const Text(newSequenceGo),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
