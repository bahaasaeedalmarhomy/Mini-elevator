# Team 2 — Inputs, Sensors, Display & Buzzer

## 1. Overview & Responsibilities
Team 2 is responsible for the human-machine interface (HMI), sensory feedback, and audio-visual signaling of the Mini Elevator:
- **3x3 Matrix Keypad**: Scans passenger internal destination calls (Floor 0 to Floor 3).
- **4 External Pushbuttons**: Detects landing calls stationed at Floor 0, 1, 2, and 3.
- **4 Hall Effect Sensors**: Detects physical arrival at Floor 0, 1, 2, and 3 via permanent magnets.
- **16x2 Character LCD**: Renders current floor, target floor, FSM state, and cabin weight in 4-bit mode.
- **Audio Buzzer**: Provides non-blocking acoustic patterns for arrival chime, overload alarm, sensor fault, and startup confirmation.

---

## 2. Public Software Contract (`Team_2_Inputs/Inputs.h`)
Team 2 must implement the following exact functions in `Team_2_Inputs/Code/Inputs.c`:

```c
void Inputs_Init(void);
void Inputs_Update(void);

unsigned char Inputs_GetNewFloorRequest(unsigned char *floor);
unsigned char Inputs_GetCurrentFloor(void);
unsigned char Inputs_IsFloorSensorFault(void);

void Inputs_DisplayStatus(
    unsigned char current_floor,
    unsigned char target_floor,
    unsigned char controller_state,
    unsigned long weight_grams
);

void Inputs_Buzzer(unsigned char event_code);
```

### Operational Rules
1. **Floor Indices**: All floors are indexed `0, 1, 2, 3` (`FLOOR_0` to `FLOOR_3`).
2. **`Inputs_GetNewFloorRequest(unsigned char *floor)`**:
   - Must debounce keypad and button inputs (e.g. 20-30 ms debounce filter).
   - Returns `1` when a fresh keypress is registered, writing the floor index (0..3) to `*floor`.
   - Returns `0` if no new keypress is pending.
3. **`Inputs_GetCurrentFloor()`**:
   - Reads Hall sensors (`RC3` to `RC6`).
   - If exactly one sensor is active, returns that floor index (`FLOOR_0`..`FLOOR_3`).
   - If the cabin is in transit between floors (no sensor tripped), returns `NO_FLOOR` (255).
4. **`Inputs_IsFloorSensorFault()`**:
   - Returns `1` if two or more Hall sensors are active simultaneously (physical/wiring short).
   - Otherwise returns `0`.
5. **`Inputs_DisplayStatus(...)`**:
   - Formats and displays status on 16x2 LCD. Example layout:
     ```text
     F:0->2 [UP]
     W: 450g OK
     ```
6. **`Inputs_Buzzer(unsigned char event_code)`**:
   - Generates non-blocking acoustic tones for:
     - `BUZZER_ARRIVAL` (1): Single pleasant arrival beep (150 ms).
     - `BUZZER_OVERLOAD` (2): Rapid warning pulses while overload persists.
     - `BUZZER_SENSOR_FAULT` (3): Alternating alarm pulses.
     - `BUZZER_STARTUP` (4): Short power-on chirp (100 ms).

---

## 3. Hardware Pin Assignments & Keypad Configuration

Refer to `Team_2_Inputs/Keypad_Config.h` for complete register defines.

### 3x3 Keypad Matrix (Rows RE0-RE2, Cols RB0-RB2)
```text
           COL 1 (RB0)     COL 2 (RB1)     COL 3 (RB2)
ROW 1 (RE0)      '1'             '2'             '3'
ROW 2 (RE1)      '4'             '5'             '6'
Optional: ROW 3  '7'             '8'             '9'
ROW 4 (RE2)      '*'             '0'             '#' 
```
- **Key 0** -> Floor 0
- **Key 1** -> Floor 1
- **Key 2** -> Floor 2
- **Key 3** -> Floor 3
- Keys 4–9, *, # -> Reserved for diagnostics and testing

### Pin Mapping Table

| DIP Pin | Port Pin | Hardware Connection | Direction | Crucial Electrical Details |
|:---:|:---:|:---|:---:|:---|
| **Pin 4** | `RA2 / AN2` | Floor 0 Landing Button | Input | Active LOW; 10k external pull-up |
| **Pin 5** | `RA3 / AN3` | Floor 1 Landing Button | Input | Active LOW; 10k external pull-up |
| **Pin 6** | `RA4 / T0CKI`| Floor 2 Landing Button | Input | **OPEN-DRAIN! MANDATORY 4.7k external pull-up** |
| **Pin 7** | `RA5 / AN4` | Floor 3 Landing Button | Input | Active LOW; 10k external pull-up |
| **Pin 8** | `RE0 / AN5` | Keypad Row 1 Drive | Output | Active LOW drive |
| **Pin 9** | `RE1 / AN6` | Keypad Row 2 Drive | Output | Active LOW drive |
| **Pin 10**| `RE2 / AN7` | Keypad Row 3 Drive | Output | Active LOW drive |
| **Pin 33**| `RB0 / INT` | Keypad Col 1 Read | Input | Weak pull-up (`OPTION_REG.NOT_RBPU = 0`) |
| **Pin 34**| `RB1` | Keypad Col 2 Read | Input | Weak pull-up |
| **Pin 35**| `RB2` | Keypad Col 3 Read | Input | Weak pull-up |
| **Pin 18**| `RC3` | Hall Sensor Floor 0 | Input | Active LOW; 10k external pull-up |
| **Pin 23**| `RC4` | Hall Sensor Floor 1 | Input | Active LOW; 10k external pull-up |
| **Pin 24**| `RC5` | Hall Sensor Floor 2 | Input | Active LOW; 10k external pull-up |
| **Pin 25**| `RC6` | Hall Sensor Floor 3 | Input | Active LOW; 10k external pull-up |
| **Pin 21**| `RD2` | LCD RS | Output | Register Select |
| **Pin 22**| `RD3` | LCD EN | Output | Enable Latch |
| **Pin 27**| `RD4` | LCD D4 | Output | 4-bit data bus |
| **Pin 28**| `RD5` | LCD D5 | Output | 4-bit data bus |
| **Pin 29**| `RD6` | LCD D6 | Output | 4-bit data bus |
| **Pin 30**| `RD7` | LCD D7 | Output | 4-bit data bus |
| **Pin 26**| `RC7` | Buzzer Drive | Output | Active HIGH to 2N2222 NPN base |

---

## 4. Mandatory PIC16F877A Register Settings
In `Inputs_Init()`:
1. **`ADCON1 = 0x06;`** — Configures PORTA (RA0-RA5) and PORTE (RE0-RE2) as digital I/O. Without this, landing buttons and keypad rows will fail to work!
2. **`TRISE.PSPMODE = 0;`** — Disables Parallel Slave Port on PORTE so RE0-RE2 function as general-purpose output pins.
3. **`OPTION_REG.NOT_RBPU = 0;`** — Enables internal weak pull-ups on PORTB for matrix keypad columns.

---

## 5. Team 2 Remaining Checklist
- [ ] Implement keypad matrix scanning and 25 ms debouncing in `Team_2_Inputs/Code/`.
- [ ] Implement external landing button polling in `Inputs_Update()`.
- [ ] Implement Hall effect sensor reading and conflict detector (`Inputs_IsFloorSensorFault`).
- [ ] Initialize LCD in 4-bit mode and implement `Inputs_DisplayStatus(...)`.
- [ ] Implement non-blocking buzzer pulse generator.
- [ ] Build Proteus simulation model for LCD, keypad, and buttons in `Team_2_Inputs/Simulation/`.
