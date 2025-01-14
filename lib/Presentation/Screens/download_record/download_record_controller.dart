import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:salary_budget/Data/Core/Utils/app_constants.dart';
import 'package:salary_budget/Domain/extensions/extensions.dart';
import 'package:salary_budget/Presentation/Screens/view_record/view/view_record_tile_model.dart';
import 'package:salary_budget/Presentation/Widgets/common_widgets/common_widgets.dart';

class PDFGeneratorController extends GetxController {
  static PDFGeneratorController get instance => Get.find();

  RxBool isLoading = false.obs;

  Future<File?> generatePDF(BuildContext screenContext,String userName,String monthName,String year,double totalDebited, double totalCredited,double totalBalance,List<ViewRecordTileModel> data) async {
   try{
     //isLoading(true);
     WidgetsHelper.onLoading(screenContext,downloadWaitLbl);
     final pdf = pw.Document();
     // Add content to the PDF

     DateTime currentDate = DateTime.now();
     String formattedDateTime = DateFormat(ddMMyyHHmmLbl).format(currentDate);

     print(formattedDateTime);
     //final imagePathData = await rootBundle.load(AssetsUtils.appIconPng);
     //Uint8List imageData = (imagePathData).buffer.asUint8List();
     //isLoading.value = true;
     // Add content to the PDF
     pdf.addPage(
       pw.MultiPage(
         pageFormat: PdfPageFormat.a4,
         orientation: pw.PageOrientation.portrait,
         build: (context) => [
           pw.Column(
             crossAxisAlignment: pw.CrossAxisAlignment.start,
             children: [
               // Add the image here
               /*pw.Container(
                   alignment: pw.Alignment.topLeft,
                   width: 100.0,
                   height: 100.0,
                   child: pw.Image(pw.MemoryImage(imageData))
               ),*/
               pw.RichText(
                   text: pw.TextSpan(
                       children: [
                         pw.TextSpan(
                             text: statementTitleLbl,
                             style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)
                         ),
                         pw.TextSpan(text: "\n"),
                       ]
                   )
               ),
               pw.SizedBox(height: 10),
               pw.RichText(
                   text: pw.TextSpan(
                       children: [
                         pw.TextSpan(
                             text: "$userName: \t\t",style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold,color: PdfColors.black)),
                         pw.TextSpan(text:userName,style: pw.TextStyle(fontSize: 15,fontWeight: pw.FontWeight.bold,color:  PdfColors.blue),
                         ),
                       ]
                   )
               ), pw.SizedBox(height: 10),
               pw.RichText(
                   text: pw.TextSpan(
                       children: [
                         pw.TextSpan(
                             text: "$currentDate: \t",style: pw.TextStyle(fontSize: 15,color: PdfColors.black)),
                         pw.TextSpan(text:formattedDateTime,style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold,color:  PdfColors.black),
                         ),
                       ]
                   )
               ),
               pw.SizedBox(height: 10),
               pw.RichText(
                   text: pw.TextSpan(
                       children: [
                         pw.TextSpan(
                             text: "$statementOfMonthLbl: \t",style: pw.TextStyle(fontSize: 15,color: PdfColors.black)),
                         pw.TextSpan(text:monthName + "-$year",style: pw.TextStyle(fontSize: 14,fontWeight: pw.FontWeight.bold,color:  PdfColors.black),
                         ),
                       ]
                   )
               ),
               pw.SizedBox(height: 20),
               _buildTable(data),
               pw.SizedBox(height: 40),
               pw.RichText(
                   text: pw.TextSpan(
                       children: [
                         pw.TextSpan(
                             text: totalDebitedLbl,
                             style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)
                         ),
                         pw.TextSpan(text: "$inrLbl ${totalDebited.toStringAsFixed(2).formatWithCommas()}\n",
                             style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold,color:PdfColors.red500)
                         ),
                       ]
                   )
               ),
               pw.SizedBox(height: 20),
               pw.RichText(
                   text: pw.TextSpan(
                       children: [
                         pw.TextSpan(
                             text: totalCreditedLbl,
                             style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)
                         ),
                         pw.TextSpan(text: "$inrLbl ${totalCredited.toStringAsFixed(2).formatWithCommas()}\n",
                             style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold,color:PdfColors.green)
                         ),
                       ]
                   )
               ),
               pw.SizedBox(height: 20),
               pw.RichText(
                   text: pw.TextSpan(
                       children: [
                         pw.TextSpan(
                             text: totalBalanceLbl,
                             style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)
                         ),
                         pw.TextSpan(text: "$inrLbl ${totalBalance.toStringAsFixed(2).formatWithCommas()}\n",
                             style: pw.TextStyle(fontSize: 17, fontWeight: pw.FontWeight.bold,color:PdfColors.blueAccent)

                         ),
                       ]
                   )
               ),
             ],
           )
         ]
       ),
     );

     // Generate a unique filename by appending a counter if necessary
     String? uniqueFileName = await getUniqueFileName('${monthName.toUpperCase()}_statement.pdf');
     File? file;

     // Platform.isIOS comes from dart:io
    /* if (Platform.isIOS) {
       final dir = await getApplicationDocumentsDirectory();
       file = File('${dir.path}/$uniqueFileName');
     } else if (Platform.isAndroid) {
       var status = await Permission.storage.status;
       if (status != PermissionStatus.granted) {
         status = await Permission.storage.request();
       }
       if (status.isGranted) {

       }
     }*/
     const downloadsFolderPath = androidPathLbl;
     Directory dir = Directory(downloadsFolderPath);
     file = File('${dir.path}/$uniqueFileName');
     await file.writeAsBytes(await pdf.save());
     Navigator.of(screenContext).pop();
     return file;
   }catch(err){
     log('Error occurred in generatePDF $err');
   }finally {
     isLoading(false);
   }
  }
// Function to generate a unique filename
  Future<String?> getUniqueFileName(String baseFileName) async {
    int counter = 1;
    try {
      String fileName = baseFileName;

      while (await isFileExists(fileName)) {
            // File with the same name already exists, append counter
            fileName = '${baseFileName.substring(0, baseFileName.lastIndexOf("."))}($counter).${baseFileName.split(".").last}';

            counter++;
          }
      return fileName;
    } catch (err) {
      log('Error occurred in getUniqueFileName $err');
    }
  }

  Future<bool> isFileExists(String fileName) async {
    try {
      final downloadsFolderPath = await getExternalStorageDirectory();//androidPathLbl;
      //final dir = Directory(downloadsFolderPath!.parent.parent.parent.parent);

      final dir = Directory('${downloadsFolderPath!.parent.parent.parent.parent}/Download');
      if (!await dir.exists()) {
        // Handle the case where the directory doesn't exist
        log('Directory $downloadsFolderPath does not exist');
        return false;
      }

      final files = await dir.list().toList();
      log('files $files');
      // Use any() to check if any file has a matching filename
      return files.any((file) => file is File && file.path.endsWith(fileName));
    } catch (err) {
      // Handle errors, log them, and return false
      log('Error occurred in isFileExists $err');
      return false;
    }
  }


  /*pw.Widget _buildTable(List<ViewRecordTileModel> tableData) {
    return pw.TableHelper.fromTextArray(
      headers: ['Date', 'Particulars', 'Type', 'Amount', 'Status', 'Remarks'],
      headerStyle: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
      data: tableData.map((row) => [
                row.transDate.toString(),
                row.transParticular.toString(),
                row.transType.toString(),
                row.transAmount!.formatWithCommas(),
                row.transStatus.toString(),
                row.transRemarks.toString()
              ]).toList(),
    );
  }*/
  pw.Widget _buildTable(List<ViewRecordTileModel> tableData) {
    return pw.Table(
      border: pw.TableBorder.all(),
      columnWidths: {
        0: pw.FlexColumnWidth(2), // Date column
        1: pw.FlexColumnWidth(3), // Particulars column
        2: pw.FlexColumnWidth(2), // Type column
        3: pw.FlexColumnWidth(2), // Amount column
        4: pw.FlexColumnWidth(2), // Status column
        5: pw.FlexColumnWidth(3), // Remarks column
      },
      children: [
        // Header Row
        pw.TableRow(
          decoration: pw.BoxDecoration(color: PdfColors.grey300),
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                dateLbl,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                particularLbl,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                transactionTypeLbl,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                amountLbl,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                statusLbl,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(4),
              child: pw.Text(
                remarksLbl,
                style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ),
          ],
        ),
        // Data Rows
        ...tableData.map(
              (row) => pw.TableRow(
            children: [
              // Date Column
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  row.transDate.toString(),
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              // Particulars Column
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  row.transParticular.toString(),
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              // Type Column
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  row.transType.toString(),
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              // Amount Column with Rupee Symbol and Alignment
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  '${double.tryParse(row.transAmount?.toString() ?? '0')?.toStringAsFixed(2).formatWithCommas() ?? '0.00'}',
                  style: pw.TextStyle(fontSize: 10),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              // Status Column
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  row.transStatus.toString(),
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
              // Remarks Column
              pw.Padding(
                padding: const pw.EdgeInsets.all(4),
                child: pw.Text(
                  row.transRemarks.toString(),
                  style: pw.TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/*class PDFGeneratorController extends GetxController {
  Future<File?> generatePDF(
      BuildContext screenContext,
      String userName,
      String monthName,
      String year,
      double totalDebited,
      double totalCredited,
      double totalBalance,
      List<ViewRecordTileModel> data) async {
    try {
      log('----------$userName \n $monthName \n $year \n $totalDebited\n$totalCredited \n $totalBalance\n $data');
      //WidgetsHelper.onLoading(screenContext,'Downloading,please wait...');
      File? file = await compute(_generatePDFInIsolate, {
        'userName': userName,
        'monthName': monthName,
        'year': year,
        'totalDebited': totalDebited,
        'totalCredited': totalCredited,
        'totalBalance': totalBalance,
        'data': data,
      });
      //Navigator.of(screenContext).pop();
      return file;
    } catch (err) {

      log('error occurred in generatePDF $err');
    } finally {
      log('loader closed in finally');
    }
  }

  Future<File?> _generatePDFInIsolate(Map<String, dynamic> params) async {log('**************${params['userName']} \n ${params['data']}');
    try {
      log('**************${params['userName']} \n ${params['data']}');
      final pdf = pw.Document();
      // Extract parameters
      String userName = params['userName'];
      String monthName = params['monthName'];
      String year = params['year'];
      double totalDebited = params['totalDebited'];
      double totalCredited = params['totalCredited'];
      double totalBalance = params['totalBalance'];
      List<ViewRecordTileModel> data = List.castFrom<dynamic, ViewRecordTileModel>(params['data']);
      log('*****data is ${data.first.transAmount}');
      // Convert data to serializable format
     // List<Map<String, dynamic>> serializedData = data.map((item) => item.toMap()).toList();

      // Add content to the PDF
      final String title = 'Income Transaction Statement';

      DateTime currentDate = DateTime.now();
      String formattedDateTime =
          DateFormat('dd MMM yyyy HH:mm').format(currentDate);

      print(formattedDateTime);
      final imagePathData = await rootBundle.load(AssetsUtils.appIconPng);
      Uint8List imageData = (imagePathData).buffer.asUint8List();

      // Add content to the PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          orientation: pw.PageOrientation.portrait,
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Add the image here
                pw.Container(
                    alignment: pw.Alignment.topLeft,
                    width: 100.0,
                    height: 100.0,
                    child: pw.Image(pw.MemoryImage(imageData))),
                pw.RichText(
                    text: pw.TextSpan(children: [
                  pw.TextSpan(
                      text: title,
                      style: pw.TextStyle(
                          fontSize: 20, fontWeight: pw.FontWeight.bold)),
                  pw.TextSpan(text: "\n"),
                ])),
                pw.SizedBox(height: 10),
                pw.RichText(
                    text: pw.TextSpan(children: [
                  pw.TextSpan(
                      text: "Username: \t\t",
                      style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.black)),
                  pw.TextSpan(
                    text: userName,
                    style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue),
                  ),
                ])),
                pw.SizedBox(height: 10),
                pw.RichText(
                    text: pw.TextSpan(children: [
                  pw.TextSpan(
                      text: "Current Date: \t",
                      style:
                          pw.TextStyle(fontSize: 15, color: PdfColors.black)),
                  pw.TextSpan(
                    text: formattedDateTime,
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black),
                  ),
                ])),
                pw.SizedBox(height: 10),
                pw.RichText(
                    text: pw.TextSpan(children: [
                  pw.TextSpan(
                      text: "Statement of the Month: \t",
                      style:
                          pw.TextStyle(fontSize: 15, color: PdfColors.black)),
                  pw.TextSpan(
                    text: monthName + "-$year",
                    style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black),
                  ),
                ])),
                pw.SizedBox(height: 20),
                _buildTable(data),
                pw.SizedBox(height: 40),
                pw.RichText(
                    text: pw.TextSpan(children: [
                  pw.TextSpan(
                      text: totalDebitedLbl,
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.TextSpan(
                      text:
                          "INR ${totalDebited.toStringAsFixed(2).formatWithCommas()}\n",
                      style: pw.TextStyle(
                          fontSize: 17,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.red500)),
                ])),
                pw.SizedBox(height: 20),
                pw.RichText(
                    text: pw.TextSpan(children: [
                  pw.TextSpan(
                      text: totalCreditedLbl,
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.TextSpan(
                      text:
                          "INR ${totalCredited.toStringAsFixed(2).formatWithCommas()}\n",
                      style: pw.TextStyle(
                          fontSize: 17,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green)),
                ])),
                pw.SizedBox(height: 20),
                pw.RichText(
                    text: pw.TextSpan(children: [
                  pw.TextSpan(
                      text: totalBalanceLbl,
                      style: pw.TextStyle(
                          fontSize: 18, fontWeight: pw.FontWeight.bold)),
                  pw.TextSpan(
                      text:
                          "INR ${totalBalance.toStringAsFixed(2).formatWithCommas()}\n",
                      style: pw.TextStyle(
                          fontSize: 17,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.blueAccent)),
                ])),
              ],
            );
          },
        ),
      );
      // Generate a unique filename by appending a counter if necessary
      String uniqueFileName =
          await getUniqueFileName('${monthName.toUpperCase()}_statement.pdf');
      File? file;

      // Platform.isIOS comes from dart:io
      if (Platform.isIOS) {
        final dir = await getApplicationDocumentsDirectory();
        file = File('${dir.path}/$uniqueFileName');
      } else if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          status = await Permission.storage.request();
        }
        if (status.isGranted) {
          const downloadsFolderPath = androidPathLbl;
          Directory dir = Directory(downloadsFolderPath);
          file = File('${dir.path}/$uniqueFileName');
          await file.writeAsBytes(await pdf.save());
        }
      }
      return file;
    } catch (err) {
      log('error occurred in _generatePDFInIsolate $err');
    }
  }

  // Function to generate a unique filename
  Future<String> getUniqueFileName(String baseFileName) async {
    int counter = 1;
    String fileName = baseFileName;

    while (await isFileExists(fileName)) {
      // File with the same name already exists, append counter
      fileName =
          '${baseFileName.substring(0, baseFileName.lastIndexOf("."))}($counter).${baseFileName.split(".").last}';

      counter++;
    }

    return fileName;
  }

// Function to check if a file exists in the directory
  Future<bool> isFileExists(String fileName) async {
    const downloadsFolderPath = androidPathLbl;
    Directory dir = Directory(downloadsFolderPath);

    final files = await dir.list().toList();

    return files.any((file) => file is File && file.path.endsWith(fileName));
  }

  pw.Widget _buildTable(List<ViewRecordTileModel> tableData) {
    return pw.TableHelper.fromTextArray(
      headers: ['Date', 'Particulars', 'Type', 'Amount', 'Status', 'Remarks'],
      headerStyle: pw.TextStyle(
          fontSize: 15, fontWeight: pw.FontWeight.bold, color: PdfColors.black),
      data: tableData
          .map((row) => [
                row.transDate.toString(),
                row.transParticular.toString(),
                row.transType.toString(),
                row.transAmount!.formatWithCommas(),
                row.transStatus.toString(),
                row.transRemarks.toString()
              ])
          .toList(),
    );
  }
}*/
