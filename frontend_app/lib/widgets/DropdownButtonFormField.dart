import 'package:flutter/material.dart';

class StandardDropdownButtonFormField extends StatefulWidget {
  final String labelText;
  final String? value;
  final ValueChanged<String?> onChanged;
  final List<DropdownMenuItem<String>> items;

  const StandardDropdownButtonFormField({
    super.key,
    required this.labelText,
    required this.value,
    required this.onChanged,
    required this.items,
  });

   @override
  State<StandardDropdownButtonFormField> createState() => _StandardDropdownButtonFormFieldState();
}

class _StandardDropdownButtonFormFieldState extends State<StandardDropdownButtonFormField> {
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
      child: DropdownButtonFormField<String>(
        value: widget.value,
        onChanged: widget.onChanged,
        items: widget.items,
        dropdownColor: Colors.grey[800], // Fondo del dropdown
        style: TextStyle(color: Colors.white),
        icon: Icon(Icons.arrow_drop_down, color: Colors.white),
        selectedItemBuilder: (BuildContext context) {
          return widget.items.map<Widget>((DropdownMenuItem<String> item) {
            return Text(
              item.value ?? '',
              style: const TextStyle(
                color: Colors.white, // Texto del ítem seleccionado en blanco
                fontSize: 16,
              ),
            );
          }).toList();
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
          hintStyle: const TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
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