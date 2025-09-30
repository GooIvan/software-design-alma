import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../widgets/custom_alert.dart';

void confirmBox(BuildContext context, {required VoidCallback onConfirm}) {
  const Color azulPrimary = AppColors.primary;

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // barra superior
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icono central
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: azulPrimary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        Icons.logout,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Texto centrado
                  const Text(
                    '¿Estás seguro que deseas cerrar la sesión?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Botones en fila
                  Row(
                    children: [
                      // Botón Cancelar
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade300,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancelar",
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Botón Confirmar
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: azulPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(35),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                            onConfirm();
                            CustomAlert.success(
                                context, "Sesión cerrada correctamente");
                          },
                          child: const Text(
                            "Sí, cerrar sesión",
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            )
          ],
        ),
      );
    },
  );
}
