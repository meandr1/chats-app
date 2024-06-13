part of 'map_cubit.dart';

enum MapStatus { initial, error, permissionNotGranted,loading, markersAdded }

class MapState extends Equatable {
  final MapStatus status;
  final bool trackMe;
  final LatLng? myPosition;
  final Set<Marker>? markers;

  const MapState({required this.status, required this.trackMe, this.myPosition, this.markers});

  factory MapState.initial() {
    return const MapState(status: MapStatus.initial, trackMe: false);
  }

  @override
  List<Object?> get props => [status, myPosition, markers, trackMe];

  MapState copyWith(
      {MapStatus? status, LatLng? myPosition, Set<Marker>? markers, bool? trackMe}) {
    return MapState(
      status: status ?? this.status,
      trackMe: trackMe ?? this.trackMe,
      myPosition: myPosition ?? this.myPosition,
      markers: markers ?? this.markers,
    );
  }
}
