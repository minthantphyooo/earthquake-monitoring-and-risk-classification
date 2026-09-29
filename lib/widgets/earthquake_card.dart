import 'package:flutter/material.dart';
import '../models/earthquake.dart';
import '../utils/time_formatter.dart';

class EarthquakeCard extends StatelessWidget {
  final Earthquake earthquake;
  final VoidCallback? onBookmark;

  const EarthquakeCard({
    super.key,
    required this.earthquake,
    this.onBookmark,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: earthquake.color,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  earthquake.magnitude.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  child: Text(
                    earthquake.location,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark_border, color: Colors.white),
                  onPressed: onBookmark,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16),
                    const SizedBox(width: 4),
                    Text(TimeFormatter.formatTimeAgo(earthquake.time)),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16),
                    const SizedBox(width: 4),
                    Text('${earthquake.latitude.toStringAsFixed(2)}°, ${earthquake.longitude.toStringAsFixed(2)}°'),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16),
                    const SizedBox(width: 4),
                    Text('USGS'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 