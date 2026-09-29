import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

enum RiskLevel { low, moderate, high }

class RiskClassificationService {
  // Simple ML model for earthquake risk classification
  // This is a simplified model - in a real app, you'd use a trained TensorFlow Lite model
  
  static RiskLevel classifyRisk(Position position) {
    // Extract features from location
    double latitude = position.latitude;
    double longitude = position.longitude;
    
    // Calculate risk score based on location
    double riskScore = _calculateRiskScore(latitude, longitude);
    
    // Classify based on risk score
    if (riskScore < 0.3) {
      return RiskLevel.low;
    } else if (riskScore < 0.7) {
      return RiskLevel.moderate;
    } else {
      return RiskLevel.high;
    }
  }
  
  static double _calculateRiskScore(double latitude, double longitude) {
    // This is a simplified risk calculation
    // In reality, you'd use geological data, fault lines, historical earthquake data, etc.
    
    // Known high-risk areas (simplified examples)
    List<Map<String, dynamic>> highRiskAreas = [
      {'lat': 36.2048, 'lng': 138.2529, 'radius': 5.0}, // Japan
      {'lat': 35.8617, 'lng': 104.1954, 'radius': 8.0}, // China
      {'lat': 20.5937, 'lng': 78.9629, 'radius': 6.0},  // India
      {'lat': 39.8283, 'lng': -98.5795, 'radius': 4.0}, // US Central
      {'lat': 36.7783, 'lng': -119.4179, 'radius': 3.0}, // California
    ];
    
    // Known moderate-risk areas
    List<Map<String, dynamic>> moderateRiskAreas = [
      {'lat': 41.9028, 'lng': 12.4964, 'radius': 4.0}, // Italy
      {'lat': 39.9334, 'lng': 32.8597, 'radius': 3.0}, // Turkey
      {'lat': 40.4168, 'lng': -3.7038, 'radius': 2.0}, // Spain
    ];
    
    double minDistance = double.infinity;
    double riskMultiplier = 1.0;
    
    // Check distance to high-risk areas
    for (var area in highRiskAreas) {
      double distance = _calculateDistance(
        latitude, longitude,
        area['lat'], area['lng']
      );
      if (distance < area['radius']) {
        riskMultiplier = 2.0;
        minDistance = min(minDistance, distance);
      }
    }
    
    // Check distance to moderate-risk areas
    for (var area in moderateRiskAreas) {
      double distance = _calculateDistance(
        latitude, longitude,
        area['lat'], area['lng']
      );
      if (distance < area['radius'] && riskMultiplier < 1.5) {
        riskMultiplier = 1.5;
        minDistance = min(minDistance, distance);
      }
    }
    
    // Base risk calculation
    double baseRisk = 0.2; // Base risk for any location
    
    // Adjust based on proximity to fault lines (simplified)
    double faultProximityRisk = _calculateFaultProximityRisk(latitude, longitude);
    
    // Final risk score
    double finalRisk = (baseRisk + faultProximityRisk) * riskMultiplier;
    
    // Add some randomness to simulate ML model uncertainty
    finalRisk += (Random().nextDouble() - 0.5) * 0.1;
    
    return finalRisk.clamp(0.0, 1.0);
  }
  
  static double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2) / 1000; // Convert to km
  }
  
  static double _calculateFaultProximityRisk(double latitude, double longitude) {
    // Simplified fault line proximity calculation
    // Major fault lines (simplified coordinates)
    List<List<double>> faultLines = [
      [36.2048, 138.2529], // Japan Trench
      [35.8617, 104.1954], // Himalayan Frontal Thrust
      [39.8283, -98.5795], // New Madrid Seismic Zone
      [36.7783, -119.4179], // San Andreas Fault
    ];
    
    double minDistance = double.infinity;
    for (var fault in faultLines) {
      double distance = _calculateDistance(latitude, longitude, fault[0], fault[1]);
      minDistance = min(minDistance, distance);
    }
    
    // Risk decreases with distance from fault lines
    if (minDistance < 100) return 0.4;
    if (minDistance < 500) return 0.2;
    if (minDistance < 1000) return 0.1;
    return 0.05;
  }
  
  static String getRiskDescription(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.low:
        return 'Low earthquake risk. Your area has minimal seismic activity.';
      case RiskLevel.moderate:
        return 'Moderate earthquake risk. Be prepared and stay informed about local seismic activity.';
      case RiskLevel.high:
        return 'High earthquake risk. Your area is prone to seismic activity. Ensure you have an emergency plan.';
    }
  }
  
  static Color getRiskColor(RiskLevel riskLevel) {
    switch (riskLevel) {
      case RiskLevel.low:
        return Colors.green;
      case RiskLevel.moderate:
        return Colors.orange;
      case RiskLevel.high:
        return Colors.red;
    }
  }
} 