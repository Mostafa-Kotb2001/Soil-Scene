# 🌱 Soil Scene – Smart Farming Assistant
A Graduation Project (Flutter · Embedded Systems · AI)

## 📌 Project Overview
Soil Scene is a smart farming system designed to help farmers monitor soil conditions and make better irrigation decisions.

The embedded unit collects real-time soil data and sends it to Firebase Firestore.  
An AI model analyzes the data and determines whether the farm needs irrigation.  
The Flutter mobile application displays this information and allows the user to take action based on the AI recommendation.

---

## 👨‍💻 My Role
- Developed the Flutter mobile application from scratch.
- Integrated Firebase Authentication and Firestore for real-time data.
- Implemented AI irrigation recommendations in the UI.
- Built offline data storage using SQLite with sync support.
- Managed state and navigation using GetX.
- Integrated a chat system using REST APIs for user support.

---

## 📱 Flutter App Responsibilities
- Display real-time soil data from Firestore.
- Show AI irrigation suggestions (Needs Water / Does Not Need Water).
- Allow users to manually irrigate or ignore AI recommendations.
- Store irrigation history offline using SQLite.
- Provide in-app support via a Chat API.
- Ensure smooth navigation and efficient state management using GetX.

---

## 🛠️ Technologies Used
- Flutter & Dart
- Firebase Authentication
- Firebase Firestore
- SQLite (offline database)
- REST API (Chat system)
- GetX (state management)

---

## 📊 Real-Time Features
- Live dashboards for soil moisture, temperature, and humidity.
- Instant updates when AI changes irrigation status.
- Local history that syncs automatically when internet connectivity is restored.

---

## 🧩 System Architecture
Soil Sensors → Embedded Unit → Firebase → AI Model → Flutter App
