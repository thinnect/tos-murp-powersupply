/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module VddVoltageReadM(uint32_t g_delay_ms) {
	provides interface Read<uint32_t> as VoltageRead;
	uses {
		interface Read<uint16_t>; // Read 1/3 EVDD
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "vdd"
	#define __LOG_LEVEL__ ( LOG_LEVEL_VddVoltageReadM & BASE_LOG_LEVEL )
	#include "log.h"

	bool m_busy = FALSE;

	event void Timer.fired() {
		error_t err = call Read.read();
		if(err != SUCCESS) {
			warn1("read %u", err);
			signal Read.readDone(err, 0);
		}
	}

	command error_t VoltageRead.read() {
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
		signal VoltageRead.readDone(result, 3*1600UL*value/1024); // 1/3 EVDD with 1600mV reference
	}

}
