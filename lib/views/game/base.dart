import 'dart:math';

import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import 'dart:math' as math;
import '../../utils/jsonHandler.dart';

class BaseView extends StatelessWidget {
  BaseView({super.key});
  final JsonHandler jsonHandler = JsonHandler("character.json");
  final JsonHandler jsonClasses = JsonHandler("classes.json");
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: jsonHandler.readFile(),
      builder: (context, snapshot) {
        Map<String, dynamic>? result = snapshot.data;
        return Scaffold(
            body: Padding(
              padding: EdgeInsets.only(top: 40, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              FutureBuilder<Map<String, dynamic>?>(
                                future: jsonClasses.readText(),
                                builder: (context, imageSnapshot) {
                                  Map<String, dynamic>? imageResult = imageSnapshot.data;
                                  return Image.asset(
                                    imageResult?[result?['class']]['image'],
                                    width: 100,
                                    height: 100,
                                  );
                                },
                              ),
                              Flex(
                                direction: Axis.vertical,
                                children: [
                                  Text(result?['name']),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Image.asset(
                                        'assets/images/heart.png',
                                        width: 15,
                                        height: 15,
                                      ),
                                      Text(result!['hp'].toString())
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              Flex(
                                direction: Axis.vertical,
                                children: [
                                  StatShow(result: result, statName: 'Strength'),
                                  SizedBox(height: 5),
                                  StatShow(result: result, statName: 'Dexterity'),
                                  SizedBox(height: 5),
                                  StatShow(result: result, statName: 'Endurance'),
                                ],
                              ),
                              SizedBox(width: 10),
                              Flex(
                                direction: Axis.vertical,
                                children: [
                                  StatShow(result: result, statName: 'Charisma'),
                                  SizedBox(height: 5),
                                  StatShow(result: result, statName: 'Intelligence'),
                                  SizedBox(height: 5),
                                  StatShow(result: result, statName: 'Luck'),
                                ],
                              )

                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GameView(character: result)
                  ],
                ),
              )
            ),
        );
      }
    );
  }
}
class StatShow extends StatelessWidget {
  final result;
  final statName;
  const StatShow({
    super.key,
    this.result,
    this.statName
  });

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: [
        Image.asset(
          'assets/images/$statName.png',
          width: 15,
          height: 15,
        ),
        SizedBox(width: 5),
        Text(result!['skills'][statName].toString())
      ],
    );
  }

}
class GameView extends StatelessWidget {
  final character;

  const GameView({
    super.key,
    this.character
  });

  Widget build(BuildContext context) {
  final JsonHandler jsonGame = JsonHandler('story${character['save']['act']}.json');
    return FutureBuilder<Map<String, dynamic>?>(
      future: jsonGame.readText(),
      builder: (context, snapshot) {
        Map<String, dynamic>? result = snapshot.data;
        var sceneData = result?[character['save']['scene']];
        var options = sceneData['options'];
        return Flex(
          direction: Axis.vertical,
          children: [
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.white,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  sceneData['text'],
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            GameOptionChoice(
              options: options,
              character: character
            )
          ],
        );
      },
    );
  }
}

class GameOptionChoice extends StatelessWidget{
  final options;
  final character;

  const GameOptionChoice({
    super.key,
    this.options,
    this.character
  });

  @override
  Widget build(BuildContext context) {

    getOptionColor(action) {
      if (action == 'diceRoll') {
        return Colors.yellow;
      } else if (action == 'combatEncounters') {
        return Colors.red;
      } else {
        return Colors.white;
      }
    }

    changeSaveFile(saveFile){
      JsonHandler jsonCharacter = JsonHandler('character.json');
      jsonCharacter.writeToFile('{"class": "${saveFile['class']}", "name": "${saveFile['name']}", "hp": ${saveFile['hp']} "skills": {"Strength": ${saveFile['skills']['Strength']}, "Dexterity": ${saveFile['skills']['Dexterity']},"Endurance": ${saveFile['skills']['Endurance']}, "Charisma": ${saveFile['skills']['Charisma']}, "Intelligence": ${saveFile['skills']['Intelligence']}, "Luck": ${saveFile['skills']['Luck']}}, "save": {"act": "${saveFile['save']['act']}", "scene": "${saveFile['save']['scene']}"}}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => BaseView()),
      );
    }

    diceRollAction2(action, saveFile) {
      int randomNumber = Random().nextInt(20) + 1;
      String textFromNumber = '';
      bool useLuck = false;
      if (randomNumber <= saveFile['skills'][action['statsRequired']]) {
        textFromNumber = "Success";
        saveFile['save']['scene'] = action['success'];
        if (randomNumber == 1) {
          textFromNumber = "Critical Success";
          saveFile['skills'][action['statsRequired']] += 1;
        }
      } else {
        textFromNumber = "Failure";
        saveFile['save']['scene'] = action['failed'];
        if (randomNumber == 20) {
          textFromNumber = "Critical Failure";
          saveFile['skills'][action['statsRequired']] -= 1;
        } else {
          num difference = randomNumber - saveFile['skills'][action['statsRequired']];
          if (difference <= saveFile['skills']['Luck']) {
            useLuck = true;
          }

        }
      }
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              if (!useLuck) {
                changeSaveFile(saveFile);
              }
            },
            child: Container(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.vertical,
                  children: [
                    Text(textFromNumber),
                    Text(
                      randomNumber.toString(),
                      style: TextStyle(
                        fontSize: 40
                      ),
                    ),
                    (useLuck)
                        ? Padding(
                          padding: EdgeInsets.all(20),
                          child: Flex(
                            direction: Axis.vertical,
                            children: [
                              GestureDetector(
                                child: Container(
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: Colors.white
                                    )
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(10),
                                    child: Text("Use Luck"),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                        : Container()
                  ],
                )
              ),
            ),
          );
        }
      );
    }

    diceRollAction(action, saveFile) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
                diceRollAction2(action, saveFile);
              },
              child: Container(
                width: 300,
                height: 300,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.white,
                  ),
                ),
                child: Flex(
                  mainAxisAlignment: MainAxisAlignment.center,
                  direction: Axis.vertical,
                  children: [
                    SizedBox(height: 10),
                    Text(
                      '${action['statsRequired']} check',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Click here to roll a dice'),
                    SizedBox(height: 20),
                    Text(
                      "1 - Critical success (+1 to ${action['statsRequired']}) \n"
                      ">= ${saveFile['skills'][action['statsRequired']]} - Success\n"
                      "< ${saveFile['skills'][action['statsRequired']]} - Failure\n"
                      "20 - Critical failure (-1 to ${action['statsRequired']})\n",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10
                      ),
                    ),
                  ],
                )
              ),
            )
          );
        }
      );
    }

    changeScreenBasedOnAction(action, saveFile) {

      if (action['name'] == 'diceRoll') {
        diceRollAction(action, saveFile);
      } else if (action['name'] == 'combatEncounters') {
      } else if (action['name'] == 'actEnding') {
        saveFile['save']['act'] = action['success'];
        changeSaveFile(saveFile);
      } else {
        saveFile['save']['scene'] = action['success'];
        changeSaveFile(saveFile);
      }
    }

    return Flex(
      direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var optionKey in options.keys)
          Flex(
            direction: Axis.vertical,
            children: [
              GestureDetector(
                onTap: () {
                  changeScreenBasedOnAction(options[optionKey]['action'], character);
                },
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 2,
                      color: getOptionColor(options[optionKey]['action']['name']),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Flex(
                      direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        (options[optionKey]['action']['name'] == 'diceRoll')
                          ? Image.asset(
                            'assets/images/${options[optionKey]['action']['statsRequired']}.png',
                          width: 15,
                          height: 15,
                        )
                          : Container(),
                        Text(
                          options[optionKey]['title'],
                          style: TextStyle(
                            color: getOptionColor(options[optionKey]['action']['name']),
                          ),
                        ),
                        (options[optionKey]['action']['name'] == 'diceRoll')
                          ? Image.asset(
                            'assets/images/${options[optionKey]['action']['statsRequired']}.png',
                          width: 15,
                          height: 15,
                        )
                          : Container()
                      ],
                    )
                  ),
                ),
              ),
              SizedBox(height: 20)
            ],
          )
      ],
    );
  }
}