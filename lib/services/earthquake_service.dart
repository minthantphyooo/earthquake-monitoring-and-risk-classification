import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/earthquake.dart';

class EarthquakeService {
  static const String _baseUrl = 'https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary';

  Future<List<Earthquake>> getRecentEarthquakes() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/all_hour.geojson'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final features = data['features'] as List;
        
        return features
            .map((feature) => Earthquake.fromJson(feature))
            .where((quake) => quake.magnitude > 0)
            .toList()
          ..sort((a, b) => b.time.compareTo(a.time));
      } else {
        throw Exception('Failed to load earthquake data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 