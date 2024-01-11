import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/jsonHandler.dart';
import '../../utils/button.dart';
import '../characterCreation/classSelection.dart';
import '../game/base.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    JsonHandler checkSaveFile = JsonHandler('character.json');

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: Typography.whiteMountainView,
        scaffoldBackgroundColor: AppColors.black, // Set your desired background color here
      ),
      home: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: FutureBuilder<bool>(
              future: checkSaveFile.checkFileExist(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                bool exist = snapshot.data == true;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ButtonContainer(
                      onTap: () {
                        if (exist) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BaseView()),
                          );
                        }
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(
                          color: (exist) ? AppColors.white : AppColors.whiteDisabled
                        ),
                      )
                    ),
                    SizedBox(height: 20),
                    ButtonContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ClassSelectionView()),
                        );
                      },
                      child: Text(
                        "New Game",
                        style: TextStyle(
                          color: Colors.white
                        ),
                      )
                    ),
                  ],
                );
              },
            )
          ),
        ),
      ),
    );
  }
}

