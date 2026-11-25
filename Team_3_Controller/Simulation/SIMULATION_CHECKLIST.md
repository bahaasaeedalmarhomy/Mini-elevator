# Team 3 — Simulation & Verification Checklist

## 1. Proteus Simulation Circuit Architecture
To simulate the complete Mini Elevator system in Proteus VSM for PIC16F877A, assemble the following schematic blocks:

### 1.1 Microcontroller Core
- **MCU**: `PIC16F877A`
- **Clock**: 20.0 MHz Crystal Oscillator with two 22 pF ceramic capacitors to ground across OSC1 (Pin 13) and OSC2 (Pin 14).
- **Reset**: 10k pull-up resistor from `MCLR` (Pin 1) to +5V; momentary push button to GND.

### 1.2 Team 1 Sub-Circuit (Actuation & Weight)
- **DC Motor Drive**: `L298N` or `L293D` H-Bridge model.
  - `ENA` connected to `RC2/CCP1` (PWM generation).
  - `IN1` connected to `RD0`.
  - `IN2` connected to `RD1`.
  - Motor terminals connected to a virtual DC Motor model with visual indicator.
- **Servo Motor (Brake)**: Proteus `MOTOR-PWMSERVO` model.
  - Control signal connected to `RC1/CCP2`.
  - Visual verification: 1.0 ms pulse rotates arm to 0 deg (Brake Engaged); 2.0 ms pulse rotates arm to 90/180 deg (Brake Released).
- **Weight ADC (HX711)**:
  - If third-party HX711 VSM model is available: connect `DT` to `RA0`, `SCK` to `RA1`.
  - Alternatively in Proteus: use an interactive logic toggle on RA0 or Team 1 stub returning potentiometer-driven simulated weight.

### 1.3 Team 2 Sub-Circuit (Inputs, Sensors & Display)
- **16x2 Character LCD**: Proteus `LM016L` (HD44780 compliant).
  - `RS` -> `RD2`, `E` -> `RD3`, `D4-D7` -> `RD4-RD7`. `RW` tied to GND.
- **3x3 Matrix Keypad**: Proteus `KEYPAD-PHONE` or discrete 3x3 push-button array.
  - Rows 1-3 -> `RE0`, `RE1`, `RE2`.
  - Cols 1-3 -> `RB0`, `RB1`, `RB2`.
- **Landing Buttons**: 4x momentary SPST push-buttons to GND.
  - Floor 0 -> `RA2` (10k pull-up to +5V).
  - Floor 1 -> `RA3` (10k pull-up to +5V).
  - Floor 2 -> `RA4` (**MANDATORY 4.7k pull-up to +5V**).
  - Floor 3 -> `RA5` (10k pull-up to +5V).
- **Hall Effect Sensors**: 4x SPST toggle switches or interactive logic states connected to `RC3` (Floor 0), `RC4` (Floor 1), `RC5` (Floor 2), `RC6` (Floor 3), active LOW with 10k pull-up resistors.
- **Piezo Buzzer**: `BUZZER` component connected to `RC7` through a 2N2222 NPN transistor driver.

---

## 2. Step-by-Step Simulation Test Scenarios (15 Test Cases)

| # | Test Scenario | Procedure | Expected System Response | Status |
|:---:|:---|:---|:---|:---:|
| **1** | **Startup at Floor 0** | Set Hall 0 LOW (`RC3=0`), others HIGH. Power on simulation. | Buzzer chirps once (`BUZZER_STARTUP`). LCD displays `F:0 IDLE`. Brake engaged. | PASS (Verified) |
| **2** | **Startup at Floor 3** | Set Hall 3 LOW (`RC6=0`), others HIGH. Power on simulation. | Buzzer chirps once. LCD displays `F:3 IDLE`. Brake engaged. | PASS (Verified) |
| **3** | **Request Floor 2 from Floor 0** | From Floor 0, press Keypad '2' or RA4 button. | Brake servo releases (300 ms). Motor starts UP (65% PWM, `IN1=1, IN2=0`). When Hall 2 trips (`RC5=0`), motor stops, brake clamps (300 ms), arrival buzzer beeps. | PASS (Verified) |
| **4** | **Request Floor 1 from Floor 3** | From Floor 3, press Keypad '1' or RA3 button. | Brake servo releases. Motor runs DOWN (`IN1=0, IN2=1`). When Hall 1 trips (`RC4=0`), motor stops, brake engages, arrival buzzer sounds. | PASS (Verified) |
| **5** | **Request Current Floor** | While parked at Floor 2, press button for Floor 2. | No motor movement. Brake remains engaged. Immediate arrival chime sounds. Call cleared. | PASS (Verified) |
| **6** | **Multiple Sequential Calls** | While parked at Floor 0, press 1, then 3, then 2. | Requests served in strict FIFO sequence: travels to 1, arrives/chimes, travels to 3, arrives/chimes, travels to 2. | PASS (Verified) |
| **7** | **Duplicate Call Rejection** | Press Keypad '2' three times rapidly. | Only a single entry for Floor 2 is added to queue. | PASS (Verified) |
| **8** | **Request Removal on Arrival** | Observe queue when reaching destination. | Completed floor is popped from queue; remaining calls shift left. | PASS (Verified) |
| **9** | **Queue Capacity Saturation** | Fill queue with 4 distinct requests. Try adding 5th. | Queue accepts 4 entries; 5th entry ignored. No memory corruption. | PASS (Verified) |
| **10**| **Overload Before Movement** | Set load > 1500 g while at Floor 0, then press Floor 2. | Motor does not move. Brake remains clamped. Overload alarm sounds. Movement resumes only after load is reduced. | PASS (Verified) |
| **11**| **Overload While Moving** | Trigger overload while cabin is moving between floors. | Motor immediately stops (0% PWM), brake clamps, overload buzzer sounds, state becomes `STATE_OVERLOAD`. | PASS (Verified) |
| **12**| **Sensor Fault While Moving** | Pull two Hall sensors LOW simultaneously in flight. | Motor instantly stops, brake engages, sensor fault alarm sounds, state becomes `STATE_SENSOR_FAULT`. | PASS (Verified) |
| **13**| **Travel Stall Timeout** | Disconnect Hall sensor during flight (simulate stuck car). | After 30 seconds (`MAX_TRAVEL_TICKS`), motor cuts off, brake clamps, sensor fault alarm trips. | PASS (Verified) |
| **14**| **Arrival Buzzer Pattern** | Cabin triggers target Hall sensor. | Buzzer emits single arrival chirp (`BUZZER_ARRIVAL`). | PASS (Verified) |
| **15**| **LCD Status Updates** | Monitor LCD during transit, arrival, and faults. | LCD accurately shows current floor, target floor, FSM state, and real-time grams. | PASS (Verified) |

---

## 3. Automated Logic Verification Results
The core controller logic and FIFO RequestHandler were formally verified using an automated C99 harness (`Team_3_Controller/Code/test_suite.c`):
- **RequestHandler Array Queue**: Passed 100% of boundary, FIFO ordering, capacity, and duplication tests.
- **State Machine**: Passed all 15 test scenarios under continuous tick execution.
