import 'package:flutter/material.dart';
import 'package:printing_press/components/round_button.dart';
import 'package:printing_press/views/rate_list/binding/binding_view.dart';
import 'package:printing_press/views/rate_list/design/design_view.dart';
import 'package:printing_press/views/rate_list/machine/machine_view.dart';
import 'package:printing_press/views/rate_list/news_paper/news_paper_view.dart';
import 'package:printing_press/views/rate_list/numbering/numbering_view.dart';
import 'package:printing_press/views/rate_list/paper_cutting/paper_cutting_view.dart';
import 'package:printing_press/views/rate_list/paper/paper_view.dart';
import 'package:printing_press/views/rate_list/profit/profit_view.dart';

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

  List<Widget> screenNames = [
    const BindingView(),
    const DesignView(),
    const MachineView(),
    const NewsPaperView(),
    const NumberingView(),
    const PaperView(),
    const PaperCuttingView(),
    const ProfitView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate List'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: GridView.builder(
          itemCount: buttonNames.length,
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 1.9,
            crossAxisSpacing: 10,
            mainAxisSpacing: 15,
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return RoundButton(
                unFill: true,
                title: buttonNames[index],
                onPress: () => navigateTo(context, screenNames[index]));
          },
        ),
      ),
    );
  }
}
