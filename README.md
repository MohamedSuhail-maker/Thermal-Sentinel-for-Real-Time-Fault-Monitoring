# Thermal-Sentinel-for-Real-Time-Fault-Monitoring


A real-time thermal fault detection system using an **AMG8831 infrared thermal sensor** and **ESP32 microcontroller** to identify abnormal temperature patterns in electrical and mechanical equipment. The system performs edge-level analysis, generates alerts, and visualizes thermal data through a web-based dashboard.

---

## Project Overview

Abnormal heat generation is one of the earliest indicators of faults in electrical and mechanical systems. This project continuously monitors thermal patterns, detects hotspots and sudden temperature rise, and notifies users before failures escalate. The solution focuses on **preventive maintenance** using a low-cost and scalable embedded architecture.

---

## System Architecture

**AMG8831 Thermal Sensor ** → **ESP32 (Edge Processing)** → **Fault Detection Logic** → **Alerts & Web Dashboard**

---

## Hardware Interface

###  Sensor Interface

* **Master:** ESP32
* **Slave:** AMG8831 Thermal Sensor
* **Signals:** SDA, SCL

The ESP32 periodically reads 8×8 thermal frames (64 pixels) from the AMG8831 via I²C and processes the data in real time for fault detection.

---

## Fault Detection Methodology

The system identifies faults using a multi-level analysis approach:

* **Threshold-based detection:** Detects unsafe absolute temperature values
* **Spatial analysis:** Identifies localized hotspots
* **Temporal analysis:** Monitors sudden temperature rise over time

This combination improves reliability and reduces false positives.

---

## Alert & Visualization

* Email-based SMS alerts for fault notification
* Web dashboard for live thermal heatmap and temperature monitoring
* Real-time fault status display for remote supervision

---

## Folder Structure

```text
Thermal-Fault-Detection-System/
│
├── firmware/
│   ├── esp32_amg8831.ino        # ESP32 firmware (Arduino IDE)
│                   # Pin and threshold configuration
│
├── matlab/
│   ├── thermal_visualization.m  # Heatmap generation and analysis
│   └── data_processing.m        # Thermal data preprocessing
│
├── web-dashboard/ # Dashboard UI               # Data handling and visualization
│
├── docs/
│   ├── system_architecture.pdf
│   └── block_diagram.png
│
└── README.md
```

---

## Tech Stack

<!-- Tech stack badges -->

![Arduino](https://img.shields.io/badge/Arduino_IDE-00979D?style=flat\&logo=arduino\&logoColor=white)
![MATLAB](https://img.shields.io/badge/MATLAB-FF7F00?style=flat\&logo=mathworks\&logoColor=white)
![HTML](https://img.shields.io/badge/HTML5-E34F26?style=flat\&logo=html5\&logoColor=white)
![CSS](https://img.shields.io/badge/CSS3-1572B6?style=flat\&logo=css3\&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat\&logo=javascript\&logoColor=black)

### Hardware

* ESP32 Microcontroller
* AMG8831 Infrared Thermal Sensor

### Embedded Development

![Arduino](https://img.shields.io/badge/Arduino_IDE-00979D?style=flat\&logo=arduino\&logoColor=white)

* Arduino IDE
* Embedded C/C++
* I²C, Wi-Fi communication

### Data Processing & Visualization

![MATLAB](https://img.shields.io/badge/MATLAB-FF7F00?style=flat\&logo=mathworks\&logoColor=white)

* MATLAB
* Thermal data analysis
* Heatmap visualization

### Web Dashboard

![HTML](https://img.shields.io/badge/HTML5-E34F26?style=flat\&logo=html5\&logoColor=white)
![CSS](https://img.shields.io/badge/CSS3-1572B6?style=flat\&logo=css3\&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat\&logo=javascript\&logoColor=black)

* HTML5
* CSS3
* JavaScript

---

## Key Features

* Real-time thermal monitoring
* Edge-based fault detection
* Hotspot and anomaly identification
* Alert notification system
* Live thermal heatmap visualization
* Modular and scalable design

---

## Applications

* Electrical panel monitoring
* Motor and transformer fault detection
* Industrial equipment health monitoring
* Predictive maintenance systems
* Smart factory safety monitoring

---

## Limitations

* Low spatial resolution of the thermal sensor
* Environmental factors may affect accuracy
* Advanced ML inference requires further optimization

---

## Future Enhancements

* Machine learning–based fault classification
* Cloud-based data logging
* Higher-resolution thermal sensors
* Mobile application integration

---


## Author
##
**MOHAMED SUHAIL M**
* Embedded Systems | MATLAB | Thermal Fault Detection
 ##
**NABEEL AHMED I**
* Embedded Systems | MATLAB | Thermal Fault Detection
##
**MICHAEL ANTONY VIMALAN S**
* Web Dashboard | Embedded Systems
##
**MUGUNTHAN MS**
* Web Dashboard | Data Interface
##
**LOGESH D**
* Web Dashboard | Data Interface
##
**PRAVEEN S**
* Wi-Fi communication | application integration
