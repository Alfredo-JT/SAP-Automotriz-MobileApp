import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/features/admin/customers/infrastructure/datasources/cars_datasource.dart';
import 'package:sap_automotriz_app/features/admin/customers/infrastructure/datasources/customers_datasource.dart';
import 'package:sap_automotriz_app/features/admin/customers/infrastructure/repositories/cars_repository_impl.dart';
import 'package:sap_automotriz_app/features/admin/customers/infrastructure/repositories/customers_repository_impl.dart';
import 'package:sap_automotriz_app/features/admin/customers/presentation/bloc/blocs.dart';
import 'package:sap_automotriz_app/features/admin/shared/presentation/widgets/admin_layout.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/datasources/services_datasource.dart';
import 'package:sap_automotriz_app/features/services/infrastructure/repositories/services_repository_impl.dart';
import 'package:sap_automotriz_app/features/admin/services/presentation/blocs/service_bloc.dart';
import 'package:sap_automotriz_app/features/admin/services/presentation/blocs/service_event.dart';
import 'package:sap_automotriz_app/features/admin/services/presentation/blocs/service_state.dart';
import 'package:sap_automotriz_app/features/shared/widgets/widgets.dart';
import 'new_service_screen.dart';
import 'quote_completion_screen.dart';
import 'service_operations_screen.dart';

class ServiceHubPage extends StatelessWidget {
  const ServiceHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              ServicesBloc(ServicesRepositoryImpl(ServicesDatasource()))
                ..add(ServicesLoadRequested()),
        ),
        BlocProvider(
          create: (_) =>
              CustomersBloc(CustomersRepositoryImpl(CustomersDatasource()))
                ..add(CustomersLoadRequested()),
        ),
        BlocProvider(
          create: (_) => CarsBloc(CarsRepositoryImpl(CarsDatasource())),
        ),
      ],
      child: const ServicesHubScreen(),
    );
  }
}

class ServicesHubScreen extends StatefulWidget {
  const ServicesHubScreen({super.key});

  @override
  State<ServicesHubScreen> createState() => _ServicesHubScreenState();
}

class _ServicesHubScreenState extends State<ServicesHubScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ServicesBloc, ServicesState>(
      listener: (context, state) {},
      builder: (context, state) {
        return AdminLayout(
          currentRoute: RouteNames.services,
          pageTitle: 'Servicios',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTabBar(
                tabController: _tabController,
                tabs: [
                  _TabItem(
                    label: 'Nuevo Servicio',
                    icon: Icons.add_circle_outline_rounded,
                  ),
                  _TabItem(
                    label:
                        'Servicios Cotizados (Completar y revisar cotizaciones)',
                    icon: Icons.request_quote_outlined,
                  ),
                  _TabItem(
                    label: 'Información de Servicios',
                    icon: Icons.tune_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              SizedBox(
                height: MediaQuery.of(context).size.height - 180,
                child: TabBarView(
                  controller: _tabController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _TabContent(child: NewServiceScreen()),
                    _TabContent(child: QuoteCompletionScreen()),
                    _TabContent(child: ServiceOperationsScreen()),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final IconData icon;

  const _TabItem({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), SizedBox(width: 8), Text(label)],
      ),
    );
  }
}

/// Wraps tab content in a scrollable container.
class _TabContent extends StatelessWidget {
  final Widget child;
  const _TabContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: child);
  }
}
