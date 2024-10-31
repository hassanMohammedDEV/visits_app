import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visitors/controller/visitor_controller.dart';
import 'package:visitors/model/visitor.dart';

class VisitorsScreen extends StatefulWidget {
  const VisitorsScreen({super.key});

  @override
  State<VisitorsScreen> createState() => _VisitorsScreenState();
}

class _VisitorsScreenState extends State<VisitorsScreen> {
  late VisitorController visitorController;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VisitorController>(
        init: VisitorController(),
        builder: (controller) {
          visitorController = controller;
          return Scaffold(
            body: Column(
              children: [
                ElevatedButton(
                    onPressed: orReadDoc,
                    child: const Icon(Icons.file_download)),
                ElevatedButton(
                    onPressed: orBarcode,
                    child: const Icon(Icons.barcode_reader)),
              ],
            ),
          );
        });
  }

  Future orBarcode() async {
    String result = await visitorController.readBarcode();
    if (result.isNotEmpty) {
      Visitor? visitor = await visitorController.visitorsSearch(result);
      if (visitor != null) {
        Get.showSnackbar(GetSnackBar(
          duration: Duration(seconds: 1),
          message: visitor.name,
        ));
      }else{
        Get.showSnackbar(const GetSnackBar(
          message: 'لم يتم العثور على الزائر',backgroundColor:
          Colors.redAccent,
          duration: Duration(seconds: 1),
        ));
      }
    }
  }

  Future orReadDoc() async {
    await visitorController.onExportVisitors();
  }
}
