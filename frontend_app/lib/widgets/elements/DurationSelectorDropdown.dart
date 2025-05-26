import 'package:flutter/material.dart';

class DurationSelectorDropdown extends StatefulWidget {
  final Function(Duration)? onDurationChanged;
  final Duration? initialDuration;
  final String? hourLabel;
  final String? minuteLabel;
  final String? secondLabel;

  const DurationSelectorDropdown({
    super.key,
    this.onDurationChanged,
    this.initialDuration,
    this.hourLabel = 'Horas',
    this.minuteLabel = 'Minutos',
    this.secondLabel = 'Segundos',
  });

  @override
  State<DurationSelectorDropdown> createState() => _DurationSelectorDropdownState();
}

class _DurationSelectorDropdownState extends State<DurationSelectorDropdown> {
  late int _selectedHour;
  late int _selectedMinute;
  late int _selectedSecond;

  final List<int> _hours = List.generate(24, (index) => index);
  final List<int> _multiplesOf5 = List.generate(12, (index) => index * 5); // 0–55

  @override
  void initState() {
    super.initState();

    final initial = widget.initialDuration ?? Duration.zero;
    _selectedHour = initial.inHours.clamp(0, 23);
    _selectedMinute = _roundToNearestMultipleOf5(initial.inMinutes.remainder(60));
    _selectedSecond = _roundToNearestMultipleOf5(initial.inSeconds.remainder(60));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notifyDurationChanged();
    });
  }

  int _roundToNearestMultipleOf5(int value) {
    return (value / 5).round() * 5;
  }

  void _notifyDurationChanged() {
    final duration = Duration(
      hours: _selectedHour,
      minutes: _selectedMinute,
      seconds: _selectedSecond,
    );
    if (widget.onDurationChanged != null) {
      widget.onDurationChanged!(duration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: const InputDecorationTheme(
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
        dropdownMenuTheme: const DropdownMenuThemeData(
          textStyle: TextStyle(color: Colors.white),
        ),
      ),
      child: Row(
        children: [
          // Horas
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedHour,
              decoration: InputDecoration(labelText: widget.hourLabel),
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white),
              items: _hours.map((hour) {
                return DropdownMenuItem<int>(
                  value: hour,
                  child: Text(hour.toString().padLeft(2, '0')),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedHour = value!;
                });
                _notifyDurationChanged();
              },
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ),

          const SizedBox(width: 10),

          // Minutos
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedMinute,
              decoration: InputDecoration(labelText: widget.minuteLabel),
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white),
              items: _multiplesOf5.map((minute) {
                return DropdownMenuItem<int>(
                  value: minute,
                  child: Text(minute.toString().padLeft(2, '0')),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedMinute = value!;
                });
                _notifyDurationChanged();
              },
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ),

          const SizedBox(width: 10),

          // Segundos
          Expanded(
            child: DropdownButtonFormField<int>(
              value: _selectedSecond,
              decoration: InputDecoration(labelText: widget.secondLabel),
              dropdownColor: Colors.grey[800],
              style: const TextStyle(color: Colors.white),
              items: _multiplesOf5.map((second) {
                return DropdownMenuItem<int>(
                  value: second,
                  child: Text(second.toString().padLeft(2, '0')),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedSecond = value!;
                });
                _notifyDurationChanged();
              },
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
