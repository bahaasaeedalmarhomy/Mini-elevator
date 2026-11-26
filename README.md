# PIC16F877A 4-Floor Mini Elevator Control System

An educational four-floor elevator control system powered by a single Microchip PIC16F877A microcontroller running at 20 MHz. The firmware is structured into three decoupled engineering modules communicating via strict, stable C contracts.

---

## 1. Repository Structure

```text
Mini-Elevator/
│
├── Shared/
│   └── System_Types.h            <- Common types, states, floor defines, timing constants
│
├── Team_1_Motor/
│   ├── Motor.h                   <- Public interface contract for Team 1
│   ├── Code/                     <- Team 1 source code (Motor, PWM, HX711, Servo Brake)
│   ├── Simulation/               <- Proteus simulation files and test models
│   └── Docs/                     <- Wiring diagrams, pinouts, and subsystem documentation
│
├── Team_2_Inputs/
│   ├── Inputs.h                  <- Public interface contract for Team 2
│   ├── Keypad_Config.h           <- Keypad matrix, landing button & sensor pin configuration
│   ├── Code/                     <- Team 2 source code (Keypad, Buttons, Hall, LCD, Buzzer)
│   ├── Simulation/               <- Proteus simulation files and HMI models
│   └── Docs/                     <- Wiring diagrams, pinouts, and subsystem documentation
│
├── Team_3_Controller/
│   ├── Controller.h              <- Public interface contract for Team 3
│   ├── RequestHandler.h          <- Public interface for FIFO request queue
│   ├── Code/
│   │   ├── Controller.c          <- Master Finite State Machine (FSM) implementation
│   │   ├── RequestHandler.c      <- Simplified fixed-size array request handler (FIFO)
│   │   ├── main.c                <- Super-loop master integration entry point (10 ms ticks)
│   │   └── test_suite.c          <- Complete 15-scenario automated verification test harness
│   ├── Simulation/               <- Integrated Proteus project & simulation test checklist
│   └── Docs/                     <- State machine diagrams, timing guides, and integration docs
│
└── README.md                     <- Master project documentation and build guide
```

---

## 2. Team Subsystem Overview & Public Interfaces

### Team 1 — Motor Drive, Weight Measurement & Mechanical Brake
- **Hardware**: DC Hoist Motor with H-Bridge driver, HX711 24-bit ADC with strain-gauge load cell, RC servo motor actuating mechanical friction brake on hoist pulley, and dedicated power supply.
- **Contract Header**: `Team_1_Motor/Motor.h`
- **Exposed Functions**:
  - `void Motor_Init(void);`
  - `void Motor_Update(void);`
  - `void Motor_Set(signed char direction, unsigned short speed_percent);`
  - `void Motor_Stop(void);`
  - `void Brake_Release(void);`
  - `void Brake_Engage(void);`
  - `unsigned long Weight_GetGrams(void);`
  - `unsigned char Weight_IsOverload(void);`

### Team 2 — Inputs, Sensors, Display & Buzzer
- **Hardware**: 3x3 matrix keypad (internal car calls), 4 landing call pushbuttons, 4 Hall effect floor positioning sensors, 16x2 alphanumeric LCD (4-bit parallel bus), and acoustic piezo buzzer.
- **Contract Header**: `Team_2_Inputs/Inputs.h` & `Team_2_Inputs/Keypad_Config.h`
- **Exposed Functions**:
  - `void Inputs_Init(void);`
  - `void Inputs_Update(void);`
  - `unsigned char Inputs_GetNewFloorRequest(unsigned char *floor);`
  - `unsigned char Inputs_GetCurrentFloor(void);`
  - `unsigned char Inputs_IsFloorSensorFault(void);`
  - `void Inputs_DisplayStatus(unsigned char current, unsigned char target, unsigned char state, unsigned long weight);`
  - `void Inputs_Buzzer(unsigned char event_code);`

### Team 3 — Main Controller & Systems Integration
- **Software**: Supervisory Finite State Machine (FSM), deterministic FIFO request queue, pre-flight safety interlocks, stall timeout detection, and master super-loop.
- **Contract Headers**: `Team_3_Controller/Controller.h` & `Team_3_Controller/RequestHandler.h`
- **Core Files**: `Controller.c`, `RequestHandler.c`, `main.c`.

---

## 3. Floor Numbering & Shared System Constants

All shared constants are defined in `Shared/System_Types.h`:

- **Floors**:
  - `FLOOR_0` = 0 (Ground level)
  - `FLOOR_1` = 1 (Level 1)
  - `FLOOR_2` = 2 (Level 2)
  - `FLOOR_3` = 3 (Level 3)
  - `FLOOR_COUNT` = 4
  - `NO_FLOOR` = 255 (Represents `(unsigned char)-1` when in-flight / between floors)
- **Motor Direction**: `DIR_STOP` (0), `DIR_UP` (1), `DIR_DOWN` (-1)
- **Controller States**:
  - `STATE_WAIT_FOR_FLOOR` (0)
  - `STATE_IDLE` (1)
  - `STATE_BRAKE_RELEASE` (2)
  - `STATE_MOVING_UP` (3)
  - `STATE_MOVING_DOWN` (4)
  - `STATE_STOPPING` (5)
  - `STATE_BRAKE_ENGAGE` (6)
  - `STATE_OVERLOAD` (7)
  - `STATE_SENSOR_FAULT` (8)
- **Buzzer Events**:
  - `BUZZER_ARRIVAL` (1)
  - `BUZZER_OVERLOAD` (2)
  - `BUZZER_SENSOR_FAULT` (3)
  - `BUZZER_STARTUP` (4)

---

## 4. Master Pin Allocation (PIC16F877A 40-Pin DIP)

| Pin | Port Pin | Function | Owner | Direction | Electrical Notes |
|:---:|:---:|:---|:---:|:---:|:---|
| 1 | `MCLR` | System Reset | System | Input | 10k pull-up to +5V |
| 2 | `RA0 / AN0` | HX711 Serial Data (DT) | Team 1 | Input | Digital bitstream (`ADCON1 = 0x06`) |
| 3 | `RA1 / AN1` | HX711 Serial Clock (SCK) | Team 1 | Output | Clock pulses (>= 0.2 us) |
| 4 | `RA2 / AN2` | Floor 0 Landing Button | Team 2 | Input | Active LOW; 10k pull-up |
| 5 | `RA3 / AN3` | Floor 1 Landing Button | Team 2 | Input | Active LOW; 10k pull-up |
| 6 | `RA4 / T0CKI`| Floor 2 Landing Button | Team 2 | Input | **OPEN-DRAIN! Mandatory 4.7k external pull-up** |
| 7 | `RA5 / AN4` | Floor 3 Landing Button | Team 2 | Input | Active LOW; 10k pull-up |
| 8 | `RE0 / AN5` | Keypad Row 1 Drive | Team 2 | Output | Active LOW cyclic drive (`TRISE.PSPMODE=0`) |
| 9 | `RE1 / AN6` | Keypad Row 2 Drive | Team 2 | Output | Active LOW cyclic drive |
| 10 | `RE2 / AN7` | Keypad Row 3 Drive | Team 2 | Output | Active LOW cyclic drive |
| 11, 32 | `VDD` | Logic Power (+5V) | System | Power | Decoupled with 0.1 uF to GND |
| 12, 31 | `VSS` | Logic Ground (0V) | System | Power | Common star-point ground |
| 13 | `OSC1` | Oscillator Input | System | Input | 20 MHz crystal + 22 pF cap |
| 14 | `OSC2` | Oscillator Output | System | Output | 20 MHz crystal + 22 pF cap |
| 15 | `RC0` | Secondary Auxiliary Servo | Team 1 | Output | 50 Hz PWM (reserved) |
| 16 | `RC1 / CCP2` | Brake Servo Signal | Team 1 | Output | 50 Hz PWM (1.0ms Brake, 2.0ms Release) |
| 17 | `RC2 / CCP1` | Motor Driver ENA (PWM) | Team 1 | Output | Hardware PWM at ~1.22 kHz |
| 18 | `RC3` | Hall Sensor Floor 0 | Team 2 | Input | Active LOW; 10k pull-up |
| 19 | `RD0` | Motor Driver IN1 (Dir) | Team 1 | Output | High for UP, Low for DOWN |
| 20 | `RD1` | Motor Driver IN2 (Dir) | Team 1 | Output | Low for UP, High for DOWN |
| 21 | `RD2` | LCD RS | Team 2 | Output | Alphanumeric LCD Register Select |
| 22 | `RD3` | LCD EN | Team 2 | Output | Alphanumeric LCD Clock Enable |
| 23 | `RC4` | Hall Sensor Floor 1 | Team 2 | Input | Active LOW; 10k pull-up |
| 24 | `RC5` | Hall Sensor Floor 2 | Team 2 | Input | Active LOW; 10k pull-up |
| 25 | `RC6` | Hall Sensor Floor 3 | Team 2 | Input | Active LOW; 10k pull-up |
| 26 | `RC7` | Buzzer Drive | Team 2 | Output | Active HIGH to 2N2222 NPN transistor base |
| 27 | `RD4` | LCD D4 | Team 2 | Output | 4-bit data bus |
| 28 | `RD5` | LCD D5 | Team 2 | Output | 4-bit data bus |
| 29 | `RD6` | LCD D6 | Team 2 | Output | 4-bit data bus |
| 30 | `RD7` | LCD D7 | Team 2 | Output | 4-bit data bus |
| 33 | `RB0` | Keypad Column 1 Read | Team 2 | Input | Weak pull-up (`OPTION_REG.NOT_RBPU = 0`) |
| 34 | `RB1` | Keypad Column 2 Read | Team 2 | Input | Weak pull-up |
| 35 | `RB2` | Keypad Column 3 Read | Team 2 | Input | Weak pull-up |
| 36-38 | `RB3-RB5` | Reserved / NC | System | NC | Configured as inputs |
| 39, 40 | `RB6, RB7` | ICSP PGC / PGD | System | I/O | Reserved for PICkit programmer |

---

## 5. Build & Integration Instructions (mikroC PRO for PIC)

1. **Create New Project**:
   - Open mikroC PRO for PIC.
   - Device: `P16F877A`.
   - Clock Frequency: `20.000000 MHz`.
2. **Add Source Files**:
   - `Team_3_Controller/Code/main.c`
   - `Team_3_Controller/Code/Controller.c`
   - `Team_3_Controller/Code/RequestHandler.c`
   - `Team_1_Motor/Code/Motor.c` (when completed by Team 1)
   - `Team_2_Inputs/Code/Inputs.c` (when completed by Team 2)
3. **Include Search Paths**:
   - Add project root and `Shared/` to the project search paths.
4. **Configuration Bits**:
   - Oscillator: HS
   - Watchdog Timer: Disabled
   - Power-up Timer: Enabled
   - Brown-out Reset: Enabled
   - Low-Voltage Programming: Disabled (RB3 freed for general I/O)
5. **Build**:
   - Press `Ctrl + F9` to compile and generate `Mini_Elevator.hex`.

---

## 6. Safety & Scope Boundaries
- **Prototype Status**: This system is an educational laboratory prototype, not a passenger-carrying elevator.
- **Brake Feedback**: A hobby servo command does not confirm physical mechanical friction engagement. Never rely on the brake servo alone to protect against falling loads during suspended testing; always install a physical safety block.
- **Rope Failure Detection**: Not implemented in software because electrical/load-cell sensor criteria have not been validated. Documented as future research.
- **Power Isolation**: The DC motor and servo must have an independent, isolated power supply sharing a single ground star-point with the logic supply.
# Mini-elevator
