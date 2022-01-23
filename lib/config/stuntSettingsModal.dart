import 'dart:convert';

import 'package:cheer_skill/config/settings.dart';
import 'package:cheer_skill/test.dart';
import 'package:flutter/material.dart';

import '../strings.dart';

class StuntSettingsModal extends StatefulWidget {
  final Function createStunt;

  const StuntSettingsModal({Key? key, required this.createStunt})
      : super(key: key);

  @override
  _StuntSettingsModalState createState() => _StuntSettingsModalState();
}

class _StuntSettingsModalState extends State<StuntSettingsModal> {
  var _levels = [];
  var selectedLevel = "level_5";

  Future<dynamic> _fetchLevels() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/data/varsity_skills.json");
    var levelMap = jsonDecode(data)[year]["levels"] as Map;
    var levelList = [];
    for (dynamic i in levelMap.keys) {
      levelList.add(levelMap[i]["name"]);
    }
    setState(() {
      _levels = levelList;
    });
  }

  List<Widget> _mapLevelsToWidget() {
    return _levels
        .map(
          (e) => SizedBox(
            width: 200.0,
            child: ListTile(
              title: Text(e),
              leading: Radio<String>(
                value: e,
                groupValue: selectedLevel,
                onChanged: (String? value) {
                  setState(() {
                    selectedLevel = value!;
                  });
                  print(selectedLevel);
                },
              ),
            ),
          ),
        )
        .toList();
  }

  @override
  void initState() {
    _fetchLevels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 500,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(newSequenceConfig),
              //DropdownSelector(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _mapLevelsToWidget(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  widget.createStunt();
                  Navigator.pop(context);
                },
                child: SizedBox(
                  child: const Text(saveStuntSettings),
                  width: MediaQuery.of(context).size.width / 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
