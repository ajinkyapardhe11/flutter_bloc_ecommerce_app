import 'package:flutter/material.dart';

class QuantitySelector extends StatelessWidget {
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const QuantitySelector({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  void _increase() {
    if (value < max) {
      onChanged(value + 1);
    }
  }

  void _decrease() {
    if (value > min) {
      onChanged(value - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: _decrease,
          icon: const Icon(Icons.remove),
        ),
        Text(
          value.toString(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        IconButton(
          onPressed: _increase,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
