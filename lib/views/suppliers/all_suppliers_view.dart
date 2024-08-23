import 'package:flutter/material.dart';
import 'package:printing_press/view_model/suppliers/all_suppliers_view_model.dart';
import 'package:provider/provider.dart';
import '../../colors/color_palette.dart';
import 'add_supplier_view.dart';

class AllSuppliersView extends StatefulWidget {
  AllSuppliersView({super.key});

  late AllSuppliersViewModel allSuppliersViewModel;

  @override
  State<AllSuppliersView> createState() => _AllSuppliersViewState();
}

class _AllSuppliersViewState extends State<AllSuppliersView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // widget.allSuppliersViewModel =
    //     Provider.of<AllSuppliersViewModel>(context, listen: false);
    // widget.allSuppliersViewModel.getFirestoreData();
  }

  @override
  Widget build(BuildContext context) {
    widget.allSuppliersViewModel =
        Provider.of<AllSuppliersViewModel>(context, listen: false);
    widget.allSuppliersViewModel.getFirestoreData();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kSecColor,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddSupplierView(
                    id: 0,
                  )));
        },
        child: Text(
          'Add +',
          style: TextStyle(color: kThirdColor),
        ),
      ),
      appBar: AppBar(
        title: const Text('All Suppliers'),
      ),
      body: Consumer<AllSuppliersViewModel>(
        builder: (context, value, child) => value.dataFetched
            ? Column(
                children: [
                  value.data == null
                      ? const Center(
                          child: Text(
                          'No record found!',
                        ))
                      : Text('To do implementations.'),
                  Text('To do implementations.'),

                ],
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
