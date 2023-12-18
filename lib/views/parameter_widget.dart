import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ParameterWidget extends StatefulWidget {
  const ParameterWidget({super.key, required this.parameterMap});

  final Map<String, dynamic> parameterMap;

  @override
  State<ParameterWidget> createState() => _ParameterWidgetState();
}

class _ParameterWidgetState extends State<ParameterWidget> {
  // final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double minimumValue = 0.0;
    double maximumValue = 0.0;

    try {
      minimumValue = double.parse(widget.parameterMap['min_value'].toString());
      maximumValue = double.parse(widget.parameterMap['max_value'].toString());
    } catch (e) {
      debugPrint('Error parsing double value:  $e');
    }
    debugPrint(
        'Default Value:  ${widget.parameterMap['default_value'].toString()}');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.parameterMap['study_type'].toString().toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        const Text(
          'Set Parameters',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(10.0),
          constraints: const BoxConstraints(minHeight: 60.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.parameterMap['parameter_name']
                          .toString()[0]
                          .toUpperCase() +
                      widget.parameterMap['parameter_name']
                          .toString()
                          .toLowerCase()
                          .substring(1),
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                  ),
                ),
                TextFormField(
                  // controller: _controller,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    FilteringTextInputFormatter.allow(RegExp('[0-9.-]'))
                  ],
                  textInputAction: TextInputAction.done,
                  onChanged: (value) {
                    if (_formKey.currentState != null) {
                      _formKey.currentState!.validate();
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.600,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  onTapOutside: (event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  initialValue: widget.parameterMap['default_value'].toString(),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a value';
                    }

                    final double? enteredValue = double.tryParse(value);

                    if (enteredValue == null) {
                      return 'Please enter a valid number';
                    }
                    if (enteredValue < minimumValue || enteredValue > maximumValue) {
                      return 'Value must be between $minimumValue and $maximumValue';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // @override
  // void dispose() {
  //   _controller.dispose();
  //   super.dispose();
  // }
}
