import 'package:flutter/material.dart';

class SizeSelector extends StatefulWidget {
  final List<String> sizes;
  const SizeSelector({super.key, required this.sizes});

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  final List<String> selectedSizes = [];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: widget.sizes.map((size) {
        final isSelected = selectedSizes.contains(size);

        return FilterChip(
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
              if (selected) {
                selectedSizes.add(size);
              } else {
                selectedSizes.remove(size);
              }
            });
          },
        );
      }).toList(),
    );
  }
}
