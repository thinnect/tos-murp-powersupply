/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module PSTestP(uint32_t g_read_period) {
	uses {
		interface SplitControl as PrintfControl;
		interface Read<int16_t>; // mV
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
		call Timer.startOneShot(g_read_period);
	}

	event void PrintfControl.stopDone(error_t err) {
		call Timer.stop();
	}

	event void Timer.fired() {
		error_t err = call Read.read();
		logger(err == SUCCESS ? LOG_DEBUG1: LOG_ERR1, "read=%u", err);
	}

	event void Read.readDone(error_t err, int16_t value) {
		if(err == SUCCESS) {
			info1("voltage %d mV", value);
		}
		else {
			err1("readDone(%u, %d)", err, value);
		}
		call Timer.startOneShot(g_read_period);
	}

}
