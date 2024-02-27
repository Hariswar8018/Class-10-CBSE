import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:http/http.dart' as http ;
import 'package:flutter_media_downloader/flutter_media_downloader.dart';

class PdfV extends StatefulWidget {
  String pu ; //Link of pdf
  String name ; //Name of AppBar
  PdfV({super.key, required this.pu, required this.name});

  @override
  State<PdfV> createState() => _PdfVState();
}

class _PdfVState extends State<PdfV> {
  late PdfViewerController _pdfViewerController;
  late PdfTextSearchResult _searchResult;

  late File? _localFile;

  final _flutterMediaDownloaderPlugin = MediaDownload();

  Future<void> _initLocalFile() async {
    try {
      String fileName = widget.pu.split('/').last;
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String appDocPath = appDocDir.path;
      final String filePath = '$appDocPath/$fileName';
      final File file = File(filePath);
      final bool exists = await file.exists();
      print(exists);

      if (!exists) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text('Download started !'),
          duration: const Duration(seconds: 5),
        ));
        // File doesn't exist, download it
        final response = await http.get(Uri.parse(widget.pu));
        if (response.statusCode == 200) {
          await file.writeAsBytes(response.bodyBytes);
          setState(() {
            _localFile = file;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Downloaded'),
            duration: const Duration(seconds: 5),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text('Failed to download ! Please check Internet '),
            duration: const Duration(seconds: 5),
          ));
          throw Exception('Failed to download PDF file');
        }
      } else {
        // File exists locally, use it
        setState(() {
          _localFile = file;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text('Undefined Error'),
        duration: const Duration(seconds: 5),
      ));
      print('Error downloading PDF: $e');
    }
  }

  TextEditingController ud = TextEditingController();
  @override
  void initState() {
    _pdfViewerController = PdfViewerController();
    _initLocalFile();
    _searchResult = PdfTextSearchResult();
    super.initState();
    setState((){

    });
  }

  bool scroll = true ;
  bool status = false ;
  bool page = false ;
  bool single = false ;
  bool horiz = false ;
  bool tap = false ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.name),
        actions: <Widget>[
          Container(
            width : 100,
            child: TextFormField(
              controller: ud,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                labelText: "Search ",
                hintStyle: TextStyle( color : Colors.black, fontWeight: FontWeight.w100),
                labelStyle: TextStyle( color : Colors.black),
                fillColor: Colors.grey,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Set border color to black
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black), // Set focused border color to black
                ),
                border: OutlineInputBorder(),
                isDense: true,
                isCollapsed: true,
              ),
              onFieldSubmitted: (value) {
                // Called when the user submits the form input
                setState(() {
                  _searchResult = _pdfViewerController.searchText(value) ;
                });
                _searchResult = _pdfViewerController.searchText(value);
                _searchResult.addListener(() {
                  if (_searchResult.hasResult) {
                    setState(() {

                    });
                  }
                });
              },
              onChanged: (value){
                _searchResult = _pdfViewerController.searchText(ud.text);
                _searchResult.addListener(() {
                  if (_searchResult.hasResult) {
                    setState(() {});
                  }
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please type It';
                }
                return null;
              },
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
            onPressed: () {
              _searchResult = _pdfViewerController.searchText(ud.text);
              _searchResult.addListener(() {
                if (_searchResult.hasResult) {
                  setState(() {});
                }
              });
            },
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _searchResult.clear();
                });
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_up,
                color: Colors.black,
              ),
              onPressed: () {
                _searchResult.previousInstance();
              },
            ),
          ),
          Visibility(
            visible: _searchResult.hasResult,
            child: IconButton(
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
              onPressed: () {
                _searchResult.nextInstance();
              },
            ),
          ),
        ],
      ),
      body: _localFile != null ?
      Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SfPdfViewer.file(
            _localFile!,
          controller: _pdfViewerController,
          canShowScrollHead: scroll,
          canShowScrollStatus: status,
          canShowPaginationDialog: page,
          pageLayoutMode: single ?  PdfPageLayoutMode.single : PdfPageLayoutMode.continuous,
          scrollDirection: horiz ? PdfScrollDirection.horizontal : PdfScrollDirection.vertical,
          enableDoubleTapZooming: tap,
          currentSearchTextHighlightColor: Colors.yellow.withOpacity(0.6),
          otherSearchTextHighlightColor: Colors.yellow.withOpacity(0.3),
        ),
      ) : Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: CircularProgressIndicator(),
          ),
          Text("Please wait ! We are downloading the Pdf for you"),
        ],
      ),
      floatingActionButton: TextButton.icon(
          onPressed: () async {
            await Permission.storage.request();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Starting Download"),
              ),
            );
            _flutterMediaDownloaderPlugin.downloadMedia(context, widget.pu);
          }, icon: Icon(Icons.download), label: Text("Save to Phone"),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white), // Change the color here
        ),
      ),
      persistentFooterButtons: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(onPressed: (){
              setState(() {
                scroll = !scroll ;
              });
            }, icon: Icon(Icons.mouse, color : scroll ? Colors.blueAccent : Colors.grey)),
            IconButton(onPressed: (){
              setState(() {
                status = !status ;
              });
            }, icon: Icon(Icons.format_line_spacing, color : status ? Colors.blueAccent : Colors.grey)),
            IconButton(onPressed: (){
              setState(() {
                single = !single ;
              });
            }, icon: Icon(Icons.contact_page, color : single ? Colors.blueAccent : Colors.grey)),
            IconButton(onPressed: (){
              setState(() {
                horiz = !horiz ;
              });
            }, icon: Icon(Icons.horizontal_distribute  , color : horiz ? Colors.blueAccent : Colors.grey)),
            IconButton(onPressed: (){
              setState(() {
                tap = !tap ;
              });
            }, icon: Icon(Icons.zoom_in_map, color : tap ? Colors.blueAccent : Colors.grey)),
          ],
        )
      ],
    );
  }
}
