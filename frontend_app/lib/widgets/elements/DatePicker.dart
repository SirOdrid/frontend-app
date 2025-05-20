import 'package:flutter/material.dart';

class DateSelectorDropdown extends StatefulWidget {
  final Function(DateTime)? onDateChanged;
  final DateTime? initialDate;
  final String? yearLabel;
  final String? monthLabel;
  final String? dayLabel;

  const DateSelectorDropdown({
    super.key,
    this.onDateChanged,
    this.initialDate,
    this.yearLabel = 'Año',
    this.monthLabel = 'Mes',
    this.dayLabel = 'Día',
  });

  @override
  State<DateSelectorDropdown> createState() => _DateSelectorDropdownState();
}

class _DateSelectorDropdownState extends State<DateSelectorDropdown> {
  late int _selectedYear;
  late int _selectedMonth;
  late int _selectedDay;

  final List<int> _years = [];
  final List<int> _months = List.generate(12, (index) => index + 1);
  late List<int> _days;

  @override
  void initState() {
    super.initState();
    
    final currentYear = DateTime.now().year;
    _years.addAll(List.generate(currentYear - 1949, (index) => currentYear - index));
    
    final initialDate = widget.initialDate ?? DateTime.now();
    _selectedYear = initialDate.year;
    _selectedMonth = initialDate.month;
    _selectedDay = initialDate.day;
    
    _days = _getDaysInMonth(_selectedYear, _selectedMonth);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.onDateChanged != null) {
        widget.onDateChanged!(DateTime(_selectedYear, _selectedMonth, _selectedDay));
      }
    });
  }

  List<int> _getDaysInMonth(int year, int month) {
    final daysInMonth = DateUtils.getDaysInMonth(year, month);
    return List.generate(daysInMonth, (index) => index + 1);
  }

  void _updateDays() {
    final newDays = _getDaysInMonth(_selectedYear, _selectedMonth);
    final newDay = _selectedDay > newDays.length ? newDays.length : _selectedDay;
    
    setState(() {
      _days = newDays;
      _selectedDay = newDay;
    });
    
    _notifyDateChanged();
  }

  void _notifyDateChanged() {
    if (widget.onDateChanged != null) {
      widget.onDateChanged!(DateTime(_selectedYear, _selectedMonth, _selectedDay));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Colors.white),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        dropdownMenuTheme: DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.white),
        ),
      ),
      child: Row(
        children: [
          // Dropdown Año
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedYear,
              decoration: InputDecoration(
                labelText: widget.yearLabel,
                labelStyle: TextStyle(color: Colors.white),
              ),
              dropdownColor: Colors.grey[800], // Fondo del dropdown
              style: TextStyle(color: Colors.white), // Color del texto seleccionado
              items: _years.map((year) {
                return DropdownMenuItem<int>(
                  value: year,
                  child: Text(
                    year.toString(),
                    style: TextStyle(color: Colors.white), // Color items del dropdown
                  ),
                );
              }).toList(),
              onChanged: (value) {
                _selectedYear = value!;
                _updateDays();
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Icono del dropdown
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Dropdown Mes
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedMonth,
              decoration: InputDecoration(
                labelText: widget.monthLabel,
                labelStyle: TextStyle(color: Colors.white),
              ),
              dropdownColor: Colors.grey[800],
              style: TextStyle(color: Colors.white),
              items: _months.map((month) {
                return DropdownMenuItem<int>(
                  value: month,
                  child: Text(
                    month.toString().padLeft(2, '0'),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                _selectedMonth = value!;
                _updateDays();
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Dropdown Día
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedDay,
              decoration: InputDecoration(
                labelText: widget.dayLabel,
                labelStyle: TextStyle(color: Colors.white),
              ),
              dropdownColor: Colors.grey[800],
              style: TextStyle(color: Colors.white),
              items: _days.map((day) {
                return DropdownMenuItem<int>(
                  value: day,
                  child: Text(
                    day.toString().padLeft(2, '0'),
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedDay = value!;
                });
                _notifyDateChanged();
              },
              icon: Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}