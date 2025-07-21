import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  @override
  _TrackingScreenState createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndStartTracking();
  }

  Future<void> _checkPermissionsAndStartTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return;
      }
    }

    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      FirebaseFirestore.instance.collection('users').doc('current_user').set({
        'id': 'current_user',
        'name': 'Joriy Foydalanuvchi',
        'location': {
          'latitude': position.latitude,
          'longitude': position.longitude
        },
        'last_seen': DateTime.now().toIso8601String(),
      });
      _updateMarkers();
    });
  }

  void _updateMarkers() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('users').get();
    setState(() {
      _markers.clear();
      for (var doc in snapshot.docs) {
        var data = doc.data() as Map<String, dynamic>;
        var location = data['location'];
        _markers.add(
          Marker(
            markerId: MarkerId(data['id']),
            position: LatLng(location['latitude'], location['longitude']),
            infoWindow: InfoWindow(
                title: data['name'],
                snippet: 'Oxirgi marta: ${data['last_seen']}'),
          ),
        );
      }
    });
  }

  void _addUser() {
    String id = _idController.text.trim();
    String name = _nameController.text.trim();
    if (id.isNotEmpty && name.isNotEmpty) {
      FirebaseFirestore.instance.collection('users').doc(id).set({
        'id': id,
        'name': name,
        'location': {
          'latitude': 41.3052,
          'longitude': 69.2478
        }, // Dastlabki joylashuv
        'last_seen': DateTime.now().toIso8601String(),
      });
      _idController.clear();
      _nameController.clear();
      _updateMarkers();
    }
  }

  void _toggleTracking() {
    setState(() {
      _isTracking = !_isTracking;
      if (_isTracking) {
        _updateMarkers();
        _mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            const CameraPosition(target: LatLng(41.3052, 69.2478), zoom: 12),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Xarita Kuzatish'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Yangi Kuzatuvchi Qo‘shish'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: _idController,
                        decoration: const InputDecoration(
                            labelText: 'ID (masalan, 000129321)'),
                      ),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                            labelText: 'Ism (masalan, Jasurbek)'),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Bekor qilish'),
                    ),
                    TextButton(
                      onPressed: () {
                        _addUser();
                        Navigator.pop(context);
                      },
                      child: const Text('Qo‘shish'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(41.3052, 69.2478), // Toshkent
              zoom: 12,
            ),
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          if (!_isTracking)
            Center(
              child: ElevatedButton(
                onPressed: _toggleTracking,
                child: const Text('Xaritani Ko‘rish va Kuzatish'),
              ),
            ),
        ],
      ),
      floatingActionButton: _isTracking
          ? FloatingActionButton(
              onPressed: _toggleTracking,
              child: const Icon(Icons.stop),
            )
          : null,
    );
  }
}
