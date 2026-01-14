import 'package:carcheks/locator.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/screens/customer/service/service_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetAllServices extends StatefulWidget {
  final Vehicle? vehicle;
  final String from;

  const GetAllServices({super.key, this.vehicle, this.from = "Dashboard"});

  @override
  State<GetAllServices> createState() => _GetAllServicesState();
}

class _GetAllServicesState extends State<GetAllServices> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ServiceProvider serviceProvider = locator<ServiceProvider>();

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() {
    /// Dashboard → all services
    if (widget.from == "Dashboard") {
      serviceProvider.getAllServices();
      serviceProvider.getSelectedServiceCount();
      return;
    }

    /// Vehicle-based services
    final vehicleTypeId = widget.vehicle?.vehicletype?.id;
    if (vehicleTypeId != null) {
      serviceProvider.getAllByid(vehicleTypeId);
    }
  }

  Future<void> _onRefresh() async {
    _loadServices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "Book Services"),
      body: Consumer<ServiceProvider>(
        builder: (context, model, _) {
          /// Loader
          if (model.isLoading) {
            return const _LoaderView();
          }

          /// Empty state
          if (model.allServices.isEmpty) {
            return _EmptyView(onRetry: _onRefresh);
          }

          /// Content
          return SafeArea(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "All Services",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: GridView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: model.allServices.length,
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                        itemBuilder: (_, index) {
                          return ServiceCard(model.allServices[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _LoaderView extends StatelessWidget {
  const _LoaderView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 12),
          Text("Loading services...", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.build_circle_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 12),
            const Text(
              "No services available",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            const Text(
              "Please try again later",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
          ],
        ),
      ),
    );
  }
}
