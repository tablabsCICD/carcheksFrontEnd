import 'package:carcheks/locator.dart';
import 'package:carcheks/provider/auth_provider.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/services_provider.dart';
import 'package:carcheks/route/app_routes.dart';
import 'package:carcheks/util/color-resource.dart';
import 'package:carcheks/view/base_widgets/garage_owner_navigation_drawer.dart';
import 'package:carcheks/view/base_widgets/getImage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ImageCarousel {
  String image1;
  String title;
  String subTitle;

  ImageCarousel(this.image1, this.title, this.subTitle);
}

class GarageDashboard extends StatefulWidget {
  const GarageDashboard({Key? key}) : super(key: key);

  @override
  State<GarageDashboard> createState() => _GarageDashboardState();
}

class _GarageDashboardState extends State<GarageDashboard> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ServiceProvider serviceProvider = locator<ServiceProvider>();
  final GarageProvider garageProvider = locator<GarageProvider>();
  final AuthProvider authProvider = locator<AuthProvider>();

  late String formattedDate;

  @override
  void initState() {
    super.initState();
    formattedDate = DateFormat('yMd').format(DateTime.now());
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchInitialData());
  }

  Future<void> _fetchInitialData() async {
    if (garageProvider.ownGarageList.isNotEmpty) {
      await serviceProvider.getAppointmentData(
        garageProvider.ownGarageList[0].id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final garageName = garageProvider.ownGarageList.isNotEmpty
        ? garageProvider.ownGarageList[0].name
        : "Garage";

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: ColorResources.APPBAR_COLOR,
        title: Text(garageName, style: const TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: ColorResources.BUTTON_COLOR),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.garageOwner_profile,
                arguments: true,
              );
            },
            child: getImage(authProvider.user?.imageUrl ?? ""),
          ),
          const SizedBox(width: 10),
        ],
      ),
      drawer: GarageOwnerDrawerWidget(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildStatCards(context),
            const SizedBox(height: 20),
            _sectionHeader(
              context,
              "Choose Services",
              onViewAll: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.choose_service,
                  arguments: true,
                );
              },
            ),
            const SizedBox(height: 10),
            _buildServiceList(),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    String title, {
    VoidCallback? onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        if (onViewAll != null)
          InkWell(
            onTap: onViewAll,
            child: const Text(
              "View All",
              style: TextStyle(
                color: ColorResources.PRIMARY_COLOR,
                fontSize: 14,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatCards(BuildContext context) {
    final stats = serviceProvider.guarage_home;

    return Column(
      children: [
        Row(
          children: [
            _buildStatCard(
              context,
              "New Arrival",
              Icons.local_car_wash,
              Colors.orange,
              stats.newAppointment ?? 0,
              "New Arrival",
            ),
            _buildStatCard(
              context,
              "In Progress",
              Icons.tire_repair,
              Colors.blue,
              stats.workInProgress ?? 0,
              "In Progress",
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildStatCard(
              context,
              "Completed",
              Icons.car_repair,
              Colors.green,
              stats.completed ?? 0,
              "Completed",
            ),
            _buildStatCard(
              context,
              "Cancelled",
              Icons.car_crash_sharp,
              Colors.red,
              stats.cancled ?? 0,
              "Cancelled",
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            _buildStatCard(
              context,
              "All Appointment",
              Icons.tire_repair,
              Colors.blue,
              stats.numberOfRequest ?? 0,
              "All",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int count,
    String routeArg,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
          context,
          AppRoutes.appointment,
          arguments: routeArg,
        ),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: Colors.white,
          child: Container(
            height: 150,
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: color.withAlpha(30),
                  child: Icon(icon, size: 22, color: color),
                ),
                const SizedBox(height: 10),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  title,
                  style: TextStyle(fontSize: 14, color: color),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceList() {
    return Consumer<ServiceProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SizedBox(
          height: 230, // ✅ Better height for modern cards
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: provider.allServices.length,
            separatorBuilder: (_, __) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final service = provider.allServices[index];
              final hasImage = service.photosUrl.trim().isNotEmpty;

              return Container(
                width: 180, // ✅ Proper card width
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// ✅ SERVICE IMAGE
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(14),
                      ),
                      child: hasImage
                          ? Image.network(
                              service.photosUrl,
                              height: 130,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  _buildDefaultServiceIcon(),
                            )
                          : _buildDefaultServiceIcon(),
                    ),

                    /// ✅ SERVICE NAME
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                      child: Text(
                        service.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          overflow: TextOverflow.ellipsis,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const Spacer(),

                    /// ✅ ADD BUTTON
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.add_service,
                              arguments: service,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorResources.PRIMARY_COLOR,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Add",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDefaultServiceIcon() {
    return Container(
      width: double.infinity,
      height: 100,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.build_circle_outlined,
        size: 50,
        color: Colors.grey,
      ),
    );
  }
}

class Appointment {
  String name, date, status;
  MaterialColor color;
  Appointment(this.name, this.date, this.status, this.color);
}
