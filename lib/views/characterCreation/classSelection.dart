import 'package:flutter/material.dart';
import 'package:gierka/utils/colors.dart';
import '../../utils/jsonHandler.dart';
import 'package:flutter/services.dart';
import '../../utils/button.dart';
import '../characterCreation/character.dart';


class ClassSelectionView extends StatefulWidget {
  const ClassSelectionView({super.key});
  @override
  State<ClassSelectionView> createState() => _ClassSelectionViewState();
}

class _ClassSelectionViewState extends State<ClassSelectionView> {
  int selectedImageIndex = -1;
  bool allSelected = true;


  @override
  Widget build(BuildContext context) {

    void handleImageTap(int index) {
      setState(() {
        selectedImageIndex = index;
        allSelected = false;
      });
    }
    void handleImageTap2(int index) {
      setState(() {
        selectedImageIndex = -1;
        allSelected = true;
      });
    }
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClassSelectionImage(
                index: 'mage',
                selectedIndex: selectedImageIndex == 0,
                isSelected: allSelected,
                onTap: () {
                  handleImageTap(0);
                },
                onTap2: () {
                  handleImageTap2(0);
                },
              ),
              ClassSelectionImage(
                index: 'warrior',
                selectedIndex: selectedImageIndex == 1,
                isSelected: allSelected,
                onTap: () {
                  handleImageTap(1);
                },
                onTap2: () {
                  handleImageTap2(1);
                },
              ),
              ClassSelectionImage(
                index: 'archer',
                selectedIndex: selectedImageIndex == 2,
                isSelected: allSelected,
                onTap: () {
                  handleImageTap(2);
                },
                onTap2: () {
                  handleImageTap2(2);
                },
              ),
            ],
          ),
        )
      ),
    );
  }

}
class ClassSelectionDescription extends StatelessWidget {
  final className;
  final description;
  final image;

  const ClassSelectionDescription({
    super.key,
    this.className,
    this.description,
    this.image
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text(this.description),
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ClassSelectionView()),
                        );
                      },
                      color: AppColors.blue,
                      child: Text('Back')
                    ),
                    ButtonContainer(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CharacterView(className: className)),
                        );
                      },
                      color: AppColors.blue,
                      child: Text('Next')
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class ClassSelectionImage extends StatelessWidget {
  final String index;
  final bool selectedIndex;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onTap2;

  ClassSelectionImage({
    Key? key,
    required this.index,
    required this.selectedIndex,
    required this.isSelected,
    required this.onTap,
    required this.onTap2,
  }) : super(key: key);

  final JsonHandler jsonHandler = JsonHandler("classes.json");

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: jsonHandler.readText(),
      builder: (context, snapshot) {
        Map<String, dynamic>? result = snapshot.data;
        return Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ClassSelectionDescription(
                      className: index,
                      description: result?[index]['description'],
                      image: result?[index]['image']
                    )
                ),
              ),
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(result?[index]['image']),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}