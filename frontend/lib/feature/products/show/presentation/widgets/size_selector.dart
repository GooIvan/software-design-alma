import 'package:flutter/material.dart';

class SizeSelector extends StatefulWidget {
  final List<String> sizes;
  final ValueChanged<String?> onSizeSelected; // <- Callback al padre

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.onSizeSelected,
  });

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.sizes.map((size) {
        final isSelected = selectedSize == size;

        return ChoiceChip(
          label: Text(size),
          selected: isSelected,
          selectedColor: Colors.blueAccent.withOpacity(0.2),
          checkmarkColor: Colors.blueAccent,
          labelStyle: TextStyle(
            color: isSelected ? Colors.blueAccent : Colors.black,
            fontWeight: FontWeight.bold,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: isSelected ? Colors.blueAccent : Colors.grey.shade400,
            ),
          ),
          onSelected: (selected) {
            setState(() {
              selectedSize = selected ? size : null;
            });
            widget.onSizeSelected(selectedSize); // Notificar al padre
          },
        );
      }).toList(),
    );
  }
}
