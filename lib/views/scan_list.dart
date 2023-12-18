import 'package:flutter/material.dart';
import 'package:stock_scan_parser/views/sub_criteria_page.dart';

import '../models/scan.dart';

class ScansList extends StatefulWidget {
  const ScansList({super.key, required this.title, required this.scans});

  final String title;
  final List<Scan> scans;

  @override
  State<ScansList> createState() => _ScansListState();
}

class _ScansListState extends State<ScansList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ListView.builder(
        itemCount: widget.scans.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                debugPrint(
                    'Clicked on ID:  ${widget.scans.elementAt(index).id}');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCriteriaPage(
                        scan: widget.scans.elementAt(index),
                      ),
                    ));
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        widget.scans.elementAt(index).name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        widget.scans.elementAt(index).tag,
                        style: TextStyle(
                          color: tagTextColor(index),
                          fontSize: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  thickness: 0.800,
                  color: Color(0xFFECECEC),
                  indent: 1,
                  endIndent: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color tagTextColor(int index) {
    if (widget.scans.elementAt(index).color.toLowerCase() == 'green') {
      return const Color(0xFF34B71F);
    } else if (widget.scans.elementAt(index).color.toLowerCase() == 'red') {
      return const Color(0xFFF3392F);
    } else {
      return Colors.white;
    }
  }
}
