import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/scan.dart';
import '../services/network.dart';
import 'scan_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Scan>>(
        future: fetchStocksData(
          context: context,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occured!'),
            );
          } else if (snapshot.hasData) {
            return ScansList(
              title: title,
              scans: snapshot.data!,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      backgroundColor: const Color(0xFF01131B),
    );
  }

  Future<List<Scan>> fetchStocksData({required BuildContext context}) async {
    late List<Scan> scanList;

    if (await checkInternet()) {
      try {
        final response = await getDio().get('/data.json').catchError((onError) {
          const snackBar = SnackBar(
            content: Text('Error'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });

        if (response.statusCode == 200) {
          scanList =
              List<Scan>.from(response.data.map((x) => Scan.fromJson(x)));
          debugPrint('Staus Code:  ${response.statusCode}');
          debugPrint('Length:  ${scanList.length}');
        } else {
          debugPrint('Staus Code:  ${response.statusCode}');
          const snackBar = SnackBar(
            content: Text('Not 200'),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } on DioException {
        debugPrint('ERROR');
        const snackBar = SnackBar(
          content: Text('DioException'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      debugPrint('No Internet');
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text('No Internet'),
          content: const Text(
              'Internet is required. Please ensure internet is provided. Pressing "Okay" closes the app.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
                SystemNavigator.pop();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }

    return scanList;
  }
}
