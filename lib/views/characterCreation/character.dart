import 'package:flutter/material.dart';
import '../../utils/jsonHandler.dart';
import '../../utils/colors.dart';
import '../../utils/button.dart';
import 'classSelection.dart';
import '../game/base.dart';

import 'dart:math' as math;
int pointsLeft = 10;
int strength = 8;
int dexterity = 8;
int endurance = 8;
int charisma = 8;
int intelligence = 8;
class CharacterView extends StatefulWidget {
  final className;
  const CharacterView({super.key, this.className});

  @override
  State<CharacterView> createState() => _CharacterViewState();
}

class _CharacterViewState extends State<CharacterView> {
  final JsonHandler jsonHandler = JsonHandler("classes.json");
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    void showErrorDialog(String text) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          titleTextStyle: TextStyle(
            color: Colors.black
          ),
          content: Text(text),
          contentTextStyle: TextStyle(
            color: Colors.black
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Ok'))
          ],
        );
      });
    }
    void saveJsonAndLoadNew(String name) async{
      JsonHandler jsonCharacter = JsonHandler('character.json');
      jsonCharacter.writeToFile('{"class": "${widget.className}", "name": "$name", "hp": ${10*endurance}, "skills": {"Strength": $strength, "Dexterity": $dexterity,"Endurance": $endurance, "Charisma": $charisma, "Intelligence": $intelligence, "Luck": 20}, "save": {"act": "1", "scene": "1001"}}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BaseView()),
      );
    }
    return FutureBuilder<Map<String, dynamic>?>(
      future: jsonHandler.readText(),
      builder: (context, snapshot) {
        Map<String, dynamic>? result = snapshot.data;

        return Scaffold(
          body: Align(
            alignment: Alignment.center,
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(result?[widget.className]['image']),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          TextField(
                            controller: _controller,
                            cursorColor: Colors.white,
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                                hintText: "Your Name",
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                )
                            ),
                          ),
                          SizedBox(height: 20),
                          Skill(),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ButtonContainer(
                                  onTap: () {
                                    strength = dexterity = endurance = charisma = intelligence = 8;
                                    pointsLeft = 10;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ClassSelectionView()),
                                    );
                                  },
                                  width: 100.0,
                                  child: Text('Back')
                              ),
                              ButtonContainer(
                                  onTap: () {
                                    if (_controller.text.isEmpty) {
                                      showErrorDialog("You can't have empty namee");
                                    } else if (pointsLeft != 0) {
                                      showErrorDialog("You have to spent all of your points");
                                    } else {
                                      saveJsonAndLoadNew(_controller.text);
                                    }
                                  },
                                  width: 150.0,
                                  child: Text('Create Character')
                              ),
                            ],
                          )
                        ]
                    )
                )
            )
        ),
      );
    });
  }
}

class Skill extends StatefulWidget {
  @override
  State<Skill> createState() => _SkillState();
}

class _SkillState extends State<Skill> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Strength'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: (strength == 8) ? null : () => setState(() {
                strength--;
                pointsLeft++;
              }),
              child: Text('-')
            ),
            Row(
              children: List.generate(strength, (index) => _buildBox()),
            ),
            TextButton(
              onPressed: (strength == 15 || pointsLeft == 0) ? null : () => setState(() {
                strength++;
                pointsLeft--;
              }),
              child: Text('+')
            ),
          ],
        ),
        Text('Dexterity'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: (dexterity == 8) ? null : () => setState(() {
                dexterity--;
                pointsLeft++;
              }),
              child: Text('-')
            ),
            Row(
              children: List.generate(dexterity, (index) => _buildBox()),
            ),
            TextButton(
              onPressed: (dexterity == 15 || pointsLeft == 0) ? null : () => setState(() {
                dexterity++;
                pointsLeft--;
              }),
                child: Text('+')
            ),
          ],
        ),
        Text('Endurance'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: (endurance == 8) ? null : () => setState(() {
                endurance--;
                pointsLeft++;
              }),
              child: Text('-')
            ),
            Row(
              children: List.generate(endurance, (index) => _buildBox()),
            ),
            TextButton(
              onPressed: (endurance == 15 || pointsLeft == 0) ? null : () => setState(() {
                endurance++;
                pointsLeft--;
              }),
                child: Text('+')
            ),
          ],
        ),
        Text('Charisma'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: (charisma == 8) ? null : () => setState(() {
                charisma--;
                pointsLeft++;
              }),
              child: Text('-')
            ),
            Row(
              children: List.generate(charisma, (index) => _buildBox()),
            ),
            TextButton(
              onPressed: (charisma == 15 || pointsLeft == 0) ? null : () => setState(() {
                charisma++;
                pointsLeft--;
              }),
                child: Text('+')
            ),
          ],
        ),
        Text('Intelligence'),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: (intelligence == 8) ? null : () => setState(() {
                intelligence--;
                pointsLeft++;
              }),
              child: Text('-')
            ),
            Row(
              children: List.generate(intelligence, (index) => _buildBox()),
            ),
            TextButton(
              onPressed: (intelligence == 15 || pointsLeft == 0) ? null : () => setState(() {
                intelligence++;
                pointsLeft--;
              }),
                child: Text('+')
            ),
          ],
        ),
        SizedBox(height: 20),
        Text("Points Left: $pointsLeft")
      ],
    );
  }
  Widget _buildBox() {
    return Container(
      width: 10.0,
      height: 5.0,
      color: AppColors.blue,
      margin: EdgeInsets.all(2.0),
    );
  }
}