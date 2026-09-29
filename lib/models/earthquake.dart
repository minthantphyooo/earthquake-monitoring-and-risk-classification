import 'package:flutter/material.dart';

class Earthquake {
  final double magnitude;
  final String location;
  final DateTime time;
  final double distance;
  final int comments;
  final Color color;
  final double latitude;
  final double longitude;

  Earthquake({
    required this.magnitude,
    required this.location,
    required this.time,
    required this.distance,
    required this.comments,
    required this.color,
    required this.latitude,
    required this.longitude,
  });

  factory Earthquake.fromJson(Map<String, dynamic> json) {
    final properties = json['properties'];
    final geometry = json['geometry'];
    final coordinates = geometry['coordinates'];
    
    return Earthquake(
      magnitude: properties['mag']?.toDouble() ?? 0.0,
      location: properties['place'] ?? 'Unknown Location',
      time: DateTime.fromMillisecondsSinceEpoch(properties['time']),
      distance: 0.0, // We'll calculate this based on user's location
      comments: 0, // USGS API doesn't provide comments
      color: colorForMagnitude(properties['mag']?.toDouble() ?? 0.0),
      latitude: coordinates[1].toDouble(),
      longitude: coordinates[0].toDouble(),
    );
  }

  static Color colorForMagnitude(double magnitude) {
    if (magnitude < 4.0) return Colors.green;
    if (magnitude < 5.0) return Colors.orange;
    if (magnitude < 6.0) return Colors.blue;
    return Colors.red;
  }
} 