# AquaFusion: Smart Fish Feeding System

AquaFusion is a microcontroller-based automated fish feeding system designed as a capstone project. It integrates multiple sensors and actuators to dispense precise food amounts, detect feed flow, and monitor storage levels while offering real-time user feedback via TFT display and SMS alerts. The firmware was written in Embedded C using non-blocking `millis()` logic and a finite state machine for real-time control.

---

## 🔧 Features

* **Targeted feeding**: Dispenses food based on HX711 load cell measurements with 96.66% accuracy.
* **Two-gate dispensing system**: Sequential control using PWM-driven servo motors.
* **Feed spinner motor**: DC motor activated via relay logic to ensure consistent feed release.
* **Flow detection**: IR sensor checks for feed flow and flags blockages.
* **Storage monitoring**: Ultrasonic sensor calculates remaining feed level and triggers low-level alerts.
* **SMS Alerts**: GSM module sends notification to predefined phone number upon feeding completion.
* **TFT Display**: Displays real-time target vs actual feed weight.
* **Serial Command Control**: Parses commands like `feed:50`, `send_sms:+1234567890:done`, `spin`, and `calibrate`.
* **Real-time fault handling**: Timeout handling for feeding and GSM operations.

---

## ⚙️ Hardware Used

* Arduino Uno
* HX711 Load Cell Amplifier + Load Cell
* 2x Servo Motors (Sliding Gate Control)
* DC Motor + Relay Module (Spinner)
* IR Obstacle Sensor
* HC-SR04 Ultrasonic Sensor
* SIM800L GSM Module
* Adafruit ST7735 TFT Display

---

## 🎓 Key Functional Modules

### State Machine

```cpp
enum State {
  IDLE,
  FEEDING,
  SPIN,
  SMS,
  CALIBRATE_WEIGHT
};
```

* Ensures system remains responsive and transitions smoothly between operational phases using finite state control.

### Serial Command Parsing

Accepts serial commands to operate:

* `feed:50` — sets target feed weight and begins feeding cycle
* `send_sms:+1234567890:Feeding done` — sends SMS alert
* `spin` — manually trigger spinner motor
* `calibrate` — reads load cell for recalibration

### Feeding Sequence

1. Tares load cell.
2. Opens servo gate until 90% of target weight is achieved.
3. Starts spinner and ramps for 3 seconds.
4. Verifies feed flow with IR sensor.
5. Opens second gate for final release.
6. Sends SMS confirmation.
7. Displays weight info on TFT screen.

---

## 💡 Core Protocols and Interfaces

* **UART**: GSM SMS transmission, serial command input/output
* **I2C**: HX711 load cell
* **PWM**: Servo motor positioning
* **GPIO**: IR sensor, DC motor relay, ultrasonic TRIG/ECHO, TFT screen

---

## 🏆 Achievements

* Achieved 96.66% feed dispensing accuracy
* Under 2-second actuation response time
* Top 2 Best Capstone Project (Automation Track), UST IT Colloquium 2024

---

## 🚀 Future Improvements

* Migrate to STM32 platform for RTOS integration and finer control
* Add EEPROM or SD card support for feed history logging
* Implement watchdog timers for fail-safe recovery
* Refactor to completely eliminate `delay()` in favor of fully non-blocking behavior

---

## 📖 License

MIT License
