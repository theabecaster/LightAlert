
# Light Alert

**Light Alert** is a mobile application designed to assist drivers by detecting traffic lights and notifying them when the light turns green. The app utilizes a custom-trained Core ML model to analyze a live camera feed in real time, providing sound and haptic feedback to alert the user.

---

## 🚀 Features

- **Real-Time Traffic Light Detection**:
  Detects traffic lights directly from the live camera feed.
  
- **Green Light Notification**:
  Alerts the user with sound and vibration when the light turns green.

- **Simple User Interface**:
  Minimalistic design for safe and distraction-free use.

- **Welcome Screen with Instructions**:
  Includes a guide to help users set up and use the app effectively.

---

## 🛠️ Technologies Used

### **Languages**
- **Swift**:
  - Used for the entire app development, including SwiftUI for the user interface and Combine for state management.

### **Frameworks**
- **Core ML**:
  - Powers the machine learning model for traffic light detection.
  
- **Vision**:
  - Processes the camera feed and passes frames to the Core ML model for inference.

- **AVFoundation**:
  - Manages the live camera feed for real-time detection.

- **Core Haptics**:
  - Provides tactile feedback when the light turns green.

- **SwiftUI**:
  - Implements a modern, declarative UI for a clean and simple user experience.

### **Custom Machine Learning Model**
- The app uses a **custom-trained Core ML model** created with **Create ML**:
  - Trained on labeled images of traffic lights (red, yellow, green) and background scenes.
  - Optimized for real-time performance and high accuracy.

### **Others**
- **Combine**:
  - Manages app state and data flow between the ViewModel and Views.

---

## 📱 How It Works

1. **Set Up**:
   - Mount your phone on your car's dashboard with a clear view of the road.

2. **Detection**:
   - The app processes the live camera feed and identifies traffic lights in real time.

3. **Notification**:
   - When the light turns green, the app provides:
     - **Sound Notification**: A "ding" sound.
     - **Haptic Feedback**: A vibration alert.

---

## 🚧 Future Enhancements
- Improved model accuracy with additional training data.
- Multi-language support.
- Advanced notifications for other traffic conditions.

---

## 🏗️ Project Structure

```plaintext
TrafficLightDetector/
├── Models/
│   ├── TrafficLightClassifier.mlmodel  # Custom Core ML model
├── ViewModels/
│   ├── CameraViewModel.swift           # Manages camera and detection logic
├── Views/
│   ├── WelcomeView.swift               # Welcome screen with instructions
│   ├── ContentView.swift               # Live detection view
│   ├── CameraView.swift                # Displays the live camera feed
├── Resources/
│   ├── AppIcon/                        # App icon assets
│   ├── ding.mp3                        # Notification sound
├── TrafficLightDetectorApp.swift       # App entry point
├── README.md                           # Project description (you’re here!)
```

---

## 📦 Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/theabecaster/LightAlert.git
   ```

2. Open the project in Xcode:
   ```bash
   cd traffic-light-detector
   open TrafficLightDetector.xcodeproj
   ```

3. Build and run the app on a physical iOS device.

---

## 📝 License

This project is licensed under the **MIT License**. See the `LICENSE` file for more details.

---

## 👨‍💻 Author

- **Abraham Gonzalez**  
  [GitHub](https://github.com/theabecaster) | [Email](mailto:developerabe0@gmail.com)

---

## 🌟 Acknowledgments

- Apple’s **Core ML** and **Create ML** for making machine learning integration seamless.
- **Combine** and **SwiftUI** for simplifying state management and UI development.
- The **Xcode IDE** for providing a streamlined development experience.
