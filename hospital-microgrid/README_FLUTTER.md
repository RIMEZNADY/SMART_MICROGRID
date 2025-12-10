# Hospital Microgrid - Flutter App

A Flutter application for monitoring and managing a hospital microgrid system with AI-powered predictions and auto-learning capabilities.

## Features

- **Dashboard**: Real-time energy monitoring with charts and metrics
- **AI Prediction**: Machine learning-powered 24-hour energy demand forecasting
- **Auto-Learning**: Self-learning system that continuously improves energy management
- **History**: Long-term energy consumption and generation trend analysis

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)

### Installation

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── pages/
│   ├── dashboard.dart       # Dashboard page
│   ├── ai_prediction.dart   # AI Prediction page
│   ├── auto_learning.dart   # Auto-Learning page
│   └── history.dart         # History page
└── widgets/
    ├── navigation.dart      # Navigation bar widget
    └── metric_card.dart     # Metric card widget
```

## Dependencies

- `fl_chart`: For creating beautiful charts
- `google_fonts`: For typography

## Screenshots

The app features a dark theme with gradient accents matching the original Next.js design.

