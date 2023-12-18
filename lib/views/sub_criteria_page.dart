import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stock_scan_parser/models/scan.dart';
import 'package:stock_scan_parser/views/variable_parameter_page.dart';

class SubCriteriaPage extends StatefulWidget {
  const SubCriteriaPage({super.key, required this.scan});

  final Scan scan;

  @override
  State<SubCriteriaPage> createState() => _SubCriteriaPageState();
}

class _SubCriteriaPageState extends State<SubCriteriaPage> {
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < widget.scan.criteria.length; i++) {
      widgets.add(subCriteriaRow(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sub-criteria'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Container(
              // height: 60.0,
              padding: const EdgeInsets.all(10.0),
              color: const Color(0xFF1686B0),
              constraints: const BoxConstraints(
                minHeight: 60.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.scan.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    widget.scan.tag,
                    style: TextStyle(
                      color: tagTextColor(),
                      fontSize: 10.0,
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: widgets,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF01131B),
    );
  }

  Color tagTextColor() {
    if (widget.scan.color.toLowerCase() == 'green') {
      return const Color(0xFF34B71F);
    } else if (widget.scan.color.toLowerCase() == 'red') {
      return const Color(0xFFF3392F);
    } else {
      return Colors.white;
    }
  }

  Widget subCriteriaRow(int i) {
    if (widget.scan.criteria.elementAt(i).type == 'plain_text') {
      if (i < widget.scan.criteria.length - 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.scan.criteria.elementAt(i).text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              'and',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.scan.criteria.elementAt(i).text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        );
      }
    } else {
      String subCriteriaText = widget.scan.criteria.elementAt(i).text;
      Map<String, dynamic> variableValueMap = {};

      widget.scan.criteria.elementAt(i).variable!.forEach((key, value) {
        if (value['type'] == 'value') {
          variableValueMap[key] = (value['values'] as List).first;
        } else {
          variableValueMap[key] = value['default_value'];
        }
      });

      variableValueMap.forEach((key, value) {
        subCriteriaText =
            subCriteriaText.replaceAll(key, '(${value.toString()})');
      });

      if (i < widget.scan.criteria.length - 1) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            richTextRow(
              index: i,
              text: widget.scan.criteria.elementAt(i).text,
              valueParameterMap: variableValueMap,
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              'and',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.0,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            richTextRow(
              index: i,
              text: widget.scan.criteria.elementAt(i).text,
              valueParameterMap: variableValueMap,
            ),
            const SizedBox(
              height: 10.0,
            ),
          ],
        );
      }
    }
  }

  Widget richTextRow(
      {required int index,
      required String text,
      required Map<String, dynamic> valueParameterMap}) {
    int currentPos = 0;
    List<TextSpan> textSpans = [];

    final RegExp regex = RegExp(r'\$[0-9]+');
    Iterable<Match> matches = regex.allMatches(text);

    for (Match match in matches) {
      final String matchText = match.group(0)!;

      textSpans.add(TextSpan(
        text: text.substring(currentPos, match.start),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ));
      textSpans.add(TextSpan(
        text: '(${valueParameterMap[matchText]})',
        style: const TextStyle(
          color: Color(0xFF0000EE),
          fontSize: 16.0,
          decoration: TextDecoration.underline,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            debugPrint("Navigate to next page with value: $matchText");
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VariableParameterPage(
                    scan: widget.scan,
                    criteriaIndex: index,
                    mapKey: matchText,
                  ),
                ));
          },
      ));

      currentPos = match.end;
    }

    textSpans.add(TextSpan(
      text: text.substring(currentPos),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16.0,
      ),
    ));

    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
        children: textSpans,
      ),
    );
  }
}
