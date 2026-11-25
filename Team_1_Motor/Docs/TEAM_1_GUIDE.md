# Team 1 — Motor Drive, Weight Measurement & Mechanical Brake

## 1. Overview & Responsibilities
Team 1 is responsible for the actuation and payload safety subsystems of the 4-floor Mini Elevator:
- **DC Geared Hoist Motor Control**: Driving the cabin up, down, and holding stopped via H-Bridge driver.
- **Speed & Direction Control**: Using PIC16F877A CCP1 hardware PWM (`RC2`, Pin 17) and directional GPIOs (`RD0`, `RD1`).
- **Load Cell & HX711 24-bit ADC**: Bit-banged SPI measurement of cabin weight (`RA0` Data, `RA1` Clock), calibration in grams, and overload detection (> 1500 g).
- **Servo-Controlled Mechanical Brake**: Actuating a mechanical bicycle-style caliper brake on the motor pulley via RC Servo PWM (`RC1`, Pin 16).
- **Dedicated Power Supply**: Separate isolated power supply for motor and servo to protect PIC logic from inductive noise and brownouts.

---

## 2. Public Software Contract (`Team_1_Motor/Motor.h`)
Team 1 must implement the following exact functions in `Team_1_Motor/Code/Motor.c`:

```c
void Motor_Init(void);
void Motor_Update(void);

void Motor_Set(signed char direction, unsigned short speed_percent);
void Motor_Stop(void);

void Brake_Release(void);
void Brake_Engage(void);

unsigned long Weight_GetGrams(void);
unsigned char Weight_IsOverload(void);
```

### Operational Rules
1. **Direction**: Use `DIR_UP` (+1), `DIR_DOWN` (-1), or `DIR_STOP` (0) from `Shared/System_Types.h`.
2. **Speed**: Expressed as an integer percentage (0 to 100%). Default nominal speed is 65%.
3. **Brake Commands**:
   - `Brake_Release()`: Command servo to release brake pads (~2.0 ms pulse width at 50 Hz).
   - `Brake_Engage()`: Command servo to clamp brake pads (~1.0 ms pulse width at 50 Hz).
   - *CRITICAL SAFETY NOTE*: A servo command does NOT confirm that the brake has physically engaged. There is no brake feedback switch. Never claim or implement fake feedback.
4. **Weight Measurement**:
   - Return mass in grams via `Weight_GetGrams()`.
   - `Weight_IsOverload()` must return `1` if mass > `MAX_ALLOWED_WEIGHT_GRAMS` (1500 g), else `0`.
5. **Non-blocking Execution**: `Motor_Update()` is called every 10 ms; it must not use blocking delays.

---

## 3. Hardware Pin Assignments (PIC16F877A 40-Pin DIP)

| DIP Pin | Port Pin | Hardware Connection | Direction | Notes |
|:---:|:---:|:---|:---:|:---|
| **Pin 2** | `RA0 / AN0` | HX711 DT (Serial Data) | Input | Requires `ADCON1 = 0x06` |
| **Pin 3** | `RA1 / AN1` | HX711 SCK (Clock) | Output | Bit-banged pulse (>= 0.2 us) |
| **Pin 17** | `RC2 / CCP1` | Motor Driver ENA (PWM) | Output | Hardware PWM at ~1.22 kHz |
| **Pin 19** | `RD0` | Motor Driver IN1 (Dir) | Output | High for UP, Low for DOWN |
| **Pin 20** | `RD1` | Motor Driver IN2 (Dir) | Output | Low for UP, High for DOWN |
| **Pin 16** | `RC1 / CCP2` | Brake Servo Signal | Output | 50 Hz PWM control pulse |
| **Pin 15** | `RC0 / T1OSO` | Secondary Servo (Aux) | Output | Reserved for auxiliary mechanical role |

---

## 4. Power & Mechanical Safety Rules
1. **Power Isolation**: The DC motor and servo must be powered by an external 12V / 5V bench power supply. The PIC logic runs from a regulated 5V rail. Grounds must be tied together at a single common star-point.
2. **Independent Mechanical Support**: During all bench testing with a suspended cabin, always use an independent physical block or tether. **Never rely on the hobby servo brake alone to prevent a suspended load from dropping.**
3. **Worm Gear Consideration**: A worm-gear motor was evaluated for self-locking properties. Because of procurement constraints, a standard geared DC motor with an external servo friction brake is utilized.

---

## 5. Team 1 Remaining Checklist
- [ ] Implement `HX711` 24-bit read routine with calibration offset and scale factor in `Team_1_Motor/Code/`.
- [ ] Configure Timer2 and CCP1 for hardware PWM motor speed control.
- [ ] Implement Timer1-based 50 Hz servo pulse generator for `RC1` brake servo.
- [ ] Create Proteus simulation schematic for motor driver (L298N/L293D), HX711 test model, and servo in `Team_1_Motor/Simulation/`.
- [ ] Perform tare and calibration tests using known masses.
