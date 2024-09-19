import 'package:flutter/material.dart';
import 'package:printing_press/view_model/suppliers/all_suppliers_view_model.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import 'add_supplier_view.dart';

class AllSuppliersView extends StatefulWidget {
  const AllSuppliersView({super.key});


  @override
  State<AllSuppliersView> createState() => _AllSuppliersViewState();
}

class _AllSuppliersViewState extends State<AllSuppliersView> {
  late AllSuppliersViewModel allSuppliersViewModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    allSuppliersViewModel =
        Provider.of<AllSuppliersViewModel>(context, listen: false);
    // widget.allSuppliersViewModel =
    //     Provider.of<AllSuppliersViewModel>(context, listen: false);
    // widget.allSuppliersViewModel.getFirestoreData();
  }

  @override
  Widget build(BuildContext context) {
   allSuppliersViewModel =
        Provider.of<AllSuppliersViewModel>(context, listen: false);

   allSuppliersViewModel.getDataFromFirestore();

    return Scaffold(
      floatingActionButton: Consumer<AllSuppliersViewModel>(
        builder: (context, value, child) => FloatingActionButton(
          backgroundColor: kSecColor,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddSupplierView()));
          },
          child: Text(
            'Add +',
            style: TextStyle(color: kThirdColor),
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text('All Suppliers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<AllSuppliersViewModel>(
          builder: (context, value, child) => value.dataFetched
              ? value.allSuppliersModel.isEmpty
                  ? const Center(
                      child: Text('No record found!'),
                    )
                  : ListView.builder(
                      itemCount: value.allSuppliersModel.length,
                      itemBuilder: (BuildContext context, int index) {
                        /// todo: change the list tile to custom design
                        return ListTile(
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          shape: Border.all(width: 2, color: kPrimeColor),
                          // titleAlignment: ListTileTitleAlignment.threeLine,
                          titleTextStyle: TextStyle(
                              color: kThirdColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                          title:
                              Text(value.allSuppliersModel[index].supplierName),
                          tileColor: kTwo,
                          subtitleTextStyle: const TextStyle(
                              color: Colors.black, fontStyle: FontStyle.italic),
                          subtitle: Text(
                            'Phone No: ${value.allSuppliersModel[index].supplierPhoneNo}\nAddress: ${value.allSuppliersModel[index].supplierAddress}\nAccount no: ${value.allSuppliersModel[index].accountNumber}',
                          ),
                          leading: Text(value
                              .allSuppliersModel[index].supplierId
                              .toString()),
                        );
                      },
                    )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
