import 'package:flutter/material.dart';
import 'package:stock_scan_parser/models/scan.dart';
import 'package:stock_scan_parser/views/parameter_widget.dart';
import 'package:stock_scan_parser/views/values_widget.dart';

class VariableParameterPage extends StatelessWidget {
  const VariableParameterPage(
      {super.key,
      required this.scan,
      required this.criteriaIndex,
      required this.mapKey});

  final Scan scan;
  final int criteriaIndex;
  final String mapKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Variable Parameters'),
      ),
      backgroundColor: const Color(0xFF01131B),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: loadVariableParameterWidget(),
      ),
    );
  }

  Widget loadVariableParameterWidget() {
    if (scan.criteria.elementAt(criteriaIndex).variable![mapKey]['type'] ==
        'value') {
      // debugPrint(scan.criteria.elementAt(criteriaIndex).variable![mapKey]['values'].map((value) => ));
      List<dynamic> dynamicList =
          scan.criteria.elementAt(criteriaIndex).variable![mapKey]['values'];
      List<num> valuesList =
          dynamicList.map((e) => e is num ? e : null).whereType<num>().toList();
      
      valuesList.sort();

      for (num value in valuesList) {
        if (value < 0) {
          valuesList = valuesList.reversed.toList();
          break;
        }
      }

      return ValuesWidget(
        valuesList: valuesList,
      );
    } else {
      return ParameterWidget(
        parameterMap: scan.criteria.elementAt(criteriaIndex).variable![mapKey],
      );
    }
  }
}
