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
                horizontal: 22.0,
              ),
              child: Container(
                height: 36,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(
                    top: 4, bottom: 4, left: 25, right: 0),
                decoration: BoxDecoration(
                  color: value.rateListIndex == index ? kNew10 : null,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(
                      icons[index],
                      color: value.rateListIndex == index
                          ? Colors.white
                          : Colors.black54,
                    ),
                    Expanded(
                      child: Center(
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
