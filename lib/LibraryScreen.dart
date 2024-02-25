
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class LibraryScreens extends StatelessWidget {
  final List<String> unitPdfUrls = [
    'https://firebasestorage.googleapis.com/v0/b/hound-s.appspot.com/o/eee%201.pdf?alt=media&token=ad298036-ed6b-465d-a531-334c4b1d2aa0',
    'https://firebasestorage.googleapis.com/v0/b/hound-s.appspot.com/o/UNIT%201.pdf?alt=media&token=661de83c-f6fd-4e97-8cd0-73cbecd04533',
    // Add other PDF URLs for other units if needed
  ];

   LibraryScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Library', style: TextStyle(color: Colors.white)), 
        backgroundColor:const Color.fromARGB(255, 85, 0, 221),
      ),
      body: ListView.builder(
        itemCount: unitPdfUrls.length,
        itemBuilder: (context, index) {
          return buildUnitButton(context, index);
        },
      ),
    );
  }

  Widget buildUnitButton(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        _openPdf(context, unitPdfUrls[index]);
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(        
                'Unit ${index + 1}',
                style:const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
               const Icon(
                Icons.picture_as_pdf,
                size: 30,
                color:Color.fromARGB(255, 85, 0, 221),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openPdf(BuildContext context, String pdfUrl) async {
    try {
      final fileName = pdfUrl.split('/').last;
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';

      final response = await HttpClient().getUrl(Uri.parse(pdfUrl));
      final HttpClientResponse downloadedFile = await response.close();

      final File file = File(filePath);
      final List<int> bytes = <int>[];
      await downloadedFile.forEach((List<int> chunk) {
        bytes.addAll(chunk);
      });
      await file.writeAsBytes(bytes);

      Navigator.push(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewPage(pdfPath: filePath),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
       const SnackBar(
          content: Text('Could not open PDF'),
        ),
      );
    }
  }
}

class PdfViewPage extends StatelessWidget {
  final String pdfPath;

    const PdfViewPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('PDF Viewer'),
        backgroundColor:const Color.fromARGB(255, 85, 0, 221),
      ),
      body: PDFView(
        filePath: pdfPath,
        pageFling: true,
      ),
    );
  }
}
