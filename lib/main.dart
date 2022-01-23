import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cheer Skill',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Cheer Skill'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _stuntSequence = [];
  final language = "en";
  final year = "2021-2022";

  var _varsitySkillList = {};
  var _skills = "skills";

  final _startingSkills = [];
  final _middleSkills = [];
  final _dismountSkills = [];

  Future<dynamic> _fetchVarsitySkills() async {
    String data = await DefaultAssetBundle.of(context).loadString("assets/data/varsity_skills.json");
    final jsonResult = jsonDecode(data);
    _varsitySkillList = jsonResult[year][language] as Map;
    return jsonResult;
  }

  void _createStunt(int levelNumber, bool lowerLevel) {
    _startingSkills.clear();
    _middleSkills.clear();
    _dismountSkills.clear();

    var level = "level_" + levelNumber.toString();
    for (dynamic i in _varsitySkillList[level].keys) {
      for (dynamic j in _varsitySkillList[level][i].keys) {
        if (_varsitySkillList[level][i][j]["moment"]["start"]) {
          _startingSkills.add(_varsitySkillList["level_5"][i][j]);
        }
        if (_varsitySkillList[level][i][j]["moment"]["mid"]) {
          _middleSkills.add(_varsitySkillList["level_5"][i][j]);
        }
        if (_varsitySkillList[level][i][j]["moment"]["dismount"]) {
          _dismountSkills.add(_varsitySkillList["level_5"][i][j]);
        }
      }
    }
    if (lowerLevel){
      var lower_level = "level_" + levelNumber.toString();
      for (dynamic i in _varsitySkillList[lower_level].keys) {
        for (dynamic j in _varsitySkillList[lower_level][i].keys) {
          if (_varsitySkillList[lower_level][i][j]["moment"]["start"]) {
            _startingSkills.add(_varsitySkillList["level_5"][i][j]);
          }
          if (_varsitySkillList[lower_level][i][j]["moment"]["mid"]) {
            _middleSkills.add(_varsitySkillList["level_5"][i][j]);
          }
          if (_varsitySkillList[lower_level][i][j]["moment"]["dismount"]) {
            _dismountSkills.add(_varsitySkillList["level_5"][i][j]);
          }
        }
      }
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
      _stuntSequence.add(_dismountSkills[Random().nextInt((_dismountSkills.length - 1))]);
    });
    _updateSkills();
  }

  _updateSkills() {
    var skills = "";
    for (var i = 0; i < _stuntSequence.length; i++) {
      skills = skills + "\n\n" + _stuntSequence[i]["name"];
    }
    _skills = skills;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _skills,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createStunt(5, true),
        tooltip: 'Create Sequence',
        child: const Icon(Icons.check),
      ),
    );
  }
}
