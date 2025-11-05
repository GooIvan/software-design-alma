import 'package:flutter/material.dart';

class SizeSelector extends StatelessWidget {
  final List<String> sizes;
  final ValueNotifier<String?> selectedSizeNotifier;
  final ValueChanged<String?> onSizeSelected;

  const SizeSelector({
    super.key,
    required this.sizes,
    required this.selectedSizeNotifier,
    required this.onSizeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedSizeNotifier,
      builder: (context, selectedSize, _) {
        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: sizes.map((size) {
            final isSelected = selectedSize == size;

            return ChoiceChip(
              label: Text(size),
              selected: isSelected,
              selectedColor: Colors.blueAccent.withOpacity(0.2),
              checkmarkColor: Colors.blueAccent,
              labelStyle: TextStyle(
                color: isSelected
                    ? Colors.blueAccent
                    : Theme.of(context).textTheme.displayLarge?.color,
                fontWeight: FontWeight.w400,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: isSelected
                      ? Colors.blueAccent
                      : Theme.of(context).dividerColor,
                ),
              ),
              onSelected: (selected) {
                final newSize = selected ? size : null;
                selectedSizeNotifier.value =
                    newSize; // ✅ actualiza ValueNotifier
                onSizeSelected(newSize); // ✅ notifica al padre
              },
            );
          }).toList(),
        );
      },
    );
  }
}
