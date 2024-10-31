import 'dart:io';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:visitors/model/visitor.dart';

class VisitorController extends GetxController {
  List<Visitor> visitors = [];

  Future onExportVisitors() async {
    FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
      allowMultiple: false,
    );

    visitors = [];
    if (pickedFile != null) {
      var bytes = File(pickedFile.files.first.path!).readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);

      // read name and assigned to verb
      Sheet sheetObject = excel['Sheet1'];

      for (var table in excel.tables.keys) {
        for (int i = 1; i < excel.tables[table]!.rows.length; i++) {
          Visitor visitor = Visitor(id: '', name: '');
          try {
            // id
            Data idCell =
                sheetObject.cell(CellIndex.indexByString('A${i + 1}'));
            visitor.id = idCell.value.toString();

            // name
            Data nameCell =
                sheetObject.cell(CellIndex.indexByString('B${i + 1}'));
            visitor.name = nameCell.value.toString();
          } catch (e) {
            Get.showSnackbar(
                GetSnackBar(message: e.toString() + 'في السطر ${i + 1}',duration: Duration(seconds: 1),));
            break;
          }

          visitors.add(visitor);
          print(visitor.id);
        }
      }
    }
    update();
  }

  Future<String> readBarcode() async {
    String searchBarcodeResult = '';
    searchBarcodeResult = await FlutterBarcodeScanner.scanBarcode(
        "", "إنهاء", true, ScanMode.BARCODE);

    if (searchBarcodeResult != '-1') {
      // audioCache = AudioCache(fixedPlayer: player);
      // await audioCache.play(path);
      return searchBarcodeResult;
    }

    update();
    return '';
  }

  Future<Visitor?> visitorsSearch(String cardId) async {
    if (visitors.isNotEmpty) {
      return visitors.firstWhereOrNull((e) => e.id == cardId);
    }
    return null;
  }

}
