import pickle
import numpy as np
from sklearn.tree import export_text
from sklearn.ensemble import RandomForestClassifier

def extract_rules_from_model():
    """Extract actual decision rules from the trained Random Forest model"""
    
    print("Loading trained model from earthquake_risk_model.pkl...")
    
    # Load the trained model
    with open('earthquake_risk_model.pkl', 'rb') as f:
        model_data = pickle.load(f)
    
    model = model_data['model']
    scaler = model_data['scaler']
    feature_names = model_data['feature_names']
    
    print(f"Model loaded successfully!")
    print(f"Feature names: {feature_names}")
    print(f"Number of trees: {model.n_estimators}")
    
    # Extract rules from the first few trees
    print("\n=== EXTRACTING RULES FROM TRAINED MODEL ===")
    
    rules = []
    
    # Extract rules from first 5 trees (for readability)
    for i in range(min(5, model.n_estimators)):
        tree = model.estimators_[i]
        tree_rules = export_text(tree, feature_names=feature_names, show_weights=True)
        print(f"\n--- Tree {i+1} Rules ---")
        print(tree_rules)
        
        # Parse the rules into a more usable format
        parsed_rules = parse_tree_rules(tree_rules, feature_names)
        rules.extend(parsed_rules)
    
    # Generate Dart code for Flutter
    print("\n=== DART CODE FOR FLUTTER ===")
    generate_dart_rules(rules, feature_names)
    
    # Test the rules with sample locations
    print("\n=== TESTING EXTRACTED RULES ===")
    test_locations = [
        (37.7749, -122.4194, "San Francisco"),
        (35.6762, 139.6503, "Tokyo"),
        (51.5074, -0.1278, "London"),
    ]
    
    for lat, lng, name in test_locations:
        # Calculate distance to fault
        fault_distance = calculate_fault_distance(lat, lng)
        
        # Prepare features
        features = [lat, lng, 10.0, 5.0, fault_distance]
        features_scaled = scaler.transform([features])
        
        # Get model prediction
        prediction = model.predict(features_scaled)[0]
        probabilities = model.predict_proba(features_scaled)[0]
        
        risk_levels = ['Low', 'Moderate', 'High']
        predicted_risk = risk_levels[prediction]
        confidence = max(probabilities)
        
        print(f"{name}: {predicted_risk} Risk (Confidence: {confidence:.3f})")
        print(f"  Features: lat={lat:.2f}, lng={lng:.2f}, fault_dist={fault_distance:.2f}km")
        print(f"  Probabilities: Low={probabilities[0]:.3f}, Mod={probabilities[1]:.3f}, High={probabilities[2]:.3f}")

def parse_tree_rules(tree_text, feature_names):
    """Parse tree rules into a structured format"""
    rules = []
    lines = tree_text.split('\n')
    
    for line in lines:
        if '|' in line and 'class:' in line:
            # Extract the decision path and class
            parts = line.split('class:')
            if len(parts) == 2:
                decision_path = parts[0].strip()
                class_info = parts[1].strip()
                
                # Parse the class information
                if 'weights:' in class_info:
                    weights_part = class_info.split('weights:')[1].strip()
                    weights = eval(weights_part)
                    
                    # Find the predicted class (highest weight)
                    predicted_class = weights.index(max(weights))
                    confidence = max(weights) / sum(weights)
                    
                    rules.append({
                        'path': decision_path,
                        'predicted_class': predicted_class,
                        'confidence': confidence,
                        'weights': weights
                    })
    
    return rules

def generate_dart_rules(rules, feature_names):
    """Generate Dart code for Flutter"""
    print("// Generated Dart rules from trained model")
    print("// Copy this into your Flutter app")
    print()
    
    print("static const List<Map<String, dynamic>> _extractedRules = [")
    
    for i, rule in enumerate(rules):
        print(f"  // Rule {i+1}")
        print(f"  {{")
        print(f"    'condition': '{rule['path']}',")
        print(f"    'predicted_class': {rule['predicted_class']}, // 0=Low, 1=Moderate, 2=High")
        print(f"    'confidence': {rule['confidence']:.3f},")
        print(f"    'weights': {rule['weights']},")
        print(f"  }},")
    
    print("];")
    print()
    print("// Usage in Flutter:")
    print("// for (var rule in _extractedRules) {")
    print("//   if (matchesCondition(rule['condition'], features)) {")
    print("//     return rule['predicted_class'];")
    print("//   }")
    print("// }")

def calculate_fault_distance(lat, lng):
    """Calculate distance to nearest fault line"""
    fault_lines = [
        {'lat': 36.7783, 'lng': -119.4179},  # San Andreas
        {'lat': 36.2048, 'lng': 138.2529},   # Japan Trench
        {'lat': 35.8617, 'lng': 104.1954},   # Himalayan
        {'lat': 39.8283, 'lng': -98.5795},   # New Madrid
        {'lat': -42.0, 'lng': 171.0},        # Alpine Fault
    ]
    
    min_distance = float('inf')
    for fault in fault_lines:
        distance = np.sqrt((lat - fault['lat'])**2 + (lng - fault['lng'])**2)
        min_distance = min(min_distance, distance)
    
    return min_distance

if __name__ == "__main__":
    extract_rules_from_model() 