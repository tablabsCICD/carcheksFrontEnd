import 'package:carcheks/locator.dart';
import 'package:carcheks/model/subservices_model.dart';
import 'package:carcheks/model/vehicle_model.dart';
import 'package:carcheks/provider/garage_provider.dart';
import 'package:carcheks/provider/vehicle_provider.dart';
import 'package:carcheks/view/base_widgets/custom_appbar.dart';
import 'package:carcheks/view/screens/customer/garage/garage_card.dart';
import 'package:carcheks/view/screens/customer/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NearByStore extends StatefulWidget {
  final List<SubService>? selectedList;
  final String fromScreen;
  final Vehicle? vehicle;

  const NearByStore({
    Key? key,
    this.selectedList,
    this.fromScreen = 'Dashboard',
    this.vehicle,
  }) : super(key: key);

  @override
  State<NearByStore> createState() => _NearByStoreState();
}

class _NearByStoreState extends State<NearByStore> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isMapSelected = false;
  bool isPopularSelected = false;

  final GarageProvider garageProvider = locator<GarageProvider>();
  final VehicleProvider vehicleProvider = locator<VehicleProvider>();

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    switch (widget.fromScreen) {
      case 'Filter':
        _loadFilteredGarages();
        break;
      case 'NearByALL':
        garageProvider.getAllGarageNearByUser();
        break;
      case 'Search':
        _loadByVehicleType();
        break;
      default:
        garageProvider.getAllGarage();
    }
  }

  void _loadFilteredGarages() {
    if (widget.selectedList == null ||
        widget.selectedList!.isEmpty ||
        vehicleProvider.selectedUserVehicle == null) {
      garageProvider.getAllGarage();
      return;
    }

    final subServiceIds = widget.selectedList!.map((e) => e.id).toList();

    garageProvider.nearbyGarageByService(
      vehicleProvider.selectedUserVehicle!.vehicletype!.id!,
      subServiceIds,
    );
  }

  void _loadByVehicleType() {
    if (widget.vehicle?.vehicletype?.id == null) {
      garageProvider.getAllGarage();
      return;
    }

    garageProvider.getAllGarageNearByVehicleType(
      vehicleType: widget.vehicle!.vehicletype!.id!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(context, _scaffoldKey, "All nearby stores"),
      body: Consumer<GarageProvider>(
        builder: (_, model, __) {
          if (model.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (model.allGarageList.isEmpty) {
            return const Center(child: Text("No data found"));
          }

          return Column(
            children: [
              _filterBar(),
              Expanded(child: _buildContent(model)),
            ],
          );
        },
      ),
    );
  }

  Widget _filterBar() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _filterButton(
            label: 'Popular',
            icon: isPopularSelected ? Icons.star : Icons.star_border,
            selected: isPopularSelected,
            onTap: () {
              setState(() {
                isPopularSelected = !isPopularSelected;
                isMapSelected = false;
              });
            },
          ),
          _filterButton(
            label: 'On Map',
            icon: Icons.map,
            selected: isMapSelected,
            onTap: () {
              setState(() {
                isMapSelected = !isMapSelected;
                isPopularSelected = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _filterButton({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: selected ? Colors.green[200] : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(GarageProvider model) {
    if (isMapSelected) return MapScreen();

    final list = isPopularSelected
        ? model.isPopularGarageList
        : model.allGarageList;

    return _garageGrid(
      title: isPopularSelected ? "Popular Nearby Stores" : "All Nearby Stores",
      garages: list,
    );
  }

  Widget _garageGrid({required String title, required List garages}) {
    if (garages.isEmpty) {
      return const Center(child: Text("No stores found"));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              itemCount: garages.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (_, index) => CardStore(garages[index]),
            ),
          ),
        ],
      ),
    );
  }
}
