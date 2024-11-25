import 'package:flutter/material.dart';
import 'package:printing_press/colors/color_palette.dart';
import 'package:printing_press/view_model/home/home_view_model.dart';
import 'package:provider/provider.dart';

class RateListView extends StatefulWidget {
  const RateListView({super.key});

  @override
  State<RateListView> createState() => _RateListViewState();
}

class _RateListViewState extends State<RateListView> {
  navigateTo(BuildContext context, Widget screen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => screen));
  }

  List<String> buttonNames = [
    'Binding',
    'Design',
    'Machine',
    'News Paper',
    'Numbering',
    'Paper',
    'Paper Cutting',
    'Profit',
  ];

  List<IconData> icons = [
    Icons.my_library_books,
    Icons.design_services_rounded,
    Icons.handyman_rounded,
    Icons.newspaper,
    Icons.numbers_outlined,
    Icons.newspaper,
    Icons.cut,
    Icons.trending_up_rounded,
  ];

  // List<Widget> screenNames = [
  //   const BindingView(),
  //   const DesignView(),
  //   const MachineView(),
  //   const NewsPaperView(),
  //   const NumberingView(),
  //   const PaperView(),
  //   const PaperCuttingView(),
  //   const ProfitView(),
  // ];

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeViewModel>(
      builder: (context, value, child) => ListView.builder(
        padding: const EdgeInsets.only(top: 20),
        itemCount: buttonNames.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pop(context);
              value.updateRateListIndex(index);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30.0,
              ),
              child: Container(
                height: 38,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                decoration: BoxDecoration(
                  color: value.rateListIndex == index ? kNew9a : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Icon(
                        icons[index],
                        color: value.rateListIndex == index
                            ? Colors.white
                            : Colors.black54,
                      ),
                    ),
                    Expanded(
                      flex: 11,
                      child: Text(
                        buttonNames[index],
                        style: TextStyle(
                            color: value.rateListIndex == index
                                ? Colors.white
                                : Colors.black54,
                            fontSize: 18,
                            fontFamily: 'Iowan',
                            fontWeight: value.rateListIndex == index
                                ? FontWeight.bold
                                : null),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
