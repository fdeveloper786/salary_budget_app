import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';

class PdfViewer extends StatefulWidget {
  final String pdfPath;

  PdfViewer({required this.pdfPath});

  @override
  _PdfViewerState createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PDFViewController pdfController;
  List<String> pdfPaths = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Viewer'),
      ),
      body: PDFView(
        filePath: widget.pdfPath,
        onViewCreated: (controller) {
          setState(() {
            pdfController = controller;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add any additional functionality when the FAB is pressed
          sharePdf(widget.pdfPath);
        },
        child: Icon(Icons.share), // Change the icon as needed
      ),
    );
  }

  // Function to share the PDF file using share_plus
  void sharePdf(String filePath) async {
    File file = File(filePath);
    pdfPaths.add(file.path);
    if (pdfPaths.isNotEmpty) {
      final files = <XFile>[];
      for (int i = 0; i < pdfPaths.length; i++) {
        files.add(XFile(pdfPaths[i], name: 'Transaction Statement'));
      }
      await Share.shareXFiles(files, text: 'Share statement');
    }
  }
}
