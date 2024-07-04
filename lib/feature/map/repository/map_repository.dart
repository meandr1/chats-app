import 'dart:io' show File;
import 'package:chats/app_constants.dart';
import 'package:chats/services/files_service/interface/files_service_interface.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:chats/models/firebase_user.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:widget_to_marker/widget_to_marker.dart';

class MapRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final IFilesService _filesService;

  MapRepository(this._filesService);

  Future<bool> isPermissionGranted() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission != LocationPermission.denied ||
        permission != LocationPermission.deniedForever;
  }

  void updateLocationInFirebase(Position myPosition) async {
    final currentUserUID = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserUID != null) {
      await _db
          .collection(AppConstants.usersCollection)
          .doc(currentUserUID)
          .set({
        AppConstants.userInfoField: {
          AppConstants.locationField:
              GeoPoint(myPosition.latitude, myPosition.longitude)
        }
      }, SetOptions(merge: true));
    }
  }

  Future<Set<Marker>> getMarkers() async {
    final Set<Marker> markers = {};
    final usersList = await getUsersList();
    if (usersList != null && usersList.isNotEmpty) {
      for (var user in usersList) {
        if (user.userInfo.location != null) {
          markers.add(Marker(
              markerId: MarkerId(user.uid),
              position: LatLng(user.userInfo.location!.latitude,
                  user.userInfo.location!.longitude),
              icon: await getMarkerIcon(user.userInfo.photoURL),
              infoWindow: InfoWindow(
                title: '${user.userInfo.firstName} ${user.userInfo.lastName}',
              )));
        }
      }
    }
    return markers;
  }

  Future<BitmapDescriptor> getMarkerIcon(String? photoURL) async {
    if (photoURL == null || photoURL.isEmpty) {
      return BitmapDescriptor.defaultMarker;
    }
    final markerFile = await getFile(photoURL);
    if (markerFile == null) {
      return SizedBox(
              width: 20,
              height: 35,
              child: Image.asset(AppConstants.defaultGoogleMapPinAsset))
          .toBitmapDescriptor();
    }
    return Container(
            width: AppConstants.mapImageDiameter,
            height: AppConstants.mapImageDiameter,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: FileImage(markerFile), fit: BoxFit.cover)))
        .toBitmapDescriptor();
  }

  Future<File?> getFile(String fileUrl) async {
    return _filesService.getFile(firebaseFileUrl: fileUrl);
  }

  Future<List<FirebaseUser>?> getUsersList() async {
    final currentUID = FirebaseAuth.instance.currentUser?.uid;
    final docs =
        (await _db.collection(AppConstants.usersCollection).get()).docs;
    if (docs.isNotEmpty) {
      final usersList = docs
          .map((e) => FirebaseUser.fromJSON(jsonData: e.data(), uid: e.id))
          .toList();
      return usersList
          .where((user) =>
              user.uid != currentUID &&
              user.userInfo.firstName != null &&
              user.userInfo.lastName != null)
          .toList();
    }
    return null;
  }
}
