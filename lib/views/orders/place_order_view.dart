import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_drop_down.dart';
import 'package:printing_press/components/custom_text_field.dart';
import 'package:printing_press/utils/toast_message.dart';
import 'package:printing_press/view_model/orders/place_customize_order_view_model.dart';
import 'package:printing_press/views/rate_list/rate_list_view.dart';
import 'package:printing_press/views/stock/add_stock_view.dart';
import 'package:provider/provider.dart';

import '../../colors/color_palette.dart';
import '../../components/round_button.dart';
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
    placeCustomizeOrderViewModel.checkData();

    placeStockOrderViewModel =
        Provider.of<PlaceStockOrderViewModel>(context, listen: false);
    placeStockOrderViewModel.uid =
        placeStockOrderViewModel.auth.currentUser!.uid;
    placeStockOrderViewModel.getAllStock();
  }

  @override
  void dispose() {
    // TODO: implement dispose
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
              indicatorColor: kFourthColor,
              labelColor: kFourthColor,
              unselectedLabelColor: kSecColor,
              tabs: const [
                Tab(
                  text: 'In Stock',
                  icon: Icon(
                    Icons.inventory_2_outlined,
                  ),
                ),
                Tab(
                  text: 'Customize',
                  icon: Icon(
                    Icons.edit_calendar_outlined,
                  ),
                ),
              ]),
          title: const Text('Business Order'),
        ),
        body: TabBarView(children: [
          Consumer<PlaceStockOrderViewModel>(
            builder: (context, value, child) {
              return value.inStockOrderDataFetched
                  ? value.allStockList.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('You are out of stock!\n'),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const AddStockView(),
                                  ),
                                );
                              },
                              child: const Text('Add a stock'),
                            ),
                          ],
                        )
                      : Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: placeStockOrderViewModel.formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        children: [
                                          // customerName
                                          /// text field
                                          Consumer<PlaceStockOrderViewModel>(
                                            builder: (context, val1, child) {
                                              return CustomTextField(
                                                  controller:
                                                      val1.customerNameC,
                                                  iconData: Icons.person,
                                                  hint: 'Customer name',
                                                  validatorText:
                                                      'Provide customer name');
                                            },
                                          ),

                                          // businessTitle
                                          /// text field
                                          Consumer<PlaceStockOrderViewModel>(
                                            builder: (context, val2, child) {
                                              return CustomTextField(
                                                  controller:
                                                      val2.businessTitleC,
                                                  iconData: Icons.business,
                                                  hint: 'Business name',
                                                  validatorText:
                                                      'Provide business name');
                                            },
                                          ),

                                          // customerContact
                                          /// text field number only
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
                                                  validatorText:
                                                      'Provide customer phone no.');
                                            },
                                          ),

                                          // customerAddress
                                          /// text field
                                          Consumer<PlaceStockOrderViewModel>(
                                              builder: (context, val4, child) {
                                            return CustomTextField(
                                                controller:
                                                    val4.customerAddressC,
                                                iconData: Icons.home_filled,
                                                hint: 'Address',
                                                validatorText:
                                                    'Provide customer address');
                                          }),

                                          // orderDateTime
                                          /// auto
                                          // orderDueDateTime,
                                          /// null here
                                          // orderStatus
                                          /// first pending
                                          // orderId
                                          /// auto generated
                                          // stockId
                                          /// auto
                                          // stockName
                                          /// auto
                                          // stockCategory
                                          /// auto
                                          // stockUnitSellPrice
                                          /// auto
                                          // stockQuantity
                                          /// text field number only

                                          Row(
                                            children: [
                                              const Expanded(
                                                flex: 1,
                                                child: Center(
                                                  child: Text(
                                                    'Stock',
                                                  ),
                                                ),
                                              ),
                                              Consumer<
                                                      PlaceStockOrderViewModel>(
                                                  builder:
                                                      (context, val1, child) {
                                                return Expanded(
                                                  flex: 2,
                                                  child: CustomDropDown(
                                                    validator: null,
                                                    list: val1.allStockList,
                                                    value: val1.selectedStock,
                                                    hint: val1.selectedStock,
                                                    onChanged: (newVal) {
                                                      val1.changeStockDropDown(
                                                          newVal);
                                                    },
                                                  ),
                                                );
                                              }),
                                            ],
                                          ),
                                          // const SizedBox(height: 100,),

                                          Column(
                                            children: [
                                              const Text('Stock Details'),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                      flex: 1,
                                                      child:
                                                          Text('Stock Id: ')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(value
                                                          .stockList[value
                                                              .selectedStockIndex]
                                                          .stockId
                                                          .toString())),
                                                  const Expanded(
                                                      flex: 2,
                                                      child: Text('Name: ')),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(value
                                                          .stockList[value
                                                              .selectedStockIndex]
                                                          .stockName)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                      flex: 1,
                                                      child: Text('Color: ')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(value
                                                          .stockList[value
                                                              .selectedStockIndex]
                                                          .stockColor)),
                                                  const Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                          'Manufactured By: ')),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(value
                                                          .stockList[value
                                                              .selectedStockIndex]
                                                          .manufacturedBy)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                      flex: 1,
                                                      child:
                                                          Text('Category: ')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(value
                                                          .stockList[value
                                                              .selectedStockIndex]
                                                          .stockCategory)),
                                                  const Expanded(
                                                      flex: 2,
                                                      child:
                                                          Text('Available: ')),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(value
                                                          .stockList[value
                                                              .selectedStockIndex]
                                                          .availableStock
                                                          .toString())),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          'Description: ')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(value
                                                          .stockList[value
                                                              .selectedStockIndex]
                                                          .stockDescription)),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Expanded(
                                                      flex: 1,
                                                      child: Text('Price: ')),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: Text(value
                                                          .stockList[value
                                                              .selectedStockIndex]
                                                          .stockUnitSellPrice
                                                          .toString())),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              const Expanded(
                                                  flex: 1,
                                                  child: Text('Quantity')),
                                              Expanded(
                                                flex: 2,

                                                ///todo: add plus icon and minus icon for ease
                                                child: TextFormField(
                                                  controller:
                                                      value.stockQuantityC,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: kPrimeColor,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  decoration: InputDecoration(
                                                    prefixIcon: const Icon(
                                                      Icons.filter_none_rounded,
                                                      size: 24,
                                                    ),
                                                    hintText: 'Quantity',
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      borderSide: BorderSide(
                                                        width: 2,
                                                        color: kPrimeColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      borderSide: BorderSide(
                                                        color: kSecColor,
                                                      ),
                                                    ),
                                                  ),
                                                  validator: (text) {
                                                    if (text == '' ||
                                                        text == null) {
                                                      return 'Provide stock quantity';
                                                    } else if (int.tryParse(
                                                            value.stockQuantityC
                                                                .text)! >
                                                        value
                                                            .stockList[value
                                                                .selectedStockIndex]
                                                            .stockQuantity) {
                                                      return 'Out of stock';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),

                                          // totalAmount
                                          /// text auto generated through calculations

                                          // advancePayment
                                          /// text field number only
                                          Consumer<PlaceStockOrderViewModel>(
                                              builder: (context, val5, child) {
                                            return TextFormField(
                                              controller: val5.advancePaymentC,
                                              keyboardType:
                                                  TextInputType.number,
                                              cursorColor: kPrimeColor,
                                              inputFormatters: <TextInputFormatter>[
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              decoration: InputDecoration(
                                                prefixIcon: const Icon(
                                                  Icons.monetization_on_rounded,
                                                  size: 24,
                                                ),
                                                hintText: 'Advance payment',
                                                filled: true,
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  borderSide: BorderSide(
                                                    width: 2,
                                                    color: kPrimeColor,
                                                  ),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide(
                                                    color: kSecColor,
                                                  ),
                                                ),
                                              ),
                                              validator: (text) {
                                                if (text == '' ||
                                                    text == null) {
                                                  return 'Provide advance payment';
                                                } else if (val5.stockQuantity ==
                                                    0) {
                                                  return 'Enter stock quantity (at least 1)';
                                                } else if (int.tryParse(val5
                                                        .advancePaymentC.text
                                                        .trim())! >
                                                    val5.totalAmount) {
                                                  return 'Please enter below \$${val5.totalAmount}';
                                                }
                                                return null;
                                              },
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            RoundButton(
                              title: 'Place Order',
                              loading: value.loading,
                              onPress: () {
                                value.addCustomerOrderDataInFirebase(context);
                              },
                            ),
                          ],
                        )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
          Consumer<PlaceCustomizeOrderViewModel>(
            builder: (context, val, child) {
              return val.customOrderDataFetched
                  ? val.dataFound
                      ? Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    key: placeCustomizeOrderViewModel.formKey,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(children: [
                                        // customerName
                                        /// text field
                                        Consumer<PlaceCustomizeOrderViewModel>(
                                          builder: (context, val1, child) {
                                            return CustomTextField(
                                                controller: val1.customerNameC,
                                                iconData: Icons.person,
                                                hint: 'Customer name',
                                                validatorText:
                                                    'Provide customer name');
                                          },
                                        ),

                                        // businessTitle
                                        /// text field
                                        Consumer<PlaceCustomizeOrderViewModel>(
                                          builder: (context, val2, child) {
                                            return CustomTextField(
                                                controller: val2.businessTitleC,
                                                iconData: Icons.business,
                                                hint: 'Business name',
                                                validatorText:
                                                    'Provide business name');
                                          },
                                        ),

                                        // customerContact
                                        /// text field number only
                                        Consumer<PlaceCustomizeOrderViewModel>(
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
                                                validatorText:
                                                    'Provide customer phone no.');
                                          },
                                        ),

                                        // customerAddress
                                        /// text field
                                        Consumer<PlaceCustomizeOrderViewModel>(
                                            builder: (context, val4, child) {
                                          return CustomTextField(
                                              controller: val4.customerAddressC,
                                              iconData: Icons.home_filled,
                                              hint: 'Address',
                                              validatorText:
                                                  'Provide customer address');
                                        }),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Design'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val1, child) =>
                                                  CustomDropDown(
                                                      validator: null,
                                                      list: val1.designNames,
                                                      value:
                                                          val1.selectedDesign,
                                                      hint: val1.selectedDesign,
                                                      onChanged: (newVal) {
                                                        if (newVal != null) {
                                                          val1.selectedDesign =
                                                              newVal;
                                                          val1.selectedDesignIndex =
                                                              val1.designNames
                                                                  .indexOf(val1
                                                                      .selectedDesign);
                                                          if (newVal ==
                                                              'none') {
                                                            debugPrint(
                                                                "No design");
                                                          } else {
                                                            debugPrint(
                                                                'Design Rate: ${val1.designs[val1.selectedDesignIndex - 1].rate}');
                                                          }
                                                        }
                                                      }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Paper Size'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val2, child) =>
                                                  CustomDropDown(
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
                                                  for (var paper
                                                      in val2.papers) {
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
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Quality'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val3, child) =>
                                                  CustomDropDown(
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
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Books Quantity'),
                                            SizedBox(
                                              height: 60,
                                              width: 100,
                                              child: Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                                builder:
                                                    (context, val4, child) =>
                                                        TextFormField(
                                                  controller:
                                                      val4.booksQuantityC,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  cursorColor: kPrimeColor,
                                                  decoration: InputDecoration(
                                                    hintText: 'Books',
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        width: 2,
                                                        color: kPrimeColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        color: kSecColor,
                                                      ),
                                                    ),
                                                  ),
                                                  validator: (text) {
                                                    if (text == '' ||
                                                        text == null) {
                                                      return 'Please provide books quantity';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Pages per book'),
                                            SizedBox(
                                              height: 60,
                                              width: 150,
                                              child: Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                                builder:
                                                    (context, val0, child) =>
                                                        TextFormField(
                                                  controller:
                                                      val0.pagesPerBookC,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                  cursorColor: kPrimeColor,
                                                  decoration: InputDecoration(
                                                    hintText: 'Pages per book',
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        width: 2,
                                                        color: kPrimeColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        color: kSecColor,
                                                      ),
                                                    ),
                                                  ),
                                                  validator: (text) {
                                                    if (text == '' ||
                                                        text == null) {
                                                      return 'Please provide pages per book';
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Paper Cutting'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val5, child) =>
                                                  CustomDropDown(
                                                      validator: null,
                                                      list: val5
                                                          .paperCuttingNames,
                                                      value: val5
                                                          .selectedPaperCutting,
                                                      hint: val5
                                                          .selectedPaperCutting,
                                                      onChanged: (newVal) {
                                                        val5.selectedPaperCutting =
                                                            newVal!;
                                                        val5.selectedPaperCuttingIndex = val5
                                                            .paperCuttingNames
                                                            .indexOf(val5
                                                                .selectedPaperCutting);

                                                        if (newVal ==
                                                            'none') {
                                                          debugPrint(
                                                              "No paper cutting");
                                                        } else {
                                                          debugPrint(
                                                              'Paper cutting Rate: ${val5.paperCuttings[val5.selectedPaperCuttingIndex - 1].rate}');
                                                        }
                                                      }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Unit'),
                                            Consumer<
                                                    PlaceCustomizeOrderViewModel>(
                                                builder:
                                                    (context, val6, child) {
                                              return CustomDropDown(
                                                  validator: null,
                                                  list: val6
                                                      .basicCuttingUnitsList,
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
                                          ],
                                        ),
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Copy Variants'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val7, child) =>
                                                  CustomDropDown(
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
                                                      list:
                                                          val7.copyVariantNames,
                                                      value: val7
                                                          .selectedCopyVariant,
                                                      hint: val7
                                                          .selectedCopyVariant,
                                                      onChanged: (newVal) {
                                                        val7.selectedCopyVariant =
                                                            newVal!;
                                                        val7.selectedCopyVariantIndex = val7
                                                            .copyVariantNames
                                                            .indexOf(val7
                                                                .selectedCopyVariant);
                                                        val7.updateListener();
                                                      }),
                                            ),
                                          ],
                                        ),
                                        Consumer<PlaceCustomizeOrderViewModel>(
                                            builder: (context, val8, child) {
                                          if (val.selectedCopyVariant ==
                                              'none') {
                                            return const SizedBox.shrink();
                                          } else if (val.selectedCopyVariant ==
                                              'news') {
                                            return Column(children: [
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
                                              Row(
                                                children: [
                                                  const Text('News Size'),
                                                  Consumer<
                                                      PlaceCustomizeOrderViewModel>(
                                                    builder: (context, val9,
                                                            child) =>
                                                        CustomDropDown(
                                                      validator: (value) {
                                                        if (val9.selectedCopyVariant ==
                                                            'news' &&
                                                            value != val9.selectedPaperSize) {
                                                          Utils.showMessage('Select compatible news paper!');
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
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  const Text('News Quality'),
                                                  Consumer<
                                                      PlaceCustomizeOrderViewModel>(
                                                    builder: (context, val10,
                                                            child) =>
                                                        CustomDropDown(
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
                                                ],
                                              ),
                                            ]);
                                          } else if (val.selectedCopyVariant ==
                                              'carbon') {
                                            return Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text(
                                                        'Variant Quality'),
                                                    Consumer<
                                                        PlaceCustomizeOrderViewModel>(
                                                      builder: (context, val3,
                                                              child) =>
                                                          CustomDropDown(
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
                                                                        .indexOf(
                                                                            val3.selectedCopyVariantPaperQuality)]]
                                                                    .rate;
                                                                debugPrint(
                                                                    'Rate of the selected paper variant quality is : $rate');
                                                                // }
                                                              }),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    const Text(
                                                        'Variant Print Type'),
                                                    Consumer<
                                                        PlaceCustomizeOrderViewModel>(
                                                      builder: (context, val12,
                                                              child) =>
                                                          CustomDropDown(
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
                                                ),
                                              ],
                                            );
                                          } else {
                                            /// it means carbon-less
                                            return Column(children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    const Text('Variant Type'),
                                                    Consumer<
                                                            PlaceCustomizeOrderViewModel>(
                                                        builder: (context,
                                                                val12, child) =>
                                                            CustomDropDown(
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
                                                                  switch (
                                                                      newVal) {
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
                                                  ])
                                            ]);
                                          }
                                        }),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Binding'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val9, child) =>
                                                  CustomDropDown(
                                                      validator: null,
                                                      list: val9.bindingNames,
                                                      value:
                                                          val9.selectedBinding,
                                                      hint:
                                                          val9.selectedBinding,
                                                      onChanged: (newVal) {
                                                        val9.selectedBinding =
                                                            newVal!;
                                                        val9.selectedBindingIndex =
                                                            val9.bindingNames
                                                                .indexOf(val9
                                                                    .selectedBinding);
                                                      }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Numbering'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val11,
                                                      child) =>
                                                  CustomDropDown(
                                                      validator: null,
                                                      list:
                                                          val11.numberingNames,
                                                      value: val11
                                                          .selectedNumbering,
                                                      hint: val11
                                                          .selectedNumbering,
                                                      onChanged: (newVal) {
                                                        val11.selectedNumbering =
                                                            newVal!;
                                                        val11.selectedNumberingIndex =
                                                            val11.numberingNames
                                                                .indexOf(val11
                                                                    .selectedNumbering);
                                                      }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Print Type'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val12,
                                                      child) =>
                                                  CustomDropDown(
                                                      validator: (value) {
                                                        if (val12.selectedCopyVariant ==
                                                                'carbon-less' &&
                                                            value != '1C') {
                                                          return 'Select 1 Color';
                                                        }
                                                        return null;
                                                      },
                                                      list: val12.printNames,
                                                      value:
                                                          val12.selectedPrint,
                                                      hint: val12.selectedPrint,
                                                      onChanged: (newVal) {
                                                        val12.selectedPrint =
                                                            newVal!;
                                                        debugPrint(
                                                            'Print: ${int.tryParse(val12.selectedPrint.substring(0, 1))}');
                                                      }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Backside Print'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val13,
                                                      child) =>
                                                  CustomDropDown(
                                                      validator: (value) {
                                                        if (val13.selectedCopyVariant ==
                                                            'carbon-less' &&
                                                            value != 'none') {
                                                          return 'Select none';
                                                        }
                                                        return null;
                                                      },
                                                      list: val13
                                                          .backSidePrintingList,
                                                      value: val13
                                                          .selectedBackSide,
                                                      hint: val13
                                                          .selectedBackSide,
                                                      onChanged: (newVal) {
                                                        val13.selectedBackSide =
                                                            newVal!;
                                                        debugPrint(
                                                            'Back side Print: ${int.tryParse(val13.selectedBackSide.substring(0, 1)) ?? val13.selectedBackSide}');
                                                      }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Profit'),
                                            Consumer<
                                                PlaceCustomizeOrderViewModel>(
                                              builder: (context, val14,
                                                      child) =>
                                                  CustomDropDown(
                                                      validator: null,
                                                      list: val14.profitNames,
                                                      value:
                                                          val14.selectedProfit,
                                                      hint:
                                                          val14.selectedProfit,
                                                      onChanged: (newVal) {
                                                        val14.selectedProfit =
                                                            newVal!;
                                                        val14.selectedProfitIndex =
                                                            val14.profitNames
                                                                .indexOf(val14
                                                                    .selectedProfit);
                                                      }),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text(
                                                'Other expenses(if any)'),
                                            SizedBox(
                                              height: 60,
                                              width: 100,
                                              child: Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                                builder:
                                                    (context, val15, child) =>
                                                        TextFormField(
                                                  controller:
                                                      val15.otherExpensesC,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: kPrimeColor,
                                                  decoration: InputDecoration(
                                                    hintText: 'Expenses',
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        width: 2,
                                                        color: kPrimeColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        color: kSecColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            const Text('Advance Payment'),
                                            SizedBox(
                                              height: 60,
                                              width: 100,
                                              child: Consumer<
                                                  PlaceCustomizeOrderViewModel>(
                                                builder:
                                                    (context, val15, child) =>
                                                        TextFormField(
                                                  controller:
                                                      val15.advancePaymentC,
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter
                                                        .digitsOnly,
                                                  ],
                                                  validator: (value){
                                                    if(value == '' || value!.isEmpty){
                                                      return 'Provide advance payment!';
                                                    }
                                                    return null;
                                                  },
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor: kPrimeColor,
                                                  decoration: InputDecoration(
                                                    hintText: 'Payment',
                                                    filled: true,
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        width: 2,
                                                        color: kPrimeColor,
                                                      ),
                                                    ),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      borderSide: BorderSide(
                                                        color: kSecColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: TextButton(
                                        onPressed: () {},
                                        child: const Text(
                                          'Calculate',
                                          style: TextStyle(fontSize: 18),
                                        ))),
                                const Expanded(
                                    child: Center(child: Text('000'))),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            RoundButton(
                              title: 'Place Order',
                              onPress: () {
                                val.paperLogic();
                                val.calculateRate();

                              },
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                                'You must have at least one rate of each service'),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const RateListView(),
                                  ),
                                );
                              },
                              child: const Text('Add service rate'),
                            ),
                          ],
                        )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        ]),
      ),
    );
  }
}
