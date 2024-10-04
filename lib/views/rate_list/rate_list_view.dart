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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate List'),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            RoundButton(
                title: 'Binding',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const BindingView()));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Design',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DesignView()));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Machine',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const MachineView()));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'News Paper',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NewsPaperView()));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Numbering',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const NumberingView()));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Paper',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PaperView()));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Paper Cutting',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const PaperCuttingView()));
                }),
            const SizedBox(
              height: 10,
            ),
            RoundButton(
                title: 'Profit',
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ProfitView()));
                }),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
