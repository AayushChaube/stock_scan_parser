import 'package:flutter/material.dart';

class ValuesWidget extends StatelessWidget {
  const ValuesWidget({super.key, required this.valuesList});

  final List<num> valuesList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: valuesList.length,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                valuesList.elementAt(index).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            ),
            const Divider(
              thickness: 0.800,
              color: Color(0xFFECECEC),
              indent: 1,
              endIndent: 1,
            ),
          ],
        );
      },
    );
  }
}
