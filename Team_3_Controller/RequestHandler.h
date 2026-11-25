#ifndef REQUEST_HANDLER_H
#define REQUEST_HANDLER_H

#include "../Shared/System_Types.h"

/*
 * ============================================================================
 * TEAM 3 REQUEST HANDLER - LOOK/SCAN ELEVATOR SCHEDULER
 * ============================================================================
 * Architecture Rules:
 *   - Uses a simple fixed-size array: static unsigned char requests[FLOOR_COUNT]
 *   - No bitmask, no dynamic memory, no linked list, no bitwise complexity
 *   - Supports both FIFO retrieval and LOOK/SCAN directional scheduling
 *   - Rejects out-of-range floors (< FLOOR_0 or > FLOOR_3)
 *   - Ignores duplicate calls
 *   - Array shifts left upon item removal
 * ============================================================================
 */

/* Initialize request array and count to empty state */
void RequestHandler_Init(void);

/* Enqueue a floor request if valid, not duplicate, and capacity allows */
void RequestHandler_Add(unsigned char floor);

/* Returns 1 if at least one request is pending, otherwise 0 */
unsigned char RequestHandler_HasRequests(void);

/* Returns 1 if the specified floor is already pending in the queue, else 0 */
unsigned char RequestHandler_Contains(unsigned char floor);

/* Returns the earliest pending floor (head of queue) or NO_FLOOR if empty */
unsigned char RequestHandler_GetNext(void);

/* Returns optimal next floor according to LOOK/SCAN directional scheduling */
unsigned char RequestHandler_GetNextOptimal(unsigned char current_floor, signed char direction);

/* Deletes the specified floor from queue and shifts remaining entries left */
void RequestHandler_Remove(unsigned char floor);

/* Flushes all pending requests from the queue */
void RequestHandler_Clear(void);

/* Diagnostics / Verification: returns current number of queued requests */
unsigned char RequestHandler_GetCount(void);

#endif /* REQUEST_HANDLER_H */
