import 'package:chats/feature/map/repository/map_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

part 'map_state.dart';

class MapCubit extends Cubit<MapState> {
  final MapRepository _mapRepository;
  MapCubit(this._mapRepository) : super(MapState.initial());

  void trackingStatusChanged() {
    emit(state.copyWith(trackMe: !state.trackMe));
  }

  void updateMyPosition() async {
    if (state.myPosition != null) return;
    final permission = await _mapRepository.isPermissionGranted();
    if (permission) {
      Geolocator.getPositionStream().listen((Position position) {
        _mapRepository.updateLocationInFirebase(position);
        emit(state.copyWith(
            myPosition: LatLng(position.latitude, position.longitude)));
      });
    } else {
      emit(state.copyWith(status: MapStatus.permissionNotGranted));
    }
  }

  void getMarkers() async {
    emit(state.copyWith(status: MapStatus.loading));
    final markers = await _mapRepository.getMarkers();
    if (markers.isNotEmpty) {
      emit(state.copyWith(status: MapStatus.markersAdded, markers: markers));
    }
  }
}
