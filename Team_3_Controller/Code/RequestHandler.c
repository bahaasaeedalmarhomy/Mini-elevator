/*
 * ============================================================================
 * REQUEST HANDLER IMPLEMENTATION - FIFO FIXED-SIZE ARRAY
 * ============================================================================
 * Beginner-friendly, deterministic request queue for 4-floor mini elevator.
 *
 * Implements strict FIFO dispatching using a simple linear array.
 * No bitmasks, no pointers to dynamic heap, no complex data structures.
 * ============================================================================
 */

#include "../RequestHandler.h"

/* Fixed-size storage: holds up to FLOOR_COUNT requests */
static unsigned char requests[FLOOR_COUNT];
static unsigned char request_count = 0;

/*
 * Initialize or reset the request queue to an empty state.
 */
void RequestHandler_Init(void) {
    unsigned char i;
    request_count = 0;
    for (i = 0; i < FLOOR_COUNT; i++) {
        requests[i] = NO_FLOOR;
    }
}

/*
 * Check if a floor is already present in the active queue.
 * Returns 1 if present, 0 if not present.
 */
unsigned char RequestHandler_Contains(unsigned char floor) {
    unsigned char i;
    for (i = 0; i < request_count; i++) {
        if (requests[i] == floor) {
            return 1;
        }
    }
    return 0;
}

/*
 * Add a new floor request to the end of the queue.
 * Rejects invalid floors, ignores duplicate entries, and respects array bounds.
 */
void RequestHandler_Add(unsigned char floor) {
    /* Rule: Only accept valid physical floors (FLOOR_0 .. FLOOR_3) */
    if (floor > FLOOR_3) {
        return;
    }

    /* Rule: Ignore duplicate floor requests */
    if (RequestHandler_Contains(floor) != 0) {
        return;
    }

    /* Rule: Do not exceed array capacity */
    if (request_count < FLOOR_COUNT) {
        requests[request_count] = floor;
        request_count++;
    }
}

/*
 * Returns 1 if there are one or more pending requests; 0 if queue is empty.
 */
unsigned char RequestHandler_HasRequests(void) {
    return (request_count > 0) ? 1 : 0;
}

/*
 * Returns the first stored request (FIFO head).
 * If the queue is empty, returns NO_FLOOR.
 */
unsigned char RequestHandler_GetNext(void) {
    if (request_count == 0) {
        return NO_FLOOR;
    }
    return requests[0];
}

/*
 * Returns the next floor to service using the LOOK/SCAN elevator algorithm.
 * - If direction is DIR_UP:
 *     First checks for pending floors above current_floor (ascending: current_floor + 1 .. FLOOR_COUNT - 1).
 *     If none, reverses and checks for pending floors below current_floor (descending: current_floor - 1 .. 0).
 * - If direction is DIR_DOWN:
 *     First checks for pending floors below current_floor (descending: current_floor - 1 .. 0).
 *     If none, reverses and checks for pending floors above current_floor (ascending: current_floor + 1 .. FLOOR_COUNT - 1).
 * - If direction is DIR_STOP:
 *     Uses the oldest pending request (requests[0]) to establish initial direction,
 *     then applies the corresponding directional scan so floors along the way
 *     are visited first.
 * If no requests are pending, returns NO_FLOOR.
 */
unsigned char RequestHandler_GetNextOptimal(unsigned char current_floor, signed char direction) {
    unsigned char f;
    signed char scan_dir = direction;

    if (request_count == 0) {
        return NO_FLOOR;
    }

    if (current_floor == NO_FLOOR || !IS_VALID_FLOOR(current_floor)) {
        return requests[0];
    }

    /* If current floor is requested, service it immediately */
    if (RequestHandler_Contains(current_floor) != 0) {
        return current_floor;
    }

    /* If stationary, determine initial direction from the oldest request */
    if (scan_dir == DIR_STOP) {
        if (requests[0] > current_floor) {
            scan_dir = DIR_UP;
        } else if (requests[0] < current_floor) {
            scan_dir = DIR_DOWN;
        } else {
            return requests[0];
        }
    }

    if (scan_dir == DIR_UP) {
        /* Check for pending requests above current_floor (lowest first) */
        for (f = current_floor + 1; f < FLOOR_COUNT; f++) {
            if (RequestHandler_Contains(f) != 0) {
                return f;
            }
        }
        /* None above; reverse and check below current_floor (highest first) */
        for (f = current_floor; f > 0; f--) {
            if (RequestHandler_Contains(f - 1) != 0) {
                return f - 1;
            }
        }
    } else if (scan_dir == DIR_DOWN) {
        /* Check for pending requests below current_floor (highest first) */
        for (f = current_floor; f > 0; f--) {
            if (RequestHandler_Contains(f - 1) != 0) {
                return f - 1;
            }
        }
        /* None below; reverse and check above current_floor (lowest first) */
        for (f = current_floor + 1; f < FLOOR_COUNT; f++) {
            if (RequestHandler_Contains(f) != 0) {
                return f;
            }
        }
    }

    return requests[0];
}

/*
 * Remove a specific floor from the queue and shift all remaining
 * elements one position to the left.
 */
void RequestHandler_Remove(unsigned char floor) {
    unsigned char i;
    unsigned char j;

    for (i = 0; i < request_count; i++) {
        if (requests[i] == floor) {
            /* Shift subsequent requests to the left */
            for (j = i; j < (request_count - 1); j++) {
                requests[j] = requests[j + 1];
            }
            request_count--;
            requests[request_count] = NO_FLOOR;
            return;
        }
    }
}

/*
 * Clear all requests from the queue.
 */
void RequestHandler_Clear(void) {
    unsigned char i;
    request_count = 0;
    for (i = 0; i < FLOOR_COUNT; i++) {
        requests[i] = NO_FLOOR;
    }
}

/*
 * Diagnostic helper: return count of currently pending requests.
 */
unsigned char RequestHandler_GetCount(void) {
    return request_count;
}
