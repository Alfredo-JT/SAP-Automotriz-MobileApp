import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';
import 'package:sap_automotriz_app/features/users/domain/user_account.dart';
import 'package:sap_automotriz_app/features/users/presentation/widgets/widgets.dart';
import 'user_account_detail_screen.dart';

class UserAccountScreen extends StatefulWidget {
  const UserAccountScreen({super.key});

  @override
  State<UserAccountScreen> createState() => _UserAccountScreenState();
}

class _UserAccountScreenState extends State<UserAccountScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  UserRole? _roleFilter;

  // Mock data — replace with BLoC state
  final List<UserAccount> _users = [
    UserAccount(
      id: 1,
      fullName: 'Jorge Méndez',
      phone: '461-100-0001',
      email: 'jorge@sap.com',
      role: UserRole.admin,
      salary: 18000,
      isActive: true,
      createdAt: DateTime(2023, 6, 1),
    ),
    UserAccount(
      id: 2,
      fullName: 'Luis Carrillo',
      phone: '461-100-0002',
      email: 'luis@sap.com',
      role: UserRole.technician,
      salary: 9500,
      isActive: true,
      createdAt: DateTime(2023, 8, 15),
    ),
    UserAccount(
      id: 3,
      fullName: 'Héctor Vega',
      phone: '461-100-0003',
      email: 'hector@sap.com',
      role: UserRole.workshopManager,
      salary: 13000,
      isActive: true,
      createdAt: DateTime(2023, 7, 20),
    ),
    UserAccount(
      id: 4,
      fullName: 'Mario Soto',
      phone: '461-100-0004',
      role: UserRole.technician,
      salary: 9000,
      isActive: false,
      createdAt: DateTime(2024, 1, 10),
    ),
  ];

  List<UserAccount> get _filtered => _users.where((u) {
    final matchSearch =
        u.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        (u.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    final matchRole = _roleFilter == null || u.role == _roleFilter;
    return matchSearch && matchRole;
  }).toList();

  void _openCreate() async {
    final result = await showDialog<UserAccount>(
      context: context,
      builder: (_) => const UserAccountFormDialog(),
    );
    if (result != null) {
      setState(() => _users.add(result.copyWith(id: _users.length + 1)));
    }
  }

  void _openEdit(UserAccount user) async {
    final result = await showDialog<UserAccount>(
      context: context,
      builder: (_) => UserAccountFormDialog(user: user),
    );
    if (result != null) {
      setState(() {
        final idx = _users.indexWhere((u) => u.id == user.id);
        if (idx != -1) _users[idx] = result;
      });
    }
  }

  void _confirmDelete(UserAccount user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: Text(
          '¿Estás seguro de eliminar a "${user.fullName}"? Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _users.removeWhere((u) => u.id == user.id));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.crimsonRed,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

    return AdminLayout(
      currentRoute: RouteNames.userAccounts,
      pageTitle: 'Usuarios',
      actions: [
        ElevatedButton.icon(
          onPressed: _openCreate,
          icon: const Icon(Icons.person_add_rounded, size: 18),
          label: const Text('Nuevo usuario'),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filters row
          Row(
            children: [
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: const InputDecoration(
                    hintText: 'Buscar por nombre o correo...',
                    prefixIcon: Icon(Icons.search_rounded),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Role filter chips
              RoleChip(
                label: 'Todos',
                selected: _roleFilter == null,
                onTap: () => setState(() => _roleFilter = null),
              ),
              const SizedBox(width: 6),
              ...UserRole.values.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: RoleChip(
                    label: r.label,
                    selected: _roleFilter == r,
                    onTap: () => setState(
                      () => _roleFilter = _roleFilter == r ? null : r,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.charcoal,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: const Row(
              children: [
                Expanded(flex: 4, child: TableHeaderCell('Nombre')),
                Expanded(flex: 3, child: TableHeaderCell('Correo')),
                Expanded(flex: 2, child: TableHeaderCell('Teléfono')),
                Expanded(flex: 2, child: TableHeaderCell('Rol')),
                Expanded(flex: 2, child: TableHeaderCell('Salario')),
                Expanded(flex: 1, child: TableHeaderCell('Estado')),
                SizedBox(width: 100, child: TableHeaderCell('Acciones')),
              ],
            ),
          ),

          // Table rows
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              border: Border.all(color: const Color(0xFFEDE5DC)),
            ),
            child: filtered.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(40),
                    child: Center(
                      child: Text(
                        'No se encontraron usuarios',
                        style: TextStyle(
                          color: AppColors.warmGray,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) =>
                        const Divider(height: 1, color: Color(0xFFEDE5DC)),
                    itemBuilder: (context, i) {
                      final user = filtered[i];
                      return TableUserRow(
                        user: user,
                        onView: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserAccountDetailScreen(user: user),
                          ),
                        ),
                        onEdit: () => _openEdit(user),
                        onDelete: () => _confirmDelete(user),
                      );
                    },
                  ),
          ),

          const SizedBox(height: 12),
          Text(
            '${filtered.length} usuario${filtered.length != 1 ? 's' : ''}',
            style: const TextStyle(fontSize: 13, color: AppColors.warmGray),
          ),
        ],
      ),
    );
  }
}
