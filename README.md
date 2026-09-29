\# 🌍 Earthquake Risk Assessment App

A Flutter mobile application that uses **USGS earthquake data and machine learning** to assess earthquake risk based on the user's location.

## 📱 Overview

The application collects earthquake data from the **USGS Earthquake Catalog API** and uses a **Random Forest machine learning model** to classify locations into:

* 🟢 Low Risk
* 🟡 Moderate Risk
* 🔴 High Risk

Users can view recent earthquake information, check their location's risk level, and explore earthquake activity on a map.

## ✨ Features

* 📍 GPS-based location detection
* 🌍 Earthquake data from the USGS API
* 🤖 Random Forest machine learning model
* 📊 Low, Moderate and High risk classification
* 🗺️ Interactive earthquake map
* 📋 Recent earthquake information
* 📚 Earthquake safety and educational information
* 📱 Responsive Flutter interface

## 🧠 Machine Learning

The model was trained using earthquake data collected from the **USGS Earthquake Catalog**.

**Model:** Random Forest Classifier

**Features include:**

* Latitude
* Longitude
* Depth
* Magnitude
* Distance to major fault areas

The machine learning pipeline was developed in **Python using Scikit-learn, Pandas and NumPy**.

> **Note:** The model evaluation results depend on the dataset and classification method used during training.

## 🛠️ Technologies

**Mobile App**

* Flutter
* Dart
* Google Maps

**Machine Learning**

* Python
* Scikit-learn
* Pandas
* NumPy

**Data**

* USGS Earthquake Catalog API

## 🔄 How It Works

```text
USGS Earthquake Data
        ↓
Data Processing
        ↓
Machine Learning Model
        ↓
Risk Classification
        ↓
Flutter Mobile App
        ↓
User Risk Result
```

## 🚀 Getting Started

### Requirements

* Flutter SDK
* Dart
* Python 3.9+
* Internet connection

### Run the project

```bash
git clone <repository-url>
cd earthquake

flutter pub get
flutter run
```

If you want to retrain the machine learning model:

```bash
pip3 install -r requirements.txt
python3 ml_earthquake_risk.py
```

## 🎯 Project Purpose

This project was developed as an **MSc Computing project** to explore the use of **machine learning, location services and real-world earthquake data** in a mobile application.

## 🔮 Future Improvements

* Historical earthquake risk trends
* Improved machine learning models
* More detailed geological data
* Emergency preparedness information
* Improved risk visualisation

## 👨‍💻 Author

**Min Thant Phyo**

MSc Computing Graduate

* GitHub: https://github.com/mewyyuu
* LinkedIn: https://www.linkedin.com/in/min-thant-phyo-089911274/
* Email: [minthantphyo123@gmail.com](mailto:minthantphyo123@gmail.com)

---

⭐ If you find this project interesting, feel free to explore the repository.
