import 'dart:async';
import 'package:flutter/material.dart';
import '../models/earthquake.dart';
import '../services/earthquake_service.dart';
import '../utils/time_formatter.dart';
import '../widgets/earthquake_card.dart';

class EarthquakeListScreen extends StatefulWidget {
  const EarthquakeListScreen({super.key});

  @override
  State<EarthquakeListScreen> createState() => _EarthquakeListScreenState();
}

class _EarthquakeListScreenState extends State<EarthquakeListScreen> {
  final EarthquakeService _service = EarthquakeService();
  List<Earthquake> earthquakes = [];
  bool isLoading = true;
  String? errorMessage;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _loadEarthquakes();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      _loadEarthquakes();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadEarthquakes() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final quakes = await _service.getRecentEarthquakes();
      setState(() {
        earthquakes = quakes;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadEarthquakes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (earthquakes.isEmpty) {
      return const Center(
        child: Text('No earthquakes found in the past hour'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadEarthquakes,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Last updated: ${TimeFormatter.formatTimeAgo(DateTime.now())}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: earthquakes.length,
              itemBuilder: (context, index) {
                final quake = earthquakes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                  child: EarthquakeCard(
                    earthquake: quake,
                    onBookmark: () {
                      
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 