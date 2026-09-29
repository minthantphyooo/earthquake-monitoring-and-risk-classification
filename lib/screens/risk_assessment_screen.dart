import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import '../services/real_ml_service.dart';

class RiskAssessmentScreen extends StatefulWidget {
  const RiskAssessmentScreen({super.key});

  @override
  State<RiskAssessmentScreen> createState() => _RiskAssessmentScreenState();
}

class _RiskAssessmentScreenState extends State<RiskAssessmentScreen> {
  Position? _currentPosition;
  RiskLevel? _riskLevel;
  double? _confidence;
  Map<String, double>? _probabilities;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeML();
    _checkLocationPermission();
  }

  // No initialization needed for simplified ML service
  Future<void> _initializeML() async {
    // The simplified RealMLService doesn't require initialization
    // It uses extracted rules directly
  }

  Future<void> _checkLocationPermission() async {
    bool hasPermission = await LocationService.hasLocationPermission();
    if (hasPermission) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      Position? position = await LocationService.getCurrentLocation();
      if (position != null) {
        // Use real ML model for prediction
        Map<String, dynamic> result = await RealMLService.predictRisk(position);
        
        setState(() {
          _currentPosition = position;
          _riskLevel = result['risk_level'] as RiskLevel;
          _confidence = result['confidence'] as double;
          _probabilities = Map<String, double>.from(result['probabilities']);
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Unable to get current location.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _requestLocationPermission() async {
    bool granted = await LocationService.requestLocationPermission();
    if (granted) {
      _getCurrentLocation();
    } else {
      setState(() {
        _errorMessage = 'Location permission is required to assess earthquake risk.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earthquake Risk Assessment'),
        backgroundColor: Colors.blue.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildContent(),
            const SizedBox(height: 16),
            _buildActionButtons(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Icon(
              Icons.psychology,
              size: 40,
              color: Colors.blue.shade600,
            ),
            const SizedBox(height: 6),
            const Text(
              'REAL ML-Powered Risk Assessment',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            const Text(
              'Trained on 13,892 USGS earthquakes using Random Forest ML',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('REAL ML model is analyzing your location...'),
              ],
            ),
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red.shade600,
              ),
              const SizedBox(height: 8),
              Text(
                'Error',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red.shade700),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (_currentPosition != null && _riskLevel != null) {
      return _buildRiskResult();
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              'Location Required',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'We need your location to assess earthquake risk using our trained ML model.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskResult() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Risk Level Indicator
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: RealMLService.getRiskColor(_riskLevel!),
                boxShadow: [
                  BoxShadow(
                    color: RealMLService.getRiskColor(_riskLevel!).withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _riskLevel!.name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Confidence Indicator
            if (_confidence != null) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${RealMLService.getConfidenceDescription(_confidence!)} (${(_confidence! * 100).toStringAsFixed(1)}%)',
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            
            // Risk Description
            Text(
              RealMLService.getRiskDescription(_riskLevel!),
              style: const TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Probability Breakdown
            if (_probabilities != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    const Text(
                      'AI Confidence Breakdown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildProbabilityBar('Low', _probabilities!['low']!, Colors.green),
                    const SizedBox(height: 4),
                    _buildProbabilityBar('Moderate', _probabilities!['moderate']!, Colors.orange),
                    const SizedBox(height: 4),
                    _buildProbabilityBar('High', _probabilities!['high']!, Colors.red),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
            
            // Location Details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Analysis Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Latitude: ${_currentPosition!.latitude.toStringAsFixed(4)}°',
                    style: const TextStyle(fontSize: 13),
                  ),
                  Text(
                    'Longitude: ${_currentPosition!.longitude.toStringAsFixed(4)}°',
                    style: const TextStyle(fontSize: 13),
                  ),
                  if (_probabilities != null)
                    Text(
                      'Nearest Fault: ${_probabilities!['fault_distance']?.toStringAsFixed(1) ?? 'N/A'} km',
                      style: const TextStyle(fontSize: 13),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProbabilityBar(String label, double probability, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: probability,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(probability * 100).toStringAsFixed(1)}%',
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        if (_currentPosition == null)
          ElevatedButton.icon(
            onPressed: _requestLocationPermission,
            icon: const Icon(Icons.location_on),
            label: const Text('Get My Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        if (_currentPosition != null)
          ElevatedButton.icon(
            onPressed: _getCurrentLocation,
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh Assessment'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.pushNamed(context, '/map');
          },
          icon: const Icon(Icons.map),
          label: const Text('View on Map'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    // No cleanup needed for simplified ML service
    super.dispose();
  }
}