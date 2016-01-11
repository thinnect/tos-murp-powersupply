/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module PSTestP(uint32_t g_read_period) {
	uses {
		interface SplitControl as PrintfControl;
		interface Read<uint32_t> as Read[uint8_t n]; // mV
		interface Boot;
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "test"
	#define __LOG_LEVEL__ ( LOG_LEVEL_test & BASE_LOG_LEVEL )
	#include "log.h"

	event void Boot.booted() {
		call PrintfControl.start();
	}

	event void PrintfControl.startDone(error_t err) {
		debug1("started");
		call Timer.startPeriodic(g_read_period);
	}

	event void PrintfControl.stopDone(error_t err) {
		call Timer.stop();
	}

	event void Timer.fired() {
		error_t err = call Read.read[0]();
		logger(err == SUCCESS ? LOG_DEBUG1: LOG_ERR1, "read=%u", err);
	}

	event void Read.readDone[uint8_t n](error_t err, uint32_t value) {
		if(err == SUCCESS) {
			info1("voltage[%u] %"PRIu32" mV", n, value);
			call Read.read[n+1]();
		}
		else {
			err1("rd[%u](%u, %"PRIu32")", err, value);
		}
	}

	default command error_t Read.read[uint8_t n]() {
		return FAIL;
	}

}
