import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../../../widgets/mapa_lbre.dart';

class SeccionMap extends StatelessWidget {
  const SeccionMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.whereWeAreLocated,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.displayLarge?.color,
                ),
              ),
              Text(
                "Calle 45 # 78B - 50, Soledad, Colombia",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: MapaLibreWidget(
            ubicacion: LatLng(10.919550, -74.801119),
            height: 250,
          ),
        ),
      ],
    );
  }
}
