import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../feature/cart/data/bloc/cart_bloc.dart';
import '../routes/routes.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.white,
            Theme.of(context).appBarTheme.backgroundColor ?? Colors.white
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              16, 16, 16, 12), // Reducido de 20,16,20,16 a 16,12,16,12
          child: Row(
            children: [
              // Avatar de usuario circular
              Image.asset(
                'assets/logo.png',
                height: 200, // Tamaño grande como en tu código original
                fit: BoxFit.contain,
                color: Colors.black,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      FeatherIcons.user,
                      color: Colors.grey.shade600,
                      size: 35,
                    ),
                  );
                },
              ),
              const SizedBox(width: 12), // Reducido de 16 a 12

              // Campo de búsqueda mejorado
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor ??
                        Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: Theme.of(context).dividerColor, width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FeatherIcons.search,
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: context.l10n.explore,
                            hintStyle: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium?.color,
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12), // Reducido de 16 a 12

              // Icono de carrito con badge mejorado
              BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).dividerColor,
                              width: 1.5),
                          color:
                              Theme.of(context).appBarTheme.backgroundColor ??
                                  Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoute.cart);
                          },
                          icon: Icon(
                            FeatherIcons.shoppingBag,
                            color:
                                Theme.of(context).textTheme.bodyMedium?.color,
                            size: 22,
                          ),
                        ),
                      ),
                      if (state.totalItems > 0)
                        Positioned(
                          right: -2,
                          top: -2,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF29B6F6),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF29B6F6).withOpacity(0.3),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 20,
                              minHeight: 20,
                            ),
                            child: Text(
                              '${state.totalItems}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100.0);
}
