import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing_press/components/custom_drop_down.dart';
import 'package:printing_press/components/custom_text_field.dart';
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
  late final PlaceStockOrderViewModel placeStockOrderViewModel;

  @override
  void initState() {
    super.initState();
    placeStockOrderViewModel =
        Provider.of<PlaceStockOrderViewModel>(context, listen: false);
    // placeOrderViewModel.checkData();
    placeStockOrderViewModel.getAllStock();
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
                  ? Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Form(
                                key: placeStockOrderViewModel.formKey,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: Column(
                                    children: [
                                      // customerName
                                      /// text field
                                      Consumer<PlaceStockOrderViewModel>(
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
                                      Consumer<PlaceStockOrderViewModel>(
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
                                      Consumer<PlaceStockOrderViewModel>(
                                        builder: (context, val3, child) {
                                          return CustomTextField(
                                              textInputType:
                                                  TextInputType.number,
                                              controller: val3.customerContactC,
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
                                            controller: val4.customerAddressC,
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
                                          Consumer<PlaceStockOrderViewModel>(
                                              builder: (context, val1, child) {
                                            return Expanded(
                                              flex: 2,
                                              child: CustomDropDown(
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
                                                  flex: 1, child: Text('Id: ')),
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
                                                  child: Text('Category: ')),
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
                                                  child: Text('Available: ')),
                                              Expanded(
                                                  flex: 1,
                                                  child: Text(value
                                                      .stockList[value
                                                          .selectedStockIndex]
                                                      .availableStock
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
                                              flex: 1, child: Text('Quantity')),
                                          Expanded(
                                            flex: 2,

                                            ///todo: add plus icon and minus icon for ease
                                            child: TextFormField(
                                              controller: value.stockQuantityC,
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
                                                if (value.selectedStockIndex ==
                                                    0) {
                                                  return 'Select a stock';
                                                } else if (text == '' ||
                                                    text == null) {
                                                  return 'Provide stock quantity';
                                                } else if (int.tryParse(value
                                                        .stockQuantityC.text)! >
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
                                        return CustomTextField(
                                            textInputType: TextInputType.number,
                                            controller: val5.advancePaymentC,
                                            inputFormatter:
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                            iconData:
                                                Icons.monetization_on_rounded,
                                            hint: 'Advance payment',
                                            validatorText:
                                                'Provide advance payment');
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
                          onPress: () {
                            if (value.formKey.currentState.validate()) {
                              ///todo: add order in firebase firestore
                              debugPrint('Available stock');
                            }
                          },
                        ),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
          const Center(
            child: Text('TODO.....'),
          )
          // Consumer<PlaceCustomizeOrderViewModel>(
          //   builder: (context, val, child) {
          //     return val.customOrderDataFetched
          //         ? Column(
          //             children: [
          //               Expanded(
          //                 child: SingleChildScrollView(
          //                   child: Padding(
          //                     padding: const EdgeInsets.all(8.0),
          //                     child: Form(
          //                       key: placeOrderViewModel.formKey,
          //                       child: Padding(
          //                         padding:
          //                             const EdgeInsets.symmetric(vertical: 8.0),
          //                         child: Column(children: [
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceAround,
          //                             children: [
          //                               const Text('Design'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val1, child) =>
          //                                     CustomDropDown(
          //                                         list: val1.designNames,
          //                                         value: val1.selectedDesign,
          //                                         hint: val1.selectedDesign,
          //                                         onChanged: (newVal) {
          //                                           if (newVal != null) {
          //                                             val1.selectedDesign =
          //                                                 newVal;
          //                                             val1.selectedDesignIndex =
          //                                                 val1.designNames
          //                                                     .indexOf(val1
          //                                                         .selectedDesign);
          //                                             if (newVal == 'none') {
          //                                               debugPrint("No design");
          //                                             } else {
          //                                               debugPrint(
          //                                                   'Design Rate: ${val1.rateList.designs[val1.selectedDesignIndex - 1].rate}');
          //                                             }
          //                                           }
          //                                         }),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             children: [
          //                               const Text('Paper Size'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val2, child) =>
          //                                     CustomDropDown(
          //                                   list: val2.paperSizes,
          //                                   value: val2.selectedPaperSize,
          //                                   hint: val2.selectedPaperSize,
          //                                   onChanged: (newVal) {
          //                                     val2.selectedPaperSize = newVal!;
          //                                     val2.selectedPaperSizePaperQualities
          //                                         .clear();
          //                                     val2.selectedPaperSizeIndexes
          //                                         .clear();
          //                                     // change the next dropdown according to the selected paper size
          //
          //                                     if (val2.selectedPaperSize ==
          //                                         'none') {
          //                                       val2.selectedPaperSizePaperQualities
          //                                           .add('none');
          //
          //                                       val2.selectedPaperQuality = val2
          //                                           .selectedPaperSizePaperQualities[0];
          //                                       debugPrint(
          //                                           'Selected Paper Quality: ${val2.selectedPaperQuality}');
          //                                     } else {
          //                                       int index = 0;
          //                                       for (var paper
          //                                           in val2.rateList.paper) {
          //                                         // debugPrint(
          //                                         //     '\n selected Paper size : $selectedPaperSize');
          //                                         // debugPrint(
          //                                         //     'checking the paper size in firebase: ${paper.size.width} x ${paper.size.height}');
          //                                         if (val2.selectedPaperSize ==
          //                                                 '${paper.size.width} x ${paper.size.height}' ||
          //                                             val2.selectedPaperSize ==
          //                                                 '${paper.size.height} x ${paper.size.width}') {
          //                                           val2.selectedPaperSizePaperQualities
          //                                               .add(
          //                                                   '${paper.quality}');
          //                                           val2.selectedPaperSizeIndexes
          //                                               .add(index);
          //                                           debugPrint(
          //                                               'paper quality added of index $index');
          //                                         }
          //                                         index++;
          //                                       }
          //
          //                                       debugPrint(
          //                                           'Paper size indexes : ${val2.selectedPaperSizeIndexes}');
          //                                       debugPrint(
          //                                           'Paper Qualities: ${val2.selectedPaperSizePaperQualities}');
          //                                       val2.selectedPaperQuality = val2
          //                                           .selectedPaperSizePaperQualities[0];
          //                                       debugPrint(
          //                                           'Selected Paper Quality: ${val2.selectedPaperQuality}');
          //
          //                                       // rate of the selected paper size, selected paper quality
          //                                       int rate = val2
          //                                           .rateList
          //                                           .paper[val2.selectedPaperSizeIndexes[val2
          //                                               .selectedPaperSizePaperQualities
          //                                               .indexOf(val2
          //                                                   .selectedPaperQuality)]]
          //                                           .rate;
          //                                       debugPrint(
          //                                           'Rate of the selected paper quality is : $rate');
          //                                     }
          //                                     val2.updateListener();
          //                                   },
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             children: [
          //                               const Text('Quality'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val3, child) =>
          //                                     CustomDropDown(
          //                                         list: val3
          //                                             .selectedPaperSizePaperQualities,
          //                                         value:
          //                                             val3.selectedPaperQuality,
          //                                         hint:
          //                                             val3.selectedPaperQuality,
          //                                         onChanged: (newVal) {
          //                                           val3.selectedPaperQuality =
          //                                               newVal!;
          //
          //                                           debugPrint(
          //                                               '\n\n\nSelected Paper size... : ${val3.selectedPaperSize}');
          //                                           debugPrint(
          //                                               'All Paper Qualities... : ${val3.selectedPaperSizePaperQualities}');
          //                                           debugPrint(
          //                                               'Selected Paper quality... : ${val3.selectedPaperQuality}');
          //                                           debugPrint(
          //                                               'All selected Paper size indexes... : ${val3.selectedPaperSizeIndexes}\n\n\n');
          //
          //                                           if (val3.selectedPaperQuality !=
          //                                               'none') {
          //                                             // rate of the selected paper size, selected paper quality
          //                                             int rate = val3
          //                                                 .rateList
          //                                                 .paper[val3.selectedPaperSizeIndexes[val3
          //                                                     .selectedPaperSizePaperQualities
          //                                                     .indexOf(val3
          //                                                         .selectedPaperQuality)]]
          //                                                 .rate;
          //                                             debugPrint(
          //                                                 'Rate of the selected paper quality is : $rate');
          //                                           }
          //                                         }),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceAround,
          //                             children: [
          //                               const Text('Books Quantity'),
          //                               SizedBox(
          //                                 height: 60,
          //                                 width: 100,
          //                                 child: Consumer<
          //                                     PlaceCustomizeOrderViewModel>(
          //                                   builder: (context, val4, child) =>
          //                                       TextFormField(
          //                                     controller: val4.booksQuantityC,
          //                                     keyboardType:
          //                                         TextInputType.number,
          //                                     cursorColor: kPrimeColor,
          //                                     decoration: InputDecoration(
          //                                       hintText: 'Books',
          //                                       filled: true,
          //                                       focusedBorder:
          //                                           OutlineInputBorder(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10),
          //                                         borderSide: BorderSide(
          //                                           width: 2,
          //                                           color: kPrimeColor,
          //                                         ),
          //                                       ),
          //                                       enabledBorder:
          //                                           OutlineInputBorder(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10),
          //                                         borderSide: BorderSide(
          //                                           color: kSecColor,
          //                                         ),
          //                                       ),
          //                                     ),
          //                                     validator: (text) {
          //                                       if (text == '' ||
          //                                           text == null) {
          //                                         return 'Please provide books quantity';
          //                                       }
          //                                       return null;
          //                                     },
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             children: [
          //                               const Text('Paper Cutting'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val5, child) =>
          //                                     CustomDropDown(
          //                                         list: val5.paperCuttingNames,
          //                                         value:
          //                                             val5.selectedPaperCutting,
          //                                         hint:
          //                                             val5.selectedPaperCutting,
          //                                         onChanged: (newVal) {
          //                                           val5.selectedPaperCutting =
          //                                               newVal!;
          //                                           val5.selectedPaperCuttingIndex =
          //                                               val5.paperCuttingNames
          //                                                   .indexOf(val5
          //                                                       .selectedPaperCutting);
          //
          //                                           if (val5.selectedPaperCutting ==
          //                                               'none') {
          //                                             debugPrint(
          //                                                 "No paper cutting");
          //                                           } else {
          //                                             debugPrint(
          //                                                 'Paper cutting Rate: ${val5.rateList.paperCutting[val5.selectedPaperCuttingIndex - 1].rate}');
          //                                           }
          //                                         }),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             children: [
          //                               const Text('Unit'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                   builder: (context, val6, child) {
          //                                 return CustomDropDown(
          //                                     list: val6.basicCuttingUnitsList,
          //                                     value:
          //                                         val6.selectedBasicCuttingUnit,
          //                                     hint:
          //                                         val6.selectedBasicCuttingUnit,
          //                                     onChanged: (newVal) {
          //                                       val6.selectedBasicCuttingUnit =
          //                                           newVal!;
          //                                       debugPrint(
          //                                           'New value is $newVal');
          //                                       if (val6.selectedBasicCuttingUnit ==
          //                                           'none') {
          //                                         val6.selectedBasicCuttingUnitIndex =
          //                                             0;
          //                                         debugPrint('No cutting unit');
          //                                       } else {
          //                                         val6.selectedBasicCuttingUnitIndex =
          //                                             val6.basicCuttingUnitsList
          //                                                 .indexOf(newVal);
          //
          //                                         int? cuttingUnit =
          //                                             int.tryParse(val6
          //                                                 .selectedBasicCuttingUnit
          //                                                 .substring(2));
          //
          //                                         debugPrint(
          //                                             "Selected basic cutting unit (int): $cuttingUnit");
          //                                       }
          //
          //                                       debugPrint(
          //                                           'Index of basic paper cutting is ${val6.selectedBasicCuttingUnitIndex}');
          //                                     });
          //                               }),
          //                             ],
          //                           ),
          //                           // Consumer<PlaceOrderViewModel>(
          //                           //   builder: (context, val7, child) => Column(
          //                           //     children: [
          //                           //       CustomRadioListTile(
          //                           //         title: 'News',
          //                           //           value: 0,
          //                           //           groupValue: val7.selectedValue,
          //                           //           onChanged: (value) =>
          //                           //               val7.onChanged(0)),
          //                           //       CustomRadioListTile(
          //                           //           title: 'None',
          //                           //           value: 1,
          //                           //           groupValue: val7.selectedValue,
          //                           //           onChanged: (value) =>
          //                           //               val7.onChanged(1)),
          //                           //       CustomRadioListTile(
          //                           //         title: 'Duplicate',
          //                           //           value: 2,
          //                           //           groupValue: val7.selectedValue,
          //                           //           onChanged: (value) =>
          //                           //               val7.onChanged(2)),
          //                           //       CustomRadioListTile(
          //                           //           title: 'Triplicate',
          //                           //           value: 3,
          //                           //           groupValue: val7.selectedValue,
          //                           //           onChanged: (value) =>
          //                           //               val7.onChanged(3)),
          //                           //     ],
          //                           //   ),
          //                           // ),
          //
          //                           // const Spacer(),
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceAround,
          //                             children: [
          //                               const Text('Copy Variants'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val7, child) =>
          //                                     CustomDropDown(
          //                                         list: val7.copyVariant,
          //                                         value:
          //                                             val7.selectedCopyVariant,
          //                                         hint:
          //                                             val7.selectedCopyVariant,
          //                                         onChanged: (newVal) =>
          //                                             val7.copyVariantOnChange!(
          //                                                 newVal)),
          //                               ),
          //                             ],
          //                           ),
          //                           Consumer<PlaceCustomizeOrderViewModel>(
          //                               builder: (context, val8, child) {
          //                             if (val.selectedCopyVariant == 'none') {
          //                               return const SizedBox();
          //                             } else {
          //                               return Column(
          //                                 children: [
          //                                   Row(
          //                                     children: [
          //                                       const Text('Copy Printing'),
          //                                       CustomDropDown(
          //                                           list: val8.copyPrint,
          //                                           value:
          //                                               val8.selectedCopyPrint,
          //                                           hint:
          //                                               val8.selectedCopyPrint,
          //                                           onChanged: (newVal) {
          //                                             val8.selectedCopyPrint =
          //                                                 newVal!;
          //                                             val8.selectedCopyPrintIndex =
          //                                                 val8.copyPrint
          //                                                     .indexOf(val8
          //                                                         .selectedCopyPrint);
          //                                           }),
          //                                     ],
          //                                   ),
          //                                   val.selectedCopyVariant == 'news'
          //                                       ? Column(
          //                                           children: [
          //                                             Row(
          //                                               children: [
          //                                                 const Text(
          //                                                     'News Size'),
          //                                                 Consumer<
          //                                                     PlaceCustomizeOrderViewModel>(
          //                                                   builder: (context,
          //                                                           val9,
          //                                                           child) =>
          //                                                       CustomDropDown(
          //                                                     list: val9
          //                                                         .newsPaperSizes,
          //                                                     value: val9
          //                                                         .selectedNewsPaperSize,
          //                                                     hint: val9
          //                                                         .selectedNewsPaperSize,
          //                                                     onChanged:
          //                                                         (newVal) {
          //                                                       val9.selectedNewsPaperSize =
          //                                                           newVal!;
          //                                                       val9.selectedNewsPaperSizePaperQualities
          //                                                           .clear();
          //                                                       val9.selectedNewsPaperSizeIndexes
          //                                                           .clear();
          //                                                       // change the next dropdown according to the selected news paper size
          //
          //                                                       if (newVal ==
          //                                                           'none') {
          //                                                         val9.selectedNewsPaperSizePaperQualities
          //                                                             .add(
          //                                                                 'none');
          //
          //                                                         val9.selectedNewsPaperQuality =
          //                                                             val9.selectedNewsPaperSizePaperQualities[
          //                                                                 0];
          //                                                         debugPrint(
          //                                                             'Selected News Paper Quality: ${val9.selectedNewsPaperQuality}');
          //                                                       } else {
          //                                                         int index = 0;
          //                                                         for (var news
          //                                                             in val9
          //                                                                 .rateList
          //                                                                 .news) {
          //                                                           // debugPrint(
          //                                                           //     '\n selected news Paper size : $selectedNewsPaperSize');
          //                                                           // debugPrint(
          //                                                           //     'checking the news paper size in firebase: ${news.size.width} x ${news.size.height}');
          //                                                           if (newVal ==
          //                                                                   '${news.size.width} x ${news.size.height}' ||
          //                                                               newVal ==
          //                                                                   '${news.size.height} x ${news.size.width}') {
          //                                                             val9.selectedNewsPaperSizePaperQualities
          //                                                                 .add(
          //                                                                     '${news.quality}');
          //                                                             val9.selectedNewsPaperSizeIndexes
          //                                                                 .add(
          //                                                                     index);
          //                                                             debugPrint(
          //                                                                 'news paper quality added of index $index');
          //                                                           }
          //                                                           index++;
          //                                                         }
          //
          //                                                         debugPrint(
          //                                                             'News Paper size indexes : ${val9.selectedNewsPaperSizeIndexes}');
          //                                                         debugPrint(
          //                                                             'News Paper Qualities: ${val9.selectedNewsPaperSizePaperQualities}');
          //                                                         val9.selectedNewsPaperQuality =
          //                                                             val9.selectedNewsPaperSizePaperQualities[
          //                                                                 0];
          //                                                         debugPrint(
          //                                                             'Selected News Paper Quality: ${val9.selectedNewsPaperQuality}');
          //
          //                                                         // rate of the selected News paper size, selected News paper quality
          //                                                         int rate = val9
          //                                                             .rateList
          //                                                             .news[val9.selectedNewsPaperSizeIndexes[val9
          //                                                                 .selectedNewsPaperSizePaperQualities
          //                                                                 .indexOf(
          //                                                                     val9.selectedNewsPaperQuality)]]
          //                                                             .rate;
          //                                                         debugPrint(
          //                                                             'Rate of the selected news paper quality is : $rate');
          //                                                       }
          //                                                       val9.updateListener();
          //                                                     },
          //                                                   ),
          //                                                 ),
          //                                               ],
          //                                             ),
          //                                             Row(
          //                                               children: [
          //                                                 const Text(
          //                                                     'News Quality'),
          //                                                 Consumer<
          //                                                     PlaceCustomizeOrderViewModel>(
          //                                                   builder: (context,
          //                                                           val10,
          //                                                           child) =>
          //                                                       CustomDropDown(
          //                                                           list: val10
          //                                                               .selectedNewsPaperSizePaperQualities,
          //                                                           value: val10
          //                                                               .selectedNewsPaperQuality,
          //                                                           hint: val10
          //                                                               .selectedNewsPaperQuality,
          //                                                           onChanged:
          //                                                               (newVal) {
          //                                                             val10.selectedNewsPaperQuality =
          //                                                                 newVal!;
          //
          //                                                             debugPrint(
          //                                                                 '\n\n\nSelected News Paper size... : ${val10.selectedNewsPaperSize}');
          //                                                             debugPrint(
          //                                                                 'All News Paper Qualities... : ${val10.selectedNewsPaperSizePaperQualities}');
          //                                                             debugPrint(
          //                                                                 'Selected News Paper quality... : ${val10.selectedNewsPaperQuality}');
          //                                                             debugPrint(
          //                                                                 'All selected News Paper size indexes... : ${val10.selectedNewsPaperSizeIndexes}\n\n\n');
          //
          //                                                             if (val10
          //                                                                     .selectedNewsPaperQuality !=
          //                                                                 'none') {
          //                                                               // rate of the selected News paper size, selected News paper quality
          //                                                               int rate = val10
          //                                                                   .rateList
          //                                                                   .news[val10.selectedNewsPaperSizeIndexes[val10.selectedNewsPaperSizePaperQualities.indexOf(val10.selectedNewsPaperQuality)]]
          //                                                                   .rate;
          //                                                               debugPrint(
          //                                                                   'Rate of the selected News paper quality is : $rate');
          //                                                             }
          //                                                           }),
          //                                                 ),
          //                                               ],
          //                                             ),
          //                                           ],
          //                                         )
          //                                       : const SizedBox(),
          //                                 ],
          //                               );
          //                             }
          //                           }),
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceAround,
          //                             children: [
          //                               const Text('Binding'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val9, child) =>
          //                                     CustomDropDown(
          //                                         list: val9.bindingNames,
          //                                         value: val9.selectedBinding,
          //                                         hint: val9.selectedBinding,
          //                                         onChanged: (newVal) {
          //                                           val9.selectedBinding =
          //                                               newVal!;
          //                                           val9.selectedBindingIndex =
          //                                               val9
          //                                                   .bindingNames
          //                                                   .indexOf(val9
          //                                                       .selectedBinding);
          //                                         }),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceAround,
          //                             children: [
          //                               const Text('Numbering'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val11, child) =>
          //                                     CustomDropDown(
          //                                         list: val11.numberingNames,
          //                                         value:
          //                                             val11.selectedNumbering,
          //                                         hint: val11.selectedNumbering,
          //                                         onChanged: (newVal) {
          //                                           val11.selectedNumbering =
          //                                               newVal!;
          //                                           val11.selectedNumberingIndex =
          //                                               val11.numberingNames
          //                                                   .indexOf(val11
          //                                                       .selectedNumbering);
          //                                         }),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceAround,
          //                             children: [
          //                               const Text('Print Type'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val12, child) =>
          //                                     CustomDropDown(
          //                                         list: val12.printNames,
          //                                         value: val12.selectedPrint,
          //                                         hint: val12.selectedPrint,
          //                                         onChanged: (newVal) {
          //                                           val12.selectedPrint =
          //                                               newVal!;
          //                                           debugPrint(
          //                                               'Print: ${int.tryParse(val12.selectedPrint.substring(0, 1))}');
          //                                         }),
          //                               ),
          //                             ],
          //                           ),
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceAround,
          //                             children: [
          //                               const Text('Backside'),
          //                               Consumer<PlaceCustomizeOrderViewModel>(
          //                                 builder: (context, val13, child) =>
          //                                     CustomDropDown(
          //                                         list: val13.backSide,
          //                                         value: val13.selectedBackSide,
          //                                         hint: val13.selectedBackSide,
          //                                         onChanged: (newVal) {
          //                                           val13.selectedBackSide =
          //                                               newVal!;
          //                                         }),
          //                               ),
          //                             ],
          //                           ),
          //
          //                           Row(
          //                             mainAxisAlignment:
          //                                 MainAxisAlignment.spaceAround,
          //                             children: [
          //                               const Text('Other expenses(if any)'),
          //                               SizedBox(
          //                                 height: 60,
          //                                 width: 100,
          //                                 child: Consumer<
          //                                     PlaceCustomizeOrderViewModel>(
          //                                   builder: (context, val14, child) =>
          //                                       TextFormField(
          //                                     controller: val14.otherExpensesC,
          //                                     keyboardType:
          //                                         TextInputType.number,
          //                                     cursorColor: kPrimeColor,
          //                                     decoration: InputDecoration(
          //                                       hintText: 'Expenses',
          //                                       filled: true,
          //                                       focusedBorder:
          //                                           OutlineInputBorder(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10),
          //                                         borderSide: BorderSide(
          //                                           width: 2,
          //                                           color: kPrimeColor,
          //                                         ),
          //                                       ),
          //                                       enabledBorder:
          //                                           OutlineInputBorder(
          //                                         borderRadius:
          //                                             BorderRadius.circular(10),
          //                                         borderSide: BorderSide(
          //                                           color: kSecColor,
          //                                         ),
          //                                       ),
          //                                     ),
          //                                   ),
          //                                 ),
          //                               ),
          //                             ],
          //                           ),
          //                         ]),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //               RoundButton(
          //                 title: 'Place Order',
          //                 onPress: () {
          //                   debugPrint('add a paper');
          //
          //                   /// todo:
          //                   // Updating data to the firebase, but you have to fetch the data first, then you alter the data, and then update that data to the firebase firestore
          //                   // FirebaseFirestore.instance
          //                   //     .collection(auth.currentUser!.uid)
          //                   //     .doc("RateList")
          //                   //     .update({
          //                   //   "paper": [data]
          //                   // });
          //
          //                   // debugPrint(
          //                   //     'The rate of the standard is : ${rateList.designs[selectedDesignIndex].rate}');
          //                   // debugPrint(
          //                   //     'The rate of the standard is : ${rateList.paper[selectedPaperSizeIndex].rate}');
          //                   // debugPrint(
          //                   //     'The paper quantity : ${paperQuantityC.text.trim}');
          //                   /// todo: Converting textEditingController text to int for calculations + round the "divide by 500" value to upper value
          //                   // debugPrint(
          //                   //       'The rate of paper cutting : ${paperQuantityC.text.trim() / 500*rateList.paperCutting[selectedPaperCuttingIndex].rate}');
          //                 },
          //               ),
          //             ],
          //           )
          //         : const Center(child: CircularProgressIndicator());
          //   },
          // ),
        ]),
      ),
    );
  }
}

/// todo: paper sized or any other rate list things must not be same as available in the firebase
/// if design with name "standard" is available, then user can't add a design with name "standard"
/// anything that is in the dropdown menu has to be different as it would give you errors
/// design name must not be same
/// paper size are only some... they are hard coded, can't have any other size

// Navigate here from all orders view through floating action button
// Having two tabs
// 1. Service
//  Get list of services from all services
// 2. Product
//  Get list of products from available
