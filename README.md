# SafeRide

SafeRide is a mobile application designed to enhance passenger safety in public transportation. The application enables users to verify vehicles before boarding, report unsafe incidents, share their live location with trusted contacts, and access emergency assistance when required.

By combining vehicle verification, community-driven reporting, live ride tracking, and emergency alerts into a single platform, SafeRide aims to help users make safer travel decisions and improve accountability within public transportation systems.

## Problem Statement

Passengers often have limited information about the safety and reliability of public transport vehicles before boarding. Existing solutions generally focus on navigation or booking services and rarely provide safety-focused features such as vehicle verification, incident reporting, and emergency assistance.

SafeRide addresses this gap by providing a centralized platform where users can verify vehicles, review safety-related information, report concerns, and quickly reach out for help during emergencies.

## Features

### Vehicle Verification

Users can scan a vehicle's registration number using their smartphone camera. The application uses Optical Character Recognition (OCR) to extract the vehicle number and retrieve relevant information from the database.

### Safety Reporting System

Users can submit reports regarding unsafe behavior, suspicious activity, reckless driving, or other safety concerns associated with a vehicle.

### Vehicle Rating System

Vehicles are assigned ratings based on user experiences and submitted reports. These ratings help passengers make informed decisions before boarding.

### Live Location Sharing

Users can share their real-time location with trusted contacts during a journey, allowing friends and family to monitor their trip.

### Emergency SOS

The application provides a one-tap SOS feature that sends emergency messages containing the user's current location to predefined contacts. SMS-enables to ensure working even in low internet-connectivity areas

### Safety Dashboard

Users can access vehicle safety information, complaint history, and community feedback through a centralized dashboard.

## Tech Stack

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Google ML Kit OCR
* Geolocator
* URL Launcher

## How It Works

1. The user scans a vehicle's registration number.
2. OCR extracts the registration details.
3. The application retrieves available vehicle information, ratings, and reports.
4. The user can review safety information before boarding.
5. During the journey, the user may share their live location with trusted contacts.
6. In case of an emergency, the SOS feature can be activated to send location-based alerts.

## Future Improvements

* AI-based vehicle risk assessment
* Verified driver profiles
* Integration with law enforcement databases
* Real-time incident heatmaps
* Advanced analytics and safety insights
* Anonymous community reporting

## Objective

The primary objective of SafeRide is to improve passenger safety by providing accessible safety information, community-driven reporting mechanisms, and emergency support tools within a single mobile application.
