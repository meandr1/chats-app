import 'package:chats/app_constants.dart';
import 'package:chats/feature/map/cubit/map_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    late GoogleMapController googleMapController;
    return BlocConsumer<MapCubit, MapState>(
      listener: (BuildContext context, MapState state) =>
          stateListener(context, state, googleMapController),
      builder: (context, state) {
        return Stack(
          children: [
            GoogleMap(
              myLocationEnabled: state.status != MapStatus.permissionNotGranted,
              myLocationButtonEnabled: false,
              markers:
                  state.status == MapStatus.markersAdded ? state.markers! : {},
              onMapCreated: (controller) {
                googleMapController = controller;
                context.read<MapCubit>().getMarkers();
              },
              initialCameraPosition: AppConstants.defaultCameraPosition,
            ),
            myLocationButton(context, state)
          ],
        );
      },
    );
  }

  Widget myLocationButton(BuildContext context, MapState state) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Align(
          alignment: Alignment.topRight,
          child: SizedBox(
            height: 40,
            width: 40,
            child: FloatingActionButton.extended(
                shape: const BeveledRectangleBorder(),
                backgroundColor: Colors.white.withOpacity(0.8),
                onPressed: () =>
                    context.read<MapCubit>().trackingStatusChanged(),
                label: Icon(Icons.my_location,
                    color: state.trackMe ? Colors.blue : Colors.grey.shade700)),
          )),
    );
  }

  void stateListener(BuildContext context, MapState state,
      GoogleMapController googleMapController) {
    if (state.trackMe && state.myPosition != null) {
      setCameraPosition(state.myPosition!, googleMapController);
    }
  }

  void setCameraPosition(
      LatLng position, GoogleMapController googleMapController) async {
    googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(position, AppConstants.defaultZoomLevel));
  }
}
