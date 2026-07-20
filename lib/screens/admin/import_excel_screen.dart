import 'package:flutter/material.dart';

class ImportExcelScreen extends StatelessWidget {
  const ImportExcelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Import Excel"),
      ),
      body: const Center(
        child: Text(
          "Import Subjects & Topics\nComing Soon",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}