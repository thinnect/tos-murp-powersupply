/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module CoreTemperatureReadM(uint32_t g_delay_ms) {
	provides interface Read<float> as TemperatureRead;
	uses {
		interface Read<uint16_t>;
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "ctemp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_CoreTemperatureReadM & BASE_LOG_LEVEL )
	#include "log.h"

	bool m_busy = FALSE;

	event void Timer.fired() {
		error_t err = call Read.read();
		if(err != SUCCESS) {
			warn1("read %u", err);
			signal Read.readDone(err, 0);
		}
	}

	command error_t TemperatureRead.read() {
		if(!m_busy) {
			debug1("read");
			m_busy = TRUE;
			call Timer.startOneShot(g_delay_ms);
			return SUCCESS;
		}
		warn1("busy");
		return EBUSY;
	}

	event void Read.readDone(error_t result, uint16_t value) {
		debug1("rd(%u, %u)", result, value);
		m_busy = FALSE;
		signal TemperatureRead.readDone(result, 1.13*value - 272.8);
	}

}
