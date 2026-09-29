import pickle
import numpy as np
from sklearn.tree import export_text

def view_rules_simply():
    """Simple way to view the rules from your trained model"""
    
    print("🔍 Loading your trained model...")
    
    try:
        # Load the trained model
        with open('earthquake_risk_model.pkl', 'rb') as f:
            model_data = pickle.load(f)
        
        model = model_data['model']
        feature_names = model_data['feature_names']
        
        print("✅ Model loaded successfully!")
        print(f"📊 Number of trees: {model.n_estimators}")
        print(f"🔧 Features: {feature_names}")
        print()
        
        print("🌳 ===== DECISION RULES FROM YOUR MODEL =====")
        print()
        
        # Show rules from first 3 trees only (to keep it simple)
        for tree_num in range(min(3, model.n_estimators)):
            print(f"📋 TREE {tree_num + 1}:")
            print("-" * 50)
            
            tree = model.estimators_[tree_num]
            tree_text = export_text(tree, feature_names=feature_names, show_weights=True)
            
            # Print each line of the tree
            for line in tree_text.split('\n'):
                if line.strip():  # Only print non-empty lines
                    print(line)
            
            print()
            print("=" * 60)
            print()
        
        print("💡 SUMMARY:")
        print("- Your model has decision rules that look like the above")
        print("- Each tree makes decisions based on features like latitude, longitude, etc.")
        print("- The 'class:' part shows the prediction (0=Low, 1=Moderate, 2=High)")
        print("- The 'weights:' part shows how confident the model is")
        
    except FileNotFoundError:
        print("❌ ERROR: Could not find 'earthquake_risk_model.pkl'")
        print("💡 You need to run 'python ml_earthquake_risk.py' first to train the model!")
    except Exception as e:
        print(f"❌ ERROR: {e}")

if __name__ == "__main__":
    view_rules_simply() 