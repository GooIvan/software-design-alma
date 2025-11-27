import 'package:design_alma/utils/extensions.dart';
import 'package:flutter/material.dart';
import '../../../../../../models/user_model.dart';

class UsersSuccessView extends StatefulWidget {
  final List<User> users;
  final Future<void> Function()? onRefresh;

  const UsersSuccessView({
    super.key,
    required this.users,
    this.onRefresh,
  });

  @override
  State<UsersSuccessView> createState() => _UsersSuccessViewState();
}

class _UsersSuccessViewState extends State<UsersSuccessView> {
  void _resetFilters() {
    setState(() {
      _roleFilter = context.l10n.all;
      _cityFilter = context.l10n.all;
      _searchFilter = '';
    });
  }

  late String _roleFilter;
  late String _cityFilter;
  String _searchFilter = '';
  bool _didInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInit) {
      _roleFilter = context.l10n.all;
      _cityFilter = context.l10n.all;
      _didInit = true;
    }
  }

  Color _roleColor(String role) {
    if (role.toLowerCase() == 'admin') {
      return Colors.redAccent.shade400;
    }
    return Colors.green.shade600;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final String allLabel = context.l10n.all;
    final Set<String> roles = {
      allLabel,
      ...widget.users
          .map((u) => (u.role ?? 'customer').toLowerCase())
          .map((r) => r[0].toUpperCase() + r.substring(1))
          .where((r) => r != allLabel),
    };
    final Set<String> cities = {
      allLabel,
      ...widget.users
          .map((u) => (u.city ?? '').trim())
          .where((c) => c.isNotEmpty)
          .map((c) => c[0].toUpperCase() + c.substring(1))
          .where((c) => c != allLabel),
    };

    final filtered = widget.users.where((u) {
      final role = (u.role ?? 'customer').toLowerCase();
      final city = (u.city ?? '').toLowerCase();
      final search = _searchFilter.toLowerCase();

      final matchRole = _roleFilter == context.l10n.all
          ? true
          : role == _roleFilter.toLowerCase();

      final matchCity = _cityFilter == context.l10n.all
          ? true
          : city == _cityFilter.toLowerCase();

      final matchSearch = search.isEmpty
          ? true
          : u.name?.toLowerCase().contains(search) == true ||
              u.email.toLowerCase().contains(search);

      return matchRole && matchCity && matchSearch;
    }).toList();

    return RefreshIndicator(
      color: Theme.of(context).textTheme.displayLarge?.color,
      onRefresh: widget.onRefresh ?? () async {},
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          const SizedBox(height: 16),

          // ------------------------
          // 🔎 FILTRO
          // ------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ---- FILTRO DE BÚSQUEDA ----
                Text(context.l10n.searchUsersByNameOrEmail,
                    style: theme.textTheme.bodyMedium!
                        .copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    prefixIconColor: Colors.grey,
                  ),
                  onChanged: (v) => setState(() => _searchFilter = v),
                  controller: TextEditingController(text: _searchFilter),
                ),

                const SizedBox(height: 14),

                Row(
                  children: [
                    // ---- FILTRO DE ROL ----
                    Expanded(
                      child: _comboBox(
                        label: 'Rol',
                        value: _roleFilter,
                        items: roles,
                        onChanged: (v) => setState(() => _roleFilter = v!),
                      ),
                    ),
                    const SizedBox(width: 10),

                    // ---- FILTRO DE CIUDAD ----
                    Expanded(
                      child: _comboBox(
                        label: 'Ciudad',
                        value: _cityFilter,
                        items: cities,
                        onChanged: (v) => setState(() => _cityFilter = v!),
                      ),
                    ),
                  ],
                ),

                // Botón para resetear filtros
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _resetFilters,
                    icon: Icon(Icons.refresh,
                        size: 18, color: Colors.grey.shade400),
                    label: Text(
                      context.l10n.resetFilters,
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          if (filtered.isEmpty)
            Center(
              child: Text(
                context.l10n.noUsersFound,
                style: theme.textTheme.bodyMedium,
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final user = filtered[index];
                final roleColor = user.role != null
                    ? _roleColor(user.role!)
                    : Colors.green.shade600;

                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        offset: const Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Avatar
                          Container(
                            width: 58,
                            height: 58,
                            padding: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: roleColor,
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundColor: roleColor.withOpacity(.15),
                              child: Icon(
                                Icons.person,
                                size: 28,
                                color: roleColor,
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name ?? "-",
                                  style: theme.textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  user.email,
                                  style: theme.textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context).disabledColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: [
                                    _infoChip(
                                      Icons.person,
                                      user.role ?? 'customer',
                                      roleColor,
                                    ),
                                    if (user.phone != null &&
                                        user.phone!.isNotEmpty)
                                      _infoChip(
                                        Icons.phone,
                                        user.phone!,
                                        Colors.blueGrey,
                                      ),
                                    if (user.city != null &&
                                        user.city!.isNotEmpty)
                                      _infoChip(
                                        Icons.location_on_outlined,
                                        user.city!,
                                        Colors.deepPurple,
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(.4), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _comboBox({
  required String label,
  required String value,
  required Set<String> items,
  required ValueChanged<String?> onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color.fromARGB(113, 158, 158, 158)),
        ),
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}
