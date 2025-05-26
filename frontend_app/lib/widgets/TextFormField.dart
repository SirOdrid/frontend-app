import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StandardTextFormField extends StatefulWidget {
  final String labelText;
  final String hintText;
  final bool obscureText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final bool onlyNumbers;

  const StandardTextFormField({
    super.key,
    required this.labelText,
    required this.hintText,
    required this.obscureText,
    this.onSaved,
    this.validator,
    required this.onlyNumbers,
  });

  @override
  State<StandardTextFormField> createState() => _StandardTextFormFieldState();
}

class _StandardTextFormFieldState extends State<StandardTextFormField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {}); // Para redibujar cuando cambia el foco
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isFocused = _focusNode.hasFocus;

    return Padding(
      padding: const EdgeInsets.only(left: 50.0, right: 50.0),
      child: TextFormField(
        obscureText: widget.obscureText,
        focusNode: _focusNode,
        style: const TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        onSaved: widget.onSaved,
        validator: widget.validator,
        inputFormatters: widget.onlyNumbers
          ? <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
            ]
          : null,
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 34, 214, 10)),
          hintStyle: const TextStyle(color: Color.fromARGB(179, 255, 255, 255)),
          filled: true,
          fillColor: isFocused
              ? const Color.fromARGB(255, 60, 43, 148) // Morado cuando está enfocado
              : const Color.fromARGB(255, 43, 31, 105), // Color base cuando no lo está
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 21, 15, 51),
              width: 3,
              ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: Color(0xFF6236FF), // Borde morado al enfocar
              width: 3,
            ),
          ),
        ),
      ),
    );
  }
}