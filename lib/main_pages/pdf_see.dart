import 'package:easy_pdf_viewer/easy_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class Pdfvv extends StatefulWidget {
  String pu; //Link of pdf
  String name; //Name of AppBar
  Pdfvv({super.key, required this.pu, required this.name});

  @override
  State<Pdfvv> createState() => _PdfvvState();
}

class _PdfvvState extends State<Pdfvv> {
  bool _isLoading = true;
  late PDFDocument document;

  @override
  void initState() {
    loadDocument();
    super.initState();
    loadDocument();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.pu);
    _isLoading = false;
    setState(() {
      _isLoading = false;
    });
  }
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: _isLoading
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text("Downloading your whole Pdf")
              ],
            ))
          : PDFViewer(
              document: document, scrollDirection: Axis.horizontal,
              lazyLoad: false,
              zoomSteps: 1,
              numberPickerConfirmWidget: const Text(
                "Go to this Page",
              ),
        navigationBuilder:
            (context, page, totalPages, jumpToPage, animateToPage) {
          return ButtonBar(
            alignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.first_page),
                onPressed: () {
                  jumpToPage(page : 0);
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  animateToPage(page: page! - 2);
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                onPressed: () {
                  animateToPage(page: page);
                },
              ),
              IconButton(
                icon: Icon(Icons.last_page),
                onPressed: () {
                  jumpToPage(page: totalPages! - 1);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
