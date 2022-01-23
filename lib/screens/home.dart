import 'dart:convert';
import 'dart:math';

import 'package:cheer_skill/config/settings.dart';
import 'package:cheer_skill/config/stuntSettings.dart';
import 'package:cheer_skill/config/stuntSettingsModal.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => StuntSequencePage();
}

class StuntSequencePage extends State<MyHomePage> {
  final _stuntSequence = [];

  var _varsitySkillList = {};
  var _skills = "";

  final _startingSkills = [];
  final _middleSkills = [];
  final _dismountSkills = [];

  _updateSkills() {
    var skills = "";
    for (var i = 0; i < _stuntSequence.length; i++) {
      skills = skills + "\n\n" + _stuntSequence[i]["name"];
    }
    _skills = skills;
  }

  void _populateSkills(int levelNumber) {
    var level = "level_" + levelNumber.toString();
    var levelSkillList = _varsitySkillList[level];
    for (dynamic i in levelSkillList.keys) {
      for (dynamic j in levelSkillList[i].keys) {
        var skillMoment = levelSkillList[i][j]["moment"];
        if (skillMoment["start"]) {
          _startingSkills.add(levelSkillList[i][j]);
        }
        if (skillMoment["mid"]) {
          _middleSkills.add(levelSkillList[i][j]);
        }
        if (skillMoment["dismount"]) {
          _dismountSkills.add(levelSkillList[i][j]);
        }
      }
    }
  }

  void _clearSkills() {
    _startingSkills.clear();
    _middleSkills.clear();
    _dismountSkills.clear();
  }

  void _createStunt(int level, bool lowerLevel) {
    _clearSkills();

    _populateSkills(level);
    if (lowerLevel) {
      _populateSkills(level - 1);
    }

    setState(() {
      if (true) {
        _stuntSequence.clear();
      }
      _stuntSequence
          .add(_startingSkills[Random().nextInt(_startingSkills.length - 1)]);
      for (var i = Random().nextInt(3); i < Random().nextInt(5); i++) {
        _stuntSequence.add(_middleSkills[i]);
      }
      _stuntSequence
          .add(_dismountSkills[Random().nextInt((_dismountSkills.length - 1))]);

      _updateSkills();
    });
  }

  void createStunt() {
    _createStunt(StuntSettings().level, StuntSettings().lowerLevel);
  }

  Future<dynamic> _fetchVarsitySkills() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/data/varsity_skills.json");
    final jsonResult = jsonDecode(data);
    _varsitySkillList = jsonResult[year][language] as Map;
    return jsonResult;
  }

  @override
  void initState() {
    _fetchVarsitySkills();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _skills,
                style: const TextStyle(fontSize: 25),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return StuntSettingsModal(
                createStunt: createStunt,
              );
            },
          );
        },
        tooltip: 'Create Sequence',
        child: const Icon(Icons.settings),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,
    );
  }
}
