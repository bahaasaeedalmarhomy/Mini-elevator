#ifndef CONTROLLER_H
#define CONTROLLER_H

#include "../Shared/System_Types.h"

/*
 * ============================================================================
 * TEAM 3 PUBLIC INTERFACE - MAIN ELEVATOR CONTROLLER
 * ============================================================================
 * Responsibilities:
 *   - Master Finite State Machine (FSM) execution
 *   - Request queue processing and destination dispatching
 *   - Pre-flight safety checks (weight, sensor validity)
 *   - Coordination of mechanical brake sequencing with motor motion
 *   - Automatic fault handling (overload, sensor conflict, travel timeout)
 *   - Periodic LCD and status synchronization
 * ============================================================================
 */

/* Initialize controller state, request handler, and safety timers */
void Controller_Init(void);

/* Periodic state machine update (called every 10 ms from main loop) */
void Controller_Update(void);

/* Returns current active controller state (STATE_IDLE, STATE_MOVING_UP, etc.) */
unsigned char Controller_GetState(void);

/* Returns current confirmed cabin floor (FLOOR_0..FLOOR_3 or NO_FLOOR) */
unsigned char Controller_GetCurrentFloor(void);

/* Returns current active target destination floor (FLOOR_0..FLOOR_3 or NO_FLOOR) */
unsigned char Controller_GetTargetFloor(void);

#endif /* CONTROLLER_H */
