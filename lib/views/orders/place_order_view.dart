import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_drop_down.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/text_styles/custom_text_styles.dart';
import 'package:printing_press/utils/toast_message.dart';
import 'package:printing_press/view_model/orders/place_customize_order_view_model.dart';
import 'package:printing_press/views/rate_list/rate_list_view.dart';
import 'package:printing_press/views/stock/add_stock_view.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import '../../components/custom_circular_indicator.dart';
import '../../components/round_button.dart';
import '../../utils/validation_functions.dart';
import '../../view_model/orders/place_stock_order_view_model.dart';

class PlaceOrderView extends StatefulWidget {
  const PlaceOrderView({super.key});

  @override
  State<PlaceOrderView> createState() => _PlaceOrderViewState();
}

class _PlaceOrderViewState extends State<PlaceOrderView> {
  late final PlaceCustomizeOrderViewModel placeCustomizeOrderViewModel;
  late final PlaceStockOrderViewModel placeStockOrderViewModel;

  @override
  void initState() {
    super.initState();

    placeCustomizeOrderViewModel =
        Provider.of<PlaceCustomizeOrderViewModel>(context, listen: false);

    placeStockOrderViewModel =
        Provider.of<PlaceStockOrderViewModel>(context, listen: false);
    getData();
  }

  getData() async {
    await placeCustomizeOrderViewModel.checkData();
    placeStockOrderViewModel.uid =
        placeStockOrderViewModel.auth.currentUser!.uid;
    await placeStockOrderViewModel.getAllStock();
  }

  @override
  void dispose() {
    super.dispose();
    placeStockOrderViewModel.uid;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
                bottom: TabBar(
                    indicatorColor: Colors.white,
                    labelColor: Colors.white,
                    unselectedLabelColor: kNew9a,
                    tabs: [
                      Tab(
                          height: 50,
                          // remove the icons and let's see what happens
                          // icon: Icon(Icons.inventory_2_outlined, size: 20),
                          child:
                              Text('In Stock', style: TextStyle(fontSize: 12))),
                      Tab(
                        height: 50,
                        // icon: Icon(Icons.edit_calendar_outlined, size: 20),
                        child:
                            Text('Customize', style: TextStyle(fontSize: 12)),
                      ),
                    ]),

                ///todo: either business order or customer order
                title: const Text('Customer Order')),
            body: TabBarView(children: [
              Consumer<PlaceStockOrderViewModel>(
                builder: (context, val, child) {
                  return val.inStockOrderDataFetched
                      ? val.allStockList.isEmpty
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                kTitleText('You are out of stock!'),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const AddStockView(),
                                      ),
                                    );
                                  },
                                  child: kTitleText('Add a stock'),
                                ),
                              ],
                            )
                          : Column(children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Form(
                                      key: placeStockOrderViewModel.formKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Consumer<PlaceStockOrderViewModel>(
                                            builder: (context, val1, child) {
                                              return CustomTextField(
                                                controller: val1.customerNameC,
                                                iconData: Icons.person,
                                                hint: 'Customer name',
                                                validators: const [isNotEmpty],
                                              );
                                            },
                                          ),
                                          Consumer<PlaceStockOrderViewModel>(
                                            builder: (context, val2, child) {
                                              return CustomTextField(
                                                controller: val2.businessTitleC,
                                                iconData: Icons.business,
                                                hint: 'Business name',
                                                validators: const [isNotEmpty],
                                              );
                                            },
                                          ),
                                          Consumer<PlaceStockOrderViewModel>(
                                            builder: (context, val3, child) {
                                              return CustomTextField(
                                                maxLength: 11,
                                                textInputType:
                                                    TextInputType.number,
                                                controller:
                                                    val3.customerContactC,
                                                inputFormatter:
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                iconData: Icons.phone,
                                                hint: 'Contact',
                                                validators: const [isNotEmpty],
                                              );
                                            },
                                          ),
                                          Consumer<PlaceStockOrderViewModel>(
                                              builder: (context, val4, child) {
                                            return CustomTextField(
                                              controller: val4.customerAddressC,
                                              iconData: Icons.home_filled,
                                              hint: 'Address',
                                              validators: const [isNotEmpty],
                                            );
                                          }),
                                          SizedBox(height: 10),
                                          Text(
                                            'Select a Stock',
                                            style: kTitle2TextStyle,
                                          ),
                                          Consumer<PlaceStockOrderViewModel>(
                                              builder: (context, val1, child) {
                                            return CustomDropDown(
                                              prefixIconData: Icons.inventory,
                                              validator: null,
                                              list: val1.allStockList,
                                              value: val1.selectedStock,
                                              hint: val1.selectedStock,
                                              onChanged: (newVal) {
                                                val1.changeStockDropDown(
                                                    newVal);
                                              },
                                            );
                                          }),
                                          const SizedBox(height: 10),
                                          Text(
                                            'Stock Details',
                                            style: kTitle2TextStyle,
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Table(
                                                    border: TableBorder(
                                                        horizontalInside:
                                                            BorderSide(
                                                                width: 0.5,
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.5))),
                                                    textBaseline:
                                                        TextBaseline.alphabetic,
                                                    defaultVerticalAlignment:
                                                        TableCellVerticalAlignment
                                                            .baseline,
                                                    columnWidths: {
                                                      0: FractionColumnWidth(
                                                          0.22),
                                                      1: FractionColumnWidth(
                                                          0.2),
                                                      2: FractionColumnWidth(
                                                          0.2),
                                                      3: FractionColumnWidth(
                                                          0.18),
                                                      4: FractionColumnWidth(
                                                          0.2),
                                                    },
                                                    children: [
                                                      TableRow(
                                                        children: [
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(4.0),
                                                              child: kTitleText(
                                                                  'Name',
                                                                  10,
                                                                  Colors.black
                                                                      .withOpacity(
                                                                          0.6),
                                                                  2)),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: kTitleText(
                                                                'Category',
                                                                10,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.6),
                                                                2),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: kTitleText(
                                                                'Color',
                                                                10,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.6),
                                                                2),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: kTitleText(
                                                                'Available',
                                                                10,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.6),
                                                                2),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: kTitleText(
                                                                'Price',
                                                                10,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.6),
                                                                2),
                                                          ),
                                                        ],
                                                      ),
                                                      TableRow(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4.0),
                                                            child: kTitleText(
                                                                val
                                                                    .stockList[val
                                                                        .selectedStockIndex]
                                                                    .stockName,
                                                                12,
                                                                null,
                                                                2),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: kTitleText(
                                                                val
                                                                    .stockList[val
                                                                        .selectedStockIndex]
                                                                    .stockCategory,
                                                                12,
                                                                null,
                                                                2),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: kTitleText(
                                                                val
                                                                    .stockList[val
                                                                        .selectedStockIndex]
                                                                    .stockColor,
                                                                12,
                                                                null,
                                                                2),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: kTitleText(
                                                                val
                                                                    .stockList[val
                                                                        .selectedStockIndex]
                                                                    .availableStock
                                                                    .toString(),
                                                                12,
                                                                kNew4,
                                                                2),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    4.0),
                                                            child: kTitleText(
                                                                val
                                                                    .stockList[val
                                                                        .selectedStockIndex]
                                                                    .stockUnitSellPrice
                                                                    .toString(),
                                                                12,
                                                                kNew8,
                                                                2),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 10),
                                          CustomTextField(
                                              controller: val.stockQuantityC,
                                              iconData: Icons.numbers_outlined,
                                              inputFormatter:
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                              textInputType:
                                                  TextInputType.number,
                                              hint: 'Quantity',
                                              validators: [
                                                isNotEmpty,
                                                isNotZero,
                                                (value) => lessThan(
                                                    value,
                                                    val
                                                        .stockList[val
                                                            .selectedStockIndex]
                                                        .stockQuantity)
                                              ]),
                                          const SizedBox(height: 10),
                                          Consumer<PlaceStockOrderViewModel>(
                                              builder: (context, val5, child) {
                                            return CustomTextField(
                                                controller:
                                                    val5.advancePaymentC,
                                                iconData: Icons
                                                    .monetization_on_rounded,
                                                inputFormatter:
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                textInputType:
                                                    TextInputType.number,
                                                hint: 'Advance payment',
                                                validators: [
                                                  (value) => lessThan(
                                                      value, val5.totalAmount)
                                                ]);
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: RoundButton(
                                      title: 'Place Order',
                                      loading: val.loading,
                                      onPress: () =>
                                          val.addCustomerOrderDataInFirebase(
                                              context)))
                            ])
                      : const CustomCircularIndicator();
                },
              ),
              Consumer<PlaceCustomizeOrderViewModel>(
                  builder: (context, val, child) {
                return val.customOrderDataFetched
                    ? val.dataFound
                        ? Column(children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Form(
                                    key: placeCustomizeOrderViewModel.formKey,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val1, child) {
                                              return CustomTextField(
                                                  controller:
                                                      val1.customerNameC,
                                                  iconData: Icons.person,
                                                  hint: 'Customer name',
                                                  validators: const [
                                                    isNotEmpty
                                                  ]);
                                            },
                                          ),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val2, child) {
                                              return CustomTextField(
                                                  controller:
                                                      val2.businessTitleC,
                                                  iconData: Icons.business,
                                                  hint: 'Business name',
                                                  validators: const [
                                                    isNotEmpty
                                                  ]);
                                            },
                                          ),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val3, child) {
                                              return CustomTextField(
                                                  maxLength: 11,
                                                  textInputType:
                                                      TextInputType.number,
                                                  controller:
                                                      val3.customerContactC,
                                                  inputFormatter:
                                                      FilteringTextInputFormatter
                                                          .digitsOnly,
                                                  iconData: Icons.phone,
                                                  hint: 'Contact',
                                                  validators: const [
                                                    isNotEmpty
                                                  ]);
                                            },
                                          ),
                                          Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                              builder: (context, val4, child) {
                                            return CustomTextField(
                                                controller:
                                                    val4.customerAddressC,
                                                iconData: Icons.home_filled,
                                                hint: 'Address',
                                                validators: const [isNotEmpty]);
                                          }),
                                          const SizedBox(height: 10),
                                          Text('Design',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val1, child) =>
                                                CustomDropDown(
                                                    prefixIconData: Icons
                                                        .design_services_rounded,
                                                    validator: null,
                                                    list: val1.designNames,
                                                    value: val1.selectedDesign,
                                                    hint: val1.selectedDesign,
                                                    onChanged: (newVal) {
                                                      if (newVal != null) {
                                                        val1.selectedDesign =
                                                            newVal;
                                                        val1.selectedDesignIndex =
                                                            val1.designNames
                                                                .indexOf(val1
                                                                    .selectedDesign);
                                                        if (newVal == 'none') {
                                                          debugPrint(
                                                              "No design");
                                                        } else {
                                                          debugPrint(
                                                              'Design Rate: ${val1.designs[val1.selectedDesignIndex - 1].rate}');
                                                        }
                                                      }
                                                    }),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Paper Size',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val2, child) =>
                                                CustomDropDown(
                                              prefixIconData:
                                                  Icons.tune_rounded,
                                              validator: null,
                                              list: val2.paperSizes,
                                              value: val2.selectedPaperSize,
                                              hint: val2.selectedPaperSize,
                                              onChanged: (newVal) {
                                                val2.selectedPaperSize =
                                                    newVal!;
                                                val2.selectedPaperSizePaperQualities =
                                                    [];
                                                val2.selectedPaperSizeIndexes =
                                                    [];
                                                // change the next dropdown according to the selected paper size

                                                // if (val2.selectedPaperSize ==
                                                //     'none') {
                                                //   val2.selectedPaperSizePaperQualities
                                                //       .add('none');
                                                //
                                                //   val2.selectedPaperQuality =
                                                //       val2.selectedPaperSizePaperQualities[
                                                //           0];
                                                //   debugPrint(
                                                //       'Selected Paper Quality: ${val2.selectedPaperQuality}');
                                                //   val2.updateListener();
                                                // } else {
                                                int index = 0;
                                                for (var paper in val2.papers) {
                                                  debugPrint(
                                                      '\n selected Paper size : ${val2.selectedPaperSize}');
                                                  debugPrint(
                                                      'checking the paper size in firebase: ${paper.size.width} x ${paper.size.height}');
                                                  if (val2.selectedPaperSize ==
                                                          '${paper.size.width} x ${paper.size.height}' ||
                                                      val2.selectedPaperSize ==
                                                          '${paper.size.height} x ${paper.size.width}') {
                                                    val2.selectedPaperSizePaperQualities
                                                        .add(
                                                            '${paper.quality}');
                                                    val2.selectedPaperSizeIndexes
                                                        .add(index);
                                                    debugPrint(
                                                        'paper quality added of index $index');
                                                  }
                                                  index++;
                                                  // }

                                                  debugPrint(
                                                      'Paper size indexes : ${val2.selectedPaperSizeIndexes}');
                                                  debugPrint(
                                                      'Paper Qualities: ${val2.selectedPaperSizePaperQualities}');
                                                  val2.selectedPaperQuality =
                                                      val2.selectedPaperSizePaperQualities[
                                                          0];
                                                  debugPrint(
                                                      'Selected Paper Quality: ${val2.selectedPaperQuality}');

                                                  // rate of the selected paper size, selected paper quality
                                                  int rate = val2
                                                      .papers[val2.selectedPaperSizeIndexes[val2
                                                          .selectedPaperSizePaperQualities
                                                          .indexOf(val2
                                                              .selectedPaperQuality)]]
                                                      .rate;
                                                  debugPrint(
                                                      'Rate of the selected paper quality is : $rate');
                                                }
                                                val2.updateListener();
                                              },
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Paper Quality',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val3, child) =>
                                                CustomDropDown(
                                                    prefixIconData: Icons.label,
                                                    validator: null,
                                                    list: val3
                                                        .selectedPaperSizePaperQualities,
                                                    value: val3
                                                        .selectedPaperQuality,
                                                    hint: val3
                                                        .selectedPaperQuality,
                                                    onChanged: (newVal) {
                                                      val3.selectedPaperQuality =
                                                          newVal!;

                                                      debugPrint(
                                                          '\n\n\nSelected Paper size... : ${val3.selectedPaperSize}');
                                                      debugPrint(
                                                          'All Paper Qualities... : ${val3.selectedPaperSizePaperQualities}');
                                                      debugPrint(
                                                          'Selected Paper quality... : ${val3.selectedPaperQuality}');
                                                      debugPrint(
                                                          'All selected Paper size indexes... : ${val3.selectedPaperSizeIndexes}\n\n\n');

                                                      // if (val3.selectedPaperQuality !=
                                                      // 'none') {
                                                      // rate of the selected paper size, selected paper quality
                                                      int rate = val3
                                                          .papers[val3.selectedPaperSizeIndexes[val3
                                                              .selectedPaperSizePaperQualities
                                                              .indexOf(val3
                                                                  .selectedPaperQuality)]]
                                                          .rate;
                                                      debugPrint(
                                                          'Rate of the selected paper quality is : $rate');
                                                      // }
                                                    }),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Paper Cutting',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val5, child) =>
                                                CustomDropDown(
                                                    prefixIconData: Icons.cut,
                                                    validator: null,
                                                    list:
                                                        val5.paperCuttingNames,
                                                    value: val5
                                                        .selectedPaperCutting,
                                                    hint: val5
                                                        .selectedPaperCutting,
                                                    onChanged: (newVal) {
                                                      val5.selectedPaperCutting =
                                                          newVal!;
                                                      val5.selectedPaperCuttingIndex =
                                                          val5.paperCuttingNames
                                                              .indexOf(val5
                                                                  .selectedPaperCutting);

                                                      if (newVal == 'none') {
                                                        debugPrint(
                                                            "No paper cutting");
                                                      } else {
                                                        debugPrint(
                                                            'Paper cutting Rate: ${val5.paperCuttings[val5.selectedPaperCuttingIndex - 1].rate}');
                                                      }
                                                    }),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Cutting Unit',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                              builder: (context, val6, child) {
                                            return CustomDropDown(
                                                prefixIconData:
                                                    Icons.build_outlined,
                                                validator: null,
                                                list:
                                                    val6.basicCuttingUnitsList,
                                                value: val6
                                                    .selectedBasicCuttingUnit,
                                                hint: val6
                                                    .selectedBasicCuttingUnit,
                                                onChanged: (newVal) {
                                                  val6.selectedBasicCuttingUnit =
                                                      newVal!;
                                                  debugPrint(
                                                      'New value is $newVal');
                                                  // if (val6.selectedBasicCuttingUnit ==
                                                  //     'none') {
                                                  //   val6.selectedBasicCuttingUnitIndex =
                                                  //       0;
                                                  //   debugPrint(
                                                  //       'No cutting unit');
                                                  // } else {
                                                  val6.selectedBasicCuttingUnitIndex =
                                                      val6.basicCuttingUnitsList
                                                          .indexOf(newVal);

                                                  int? cuttingUnit =
                                                      int.tryParse(val6
                                                          .selectedBasicCuttingUnit
                                                          .substring(2));

                                                  debugPrint(
                                                      "Selected basic cutting unit: $cuttingUnit");
                                                  debugPrint(
                                                      "Selected basic cutting unit (int): ${val6.basicCuttingUnits[val6.selectedBasicCuttingUnitIndex]}");

                                                  // }

                                                  debugPrint(
                                                      'Index of basic paper cutting is ${val6.selectedBasicCuttingUnitIndex}');
                                                });
                                          }),
                                          const SizedBox(height: 10),
                                          Text('Binding',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val9, child) =>
                                                CustomDropDown(
                                                    prefixIconData:
                                                        Icons.my_library_books,
                                                    validator: null,
                                                    list: val9.bindingNames,
                                                    value: val9.selectedBinding,
                                                    hint: val9.selectedBinding,
                                                    onChanged: (newVal) {
                                                      val9.selectedBinding =
                                                          newVal!;
                                                      val9.selectedBindingIndex =
                                                          val9.bindingNames
                                                              .indexOf(val9
                                                                  .selectedBinding);
                                                    }),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Numbering',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val11, child) =>
                                                CustomDropDown(
                                                    prefixIconData: Icons
                                                        .format_list_numbered_outlined,
                                                    validator: null,
                                                    list: val11.numberingNames,
                                                    value:
                                                        val11.selectedNumbering,
                                                    hint:
                                                        val11.selectedNumbering,
                                                    onChanged: (newVal) {
                                                      val11.selectedNumbering =
                                                          newVal!;
                                                      val11.selectedNumberingIndex =
                                                          val11.numberingNames
                                                              .indexOf(val11
                                                                  .selectedNumbering);
                                                    }),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Print Type',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val12, child) =>
                                                CustomDropDown(
                                                    prefixIconData: Icons
                                                        .local_printshop_outlined,
                                                    validator: (value) {
                                                      if (val12.selectedCopyVariant ==
                                                              'carbon-less' &&
                                                          value != '1C') {
                                                        return 'Select 1 Color';
                                                      }
                                                      return null;
                                                    },
                                                    list: val12.printNames,
                                                    value: val12.selectedPrint,
                                                    hint: val12.selectedPrint,
                                                    onChanged: (newVal) {
                                                      val12.selectedPrint =
                                                          newVal!;
                                                      debugPrint(
                                                          'Print: ${int.tryParse(val12.selectedPrint.substring(0, 1))}');
                                                    }),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Backside Print Type',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val13, child) =>
                                                CustomDropDown(
                                                    prefixIconData: Icons
                                                        .flip_to_back_rounded,
                                                    validator: (value) {
                                                      if (val13.selectedCopyVariant ==
                                                              'carbon-less' &&
                                                          value != 'none') {
                                                        return 'Carbon-less can\'t have backside.';
                                                      }
                                                      return null;
                                                    },
                                                    list: val13
                                                        .backSidePrintingList,
                                                    value:
                                                        val13.selectedBackSide,
                                                    hint:
                                                        val13.selectedBackSide,
                                                    onChanged: (newVal) {
                                                      val13.selectedBackSide =
                                                          newVal!;
                                                      debugPrint(
                                                          'Back side Print: ${int.tryParse(val13.selectedBackSide.substring(0, 1)) ?? val13.selectedBackSide}');
                                                    }),
                                          ),
                                          const SizedBox(height: 10),
                                          Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                              builder: (context, val4, child) =>
                                                  CustomTextField(
                                                      controller:
                                                          val4.booksQuantityC,
                                                      iconData: null,
                                                      inputFormatter:
                                                          FilteringTextInputFormatter
                                                              .digitsOnly,
                                                      textInputType: TextInputType.number,
                                                      hint: 'Books Quantity',
                                                      validators: const [
                                                        isNotEmpty,
                                                        isNotZero
                                                      ])),
                                          const SizedBox(height: 10),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val0, child) =>
                                                CustomTextField(
                                                    controller:
                                                        val0.pagesPerBookC,
                                                    iconData: null,
                                                    inputFormatter:
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                    textInputType:
                                                        TextInputType.number,
                                                    hint: 'Pages per book',
                                                    validators: [
                                                  isNotEmpty,
                                                  (value) =>
                                                      moreThan(value, 10),
                                                ]),
                                          ),
                                          const SizedBox(height: 10),
                                          Text('Copy Variants',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val7, child) =>
                                                CustomDropDown(
                                                    prefixIconData:
                                                        Icons.copy_all_outlined,
                                                    validator: null
                                                    //     (value) {
                                                    //   if (value ==
                                                    //           'carbon-less' &&
                                                    //       val7.selectedPrint !=
                                                    //           '1C') {
                                                    //     return 'Carbon-less can\'t be printed more than once';
                                                    //   }
                                                    //   return null;
                                                    // }
                                                    ,
                                                    list: val7.copyVariantNames,
                                                    value: val7
                                                        .selectedCopyVariant,
                                                    hint: val7
                                                        .selectedCopyVariant,
                                                    onChanged: (newVal) {
                                                      val7.selectedCopyVariant =
                                                          newVal!;
                                                      val7.selectedCopyVariantIndex =
                                                          val7.copyVariantNames
                                                              .indexOf(val7
                                                                  .selectedCopyVariant);
                                                      val7.updateListener();
                                                    }),
                                          ),
                                          Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                              builder: (context, val8, child) {
                                            if (val.selectedCopyVariant ==
                                                'none') {
                                              return const SizedBox.shrink();
                                            } else if (val
                                                    .selectedCopyVariant ==
                                                'news') {
                                              return Column(children: [
                                                const SizedBox(height: 10),
                                                Text('News Paper Size',
                                                    style: kTitle2TextStyle),
                                                Consumer<
                                                    PlaceCustomizeOrderViewModel>(
                                                  builder:
                                                      (context, val9, child) =>
                                                          CustomDropDown(
                                                    prefixIconData:
                                                        Icons.tune_rounded,
                                                    validator: (value) {
                                                      if (val9.selectedCopyVariant ==
                                                              'news' &&
                                                          value !=
                                                              val9.selectedPaperSize) {
                                                        Utils.showMessage(
                                                            'Select compatible news paper!');
                                                        return 'Incompatible news size';
                                                      }
                                                      return null;
                                                    },
                                                    list: val9.newsPaperSizes,
                                                    value: val9
                                                        .selectedNewsPaperSize,
                                                    hint: val9
                                                        .selectedNewsPaperSize,
                                                    onChanged: (newVal) {
                                                      val9.selectedNewsPaperSize =
                                                          newVal!;
                                                      val9.selectedNewsPaperSizePaperQualities
                                                          .clear();
                                                      val9.selectedNewsPaperSizeIndexes
                                                          .clear();
                                                      // change the next dropdown according to the selected news paper size

                                                      if (newVal == 'none') {
                                                        val9.selectedNewsPaperSizePaperQualities
                                                            .add('none');

                                                        val9.selectedNewsPaperQuality =
                                                            val9.selectedNewsPaperSizePaperQualities[
                                                                0];
                                                        debugPrint(
                                                            'Selected News Paper Quality: ${val9.selectedNewsPaperQuality}');
                                                      } else {
                                                        int index = 0;
                                                        for (var news in val9
                                                            .newsPapers) {
                                                          // debugPrint(
                                                          //     '\n selected news Paper size : $selectedNewsPaperSize');
                                                          // debugPrint(
                                                          //     'checking the news paper size in firebase: ${news.size.width} x ${news.size.height}');
                                                          if (newVal ==
                                                                  '${news.size.width} x ${news.size.height}' ||
                                                              newVal ==
                                                                  '${news.size.height} x ${news.size.width}') {
                                                            val9.selectedNewsPaperSizePaperQualities
                                                                .add(
                                                                    '${news.quality}');
                                                            val9.selectedNewsPaperSizeIndexes
                                                                .add(index);
                                                            debugPrint(
                                                                'news paper quality added of index $index');
                                                          }
                                                          index++;
                                                        }

                                                        debugPrint(
                                                            'News Paper size indexes : ${val9.selectedNewsPaperSizeIndexes}');
                                                        debugPrint(
                                                            'News Paper Qualities: ${val9.selectedNewsPaperSizePaperQualities}');
                                                        val9.selectedNewsPaperQuality =
                                                            val9.selectedNewsPaperSizePaperQualities[
                                                                0];
                                                        debugPrint(
                                                            'Selected News Paper Quality: ${val9.selectedNewsPaperQuality}');

                                                        // rate of the selected News paper size, selected News paper quality
                                                        int rate = val9
                                                            .newsPapers[val9
                                                                    .selectedNewsPaperSizeIndexes[
                                                                val9.selectedNewsPaperSizePaperQualities
                                                                    .indexOf(val9
                                                                        .selectedNewsPaperQuality)]]
                                                            .rate;
                                                        debugPrint(
                                                            'Rate of the selected news paper quality is : $rate');
                                                      }
                                                      val9.updateListener();
                                                    },
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Text('News Paper Quality',
                                                    style: kTitle2TextStyle),
                                                Consumer<
                                                    PlaceCustomizeOrderViewModel>(
                                                  builder:
                                                      (context, val10, child) =>
                                                          CustomDropDown(
                                                    prefixIconData: Icons.label,
                                                    validator: null,
                                                    list: val10
                                                        .selectedNewsPaperSizePaperQualities,
                                                    value: val10
                                                        .selectedNewsPaperQuality,
                                                    hint: val10
                                                        .selectedNewsPaperQuality,
                                                    onChanged: (newVal) {
                                                      val10.selectedNewsPaperQuality =
                                                          newVal!;

                                                      debugPrint(
                                                          '\n\n\nSelected News Paper size... : ${val10.selectedNewsPaperSize}');
                                                      debugPrint(
                                                          'All News Paper Qualities... : ${val10.selectedNewsPaperSizePaperQualities}');
                                                      debugPrint(
                                                          'Selected News Paper quality... : ${val10.selectedNewsPaperQuality}');
                                                      debugPrint(
                                                          'All selected News Paper size indexes... : ${val10.selectedNewsPaperSizeIndexes}\n\n\n');

                                                      if (val10
                                                              .selectedNewsPaperQuality !=
                                                          'none') {
                                                        // rate of the selected News paper size, selected News paper quality
                                                        int rate = val10
                                                            .newsPapers[val10
                                                                    .selectedNewsPaperSizeIndexes[
                                                                val10
                                                                    .selectedNewsPaperSizePaperQualities
                                                                    .indexOf(val10
                                                                        .selectedNewsPaperQuality)]]
                                                            .rate;
                                                        debugPrint(
                                                            'Rate of the selected News paper quality is : $rate');
                                                      }
                                                    },
                                                  ),
                                                ),
                                              ]);
                                            } else if (val
                                                    .selectedCopyVariant ==
                                                'carbon') {
                                              return Column(
                                                children: [
                                                  const SizedBox(height: 10),
                                                  Text('Copy Variant Quality',
                                                      style: kTitle2TextStyle),
                                                  Consumer<
                                                      PlaceCustomizeOrderViewModel>(
                                                    builder: (context, val3,
                                                            child) =>
                                                        CustomDropDown(
                                                            prefixIconData:
                                                                Icons.label,
                                                            validator: null,
                                                            list: val3
                                                                .selectedPaperSizePaperQualities,
                                                            value: val3
                                                                .selectedCopyVariantPaperQuality,
                                                            hint: val3
                                                                .selectedCopyVariantPaperQuality,
                                                            onChanged:
                                                                (newVal) {
                                                              val3.selectedCopyVariantPaperQuality =
                                                                  newVal!;

                                                              debugPrint(
                                                                  '\n\n\nSelected Paper size... : ${val3.selectedPaperSize}');
                                                              debugPrint(
                                                                  'All Paper Qualities... : ${val3.selectedPaperSizePaperQualities}');
                                                              debugPrint(
                                                                  'Selected variant Paper quality... : ${val3.selectedCopyVariantPaperQuality}');
                                                              debugPrint(
                                                                  'All selected Paper size indexes... : ${val3.selectedPaperSizeIndexes}\n\n\n');

                                                              // if (val3.selectedPaperQuality !=
                                                              // 'none') {
                                                              // rate of the selected paper size, selected paper quality
                                                              int rate = val3
                                                                  .papers[val3.selectedPaperSizeIndexes[val3
                                                                      .selectedPaperSizePaperQualities
                                                                      .indexOf(val3
                                                                          .selectedCopyVariantPaperQuality)]]
                                                                  .rate;
                                                              debugPrint(
                                                                  'Rate of the selected paper variant quality is : $rate');
                                                              // }
                                                            }),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  Text(
                                                      'Copy Variant Print Type',
                                                      style: kTitle2TextStyle),
                                                  Consumer<
                                                      PlaceCustomizeOrderViewModel>(
                                                    builder: (context, val12,
                                                            child) =>
                                                        CustomDropDown(
                                                            prefixIconData: Icons
                                                                .color_lens_outlined,
                                                            validator: null,
                                                            list: val12
                                                                .printNames,
                                                            value: val12
                                                                .selectedVariantPrint,
                                                            hint: val12
                                                                .selectedVariantPrint,
                                                            onChanged:
                                                                (newVal) {
                                                              val12.selectedVariantPrint =
                                                                  newVal!;
                                                              debugPrint(
                                                                  'Variant Print: ${int.tryParse(val12.selectedVariantPrint.substring(0, 1))}');
                                                            }),
                                                  ),
                                                ],
                                              );
                                            } else {
                                              /// it means carbon-less
                                              return Column(children: [
                                                const SizedBox(height: 10),
                                                Text('Copy Variant Type',
                                                    style: kTitle2TextStyle),
                                                Consumer<
                                                        PlaceCustomizeOrderViewModel>(
                                                    builder: (context, val12,
                                                            child) =>
                                                        CustomDropDown(
                                                            prefixIconData: Icons
                                                                .content_copy_outlined,
                                                            validator: null,
                                                            list: val12
                                                                .carbonLessVariantTypeNames,
                                                            value: val12
                                                                .selectedCarbonLessVariantType,
                                                            hint: val12
                                                                .selectedCarbonLessVariantType,
                                                            onChanged:
                                                                (newVal) {
                                                              val12.selectedCarbonLessVariantType =
                                                                  newVal!;
                                                              switch (newVal) {
                                                                case 'dup':
                                                                  val12.noOfSelectedCarbonLessVariant =
                                                                      2;
                                                                  break;
                                                                case 'trip':
                                                                  val12.noOfSelectedCarbonLessVariant =
                                                                      3;
                                                                  break;
                                                                case 'quad':
                                                                  val12.noOfSelectedCarbonLessVariant =
                                                                      4;
                                                                  break;
                                                              }
                                                            }))
                                              ]);
                                            }
                                          }),
                                          const SizedBox(height: 10),
                                          Text('Profit',
                                              style: kTitle2TextStyle),
                                          Consumer<
                                              PlaceCustomizeOrderViewModel>(
                                            builder: (context, val14, child) =>
                                                CustomDropDown(
                                                    prefixIconData: Icons
                                                        .trending_up_rounded,
                                                    validator: null,
                                                    list: val14.profitNames,
                                                    value: val14.selectedProfit,
                                                    hint: val14.selectedProfit,
                                                    onChanged: (newVal) {
                                                      val14.selectedProfit =
                                                          newVal!;
                                                      val14.selectedProfitIndex =
                                                          val14.profitNames
                                                              .indexOf(val14
                                                                  .selectedProfit);
                                                    }),
                                          ),
                                          SizedBox(height: 4),
                                          Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                              builder: (context, val15,
                                                      child) =>
                                                  CustomTextField(
                                                    controller:
                                                        val15.otherExpensesC,
                                                    inputFormatter:
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                    iconData: null,
                                                    textInputType:
                                                        TextInputType.number,
                                                    hint:
                                                        'Other Expenses (if any)',
                                                    validators: null,
                                                  )),
                                          Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                              builder: (context, val15,
                                                      child) =>
                                                  CustomTextField(
                                                    controller:
                                                        val15.advancePaymentC,
                                                    inputFormatter:
                                                        FilteringTextInputFormatter
                                                            .digitsOnly,
                                                    iconData: null,
                                                    textInputType:
                                                        TextInputType.number,
                                                    hint: 'Advance Payment',
                                                    validators: const [
                                                      isNotEmpty,

                                                      /// todo: calculate the total amount and then let the user know so that the advance amount is not more than the total amount
                                                    ],
                                                  ))
                                        ]),
                                  ),
                                ),
                              ),
                            ),

                            /// todo:
                            // Row(
                            //   children: [
                            //     Expanded(
                            //         child: TextButton(
                            //             onPressed: () {},
                            //             child: const Text(
                            //               'Calculate',
                            //               style: TextStyle(fontSize: 18),
                            //             ))),
                            //     const Expanded(
                            //         child: Center(child: Text('000'))),
                            //   ],
                            // ),
                            const SizedBox(height: 10),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: RoundButton(
                                    loading: val.loading,
                                    title: 'Place Order',
                                    onPress: () => val.calculateRate()))
                          ])
                        : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                      'You must have at least one rate of each service'),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const RateListView()));
                                      },
                                      child: const Text('Add service rate'))
                                ]))
                    : const CustomCircularIndicator();
              })
            ])));
  }
}
// Row(
//   children: [
//     const Text('Copy Printing'),
//     CustomDropDown(
//         list: val8.copyPrint,
//         value: val8
//             .selectedCopyPrint,
//         hint: val8
//             .selectedCopyPrint,
//         onChanged: (newVal) {
//           val8.selectedCopyPrint =
//               newVal!;
//           val8.selectedCopyPrintIndex =
//               val8.copyPrint
//                   .indexOf(val8
//                       .selectedCopyPrint);
//         }),
//   ],
// ),

///
// Consumer<PlaceOrderViewModel>(
//   builder: (context, val7, child) => Column(
//     children: [
//       CustomRadioListTile(
//         title: 'News',
//           value: 0,
//           groupValue: val7.selectedValue,
//           onChanged: (value) =>
//               val7.onChanged(0)),
//       CustomRadioListTile(
//           title: 'None',
//           value: 1,
//           groupValue: val7.selectedValue,
//           onChanged: (value) =>
//               val7.onChanged(1)),
//       CustomRadioListTile(
//         title: 'Duplicate',
//           value: 2,
//           groupValue: val7.selectedValue,
//           onChanged: (value) =>
//               val7.onChanged(2)),
//       CustomRadioListTile(
//           title: 'Triplicate',
//           value: 3,
//           groupValue: val7.selectedValue,
//           onChanged: (value) =>
//               val7.onChanged(3)),
//     ],
//   ),
// ),

// const Spacer(),
