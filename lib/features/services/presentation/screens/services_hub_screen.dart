import 'package:flutter/material.dart';
import 'package:sap_automotriz_app/config/router/app_router.dart';
import 'package:sap_automotriz_app/config/theme/app_theme.dart';
import 'package:sap_automotriz_app/features/dashboard/presentation/widgets/admin_layout.dart';
import 'new_service_screen.dart';
import 'quote_completion_screen.dart';
import 'service_operations_screen.dart';

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
    return AdminLayout(
      currentRoute: RouteNames.services,
      pageTitle: 'Servicios',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Custom tab bar
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEDE5DC)),
            ),
            padding: const EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(8),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.warmGray,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
              tabs: const [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.add_circle_outline_rounded, size: 16),
                      SizedBox(width: 8),
                      Text('Nuevo servicio'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.request_quote_outlined, size: 16),
                      SizedBox(width: 8),
                      Text('Completar cotización'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.tune_rounded, size: 16),
                      SizedBox(width: 8),
                      Text('Operaciones'),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tab content — each tab manages its own scroll
          SizedBox(
            height: MediaQuery.of(context).size.height - 180,
            child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                // _TabContent(child: NewServiceScreen()),
                // _TabContent(child: QuoteCompletionScreen()),
                // _TabContent(child: ServiceOperationsScreen()),

                // Text('Nuevo servicio - En construcción'),
                _TabContent(child: NewServiceScreen()),
                _TabContent(child: QuoteCompletionScreen()),
                _TabContent(child: ServiceOperationsScreen()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Wraps tab content in a scrollable container.
/// Note: NewServiceScreen, QuoteCompletionScreen and ServiceOperationsScreen
/// each contain AdminLayout when used as standalone routes.
/// When embedded here, they reuse the hub's AdminLayout naturally because
/// ServicesHubScreen itself is wrapped in AdminLayout — the inner screens
/// should be refactored to accept a [standalone] flag and skip their own
/// AdminLayout when false. This is left as a TODO for when BLoC is wired.
class _TabContent extends StatelessWidget {
  final Widget child;
  const _TabContent({required this.child});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: child);
  }
}
