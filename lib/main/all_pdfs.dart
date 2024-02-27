
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DownloadedPDF extends StatefulWidget {
  const DownloadedPDF({super.key});

  @override
  State<DownloadedPDF> createState() => _DownloadedPDFState();
}


class _DownloadedPDFState extends State<DownloadedPDF> {
  List<String> _downloadedPDFs = []; // Initialize with an empty list
  bool _isLoading = true; // Flag to track whether PDFs are being fetched

  @override
  void initState() {
    super.initState();
    _getDownloadedFiles(); // Call _getDownloadedPDFs() directly
  }

  Future<void> _getDownloadedFiles() async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final files = Directory(appDocDir.path).listSync();

      setState(() {
        _downloadedPDFs = files
            .where((file) => file is File)
            .map((file) => file.path)
            .toList();
        _isLoading = false; // Set isLoading to false once files are fetched
      });
    } catch (e) {
      print('Error fetching downloaded files: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Downloaded PDFs'),
      ),
      body: _isLoading ? _buildLoadingIndicator() : _buildPDFListView(),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildPDFListView() {
    if (_downloadedPDFs.isEmpty) {
      return Center(
        child: Text("No PDFs Downloaded"),
      );
    } else {
      return ListView.builder(
        itemCount: _downloadedPDFs.length,
        itemBuilder: (context, index) {
          return ListTile(
            tileColor: Colors.grey.shade50,
            leading: Icon(Icons.picture_as_pdf, color: Colors.red,),
            title: Text( a(_downloadedPDFs[index].split('/').last), maxLines: 1,),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewerScreen(pdfPath : _downloadedPDFs[index], name :  a(_downloadedPDFs[index].split('/').last)),
                ),
              );
            },
          );
        },
      );
    }
  }
  String a(String text){
    String textWithSpaces = text.replaceAll('%20', ' ');
    textWithSpaces = textWithSpaces.replaceAll('%26', ' ');
    textWithSpaces = textWithSpaces.replaceAll('.pdf', ' ');
    textWithSpaces = textWithSpaces.replaceAll('?', ' ');
    return textWithSpaces ;
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String pdfPath;
  String name ;
  PDFViewerScreen({required this.pdfPath, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: SfPdfViewer.file(File(pdfPath)),
    );
  }
}