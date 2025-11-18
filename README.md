# 🌱 Soil Scene – Smart Farming Assistant

A Graduation Project (Flutter · Embedded · AI)

## 📌 Project Overview
Soil Scene is a smart farming system designed to help farmers monitor soil conditions and make better irrigation decisions.

The embedded unit collects real-time soil data and sends it to Firebase Firestore.
The AI model analyzes the data and recommends whether the farm needs water or not.
The Flutter app displays this data and allows the user to take action based on the AI recommendation.

---

## 📱 Flutter App Responsibilities
- Display real-time soil data from Firestore.
- Show AI irrigation suggestions (Needs Water / Does Not Need Water).
- Allow user to manually irrigate or ignore the suggestion.
- Save history offline using SQLite.
- Communicate with support through a built-in Chat API.
- Provide smooth navigation and state management using GetX.

---

## 🛠️ Technologies Used
- **Flutter & Dart**
- **Firebase Authentication**
- **Firebase Firestore**
- **SQLite** (offline database)
- **REST API** (Chat system)
- **GetX** (state management)

---

## 📊 Real-Time Features
- Live dashboards for soil moisture, temperature, and humidity.
- Instant updates when AI changes irrigation status.
- Local history that syncs when internet is available.

