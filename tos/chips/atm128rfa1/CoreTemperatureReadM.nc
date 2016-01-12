/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module CoreTemperatureReadM(uint8_t g_clients, uint32_t g_delay_ms) {
	provides {
		interface Init;
		interface Read<float> as TemperatureRead[uint8_t client];
	}
	uses {
		interface Read<uint16_t>;
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "temp"
	#define __LOG_LEVEL__ ( LOG_LEVEL_CoreTemperatureReadM & BASE_LOG_LEVEL )
	#include "log.h"

	bool m_busy[g_clients];
	bool m_reading = FALSE;

	command error_t Init.init() {
		uint8_t i;
		for(i=0;i<g_clients;i++) {
			m_busy[i] = FALSE;
		}
		return SUCCESS;
	}

	event void Timer.fired() {
		error_t err = call Read.read();
		if(err != SUCCESS) {
			warn1("read %u", err);
			signal Read.readDone(err, 0);
		}
	}

	command error_t TemperatureRead.read[uint8_t client]() {
		if(!m_busy[client]) {
			debug1("read");
			if(!m_reading) {
				m_reading = TRUE;
				call Timer.startOneShot(g_delay_ms);
			}
			m_busy[client] = TRUE;
			return SUCCESS;
		}
		warn1("busy");
		return EBUSY;
	}

	event void Read.readDone(error_t result, uint16_t value) {
		uint8_t i;
		float temperature = 1.13*value - 272.8;
		debug1("rd(%u, %u)", result, value);
		m_reading = FALSE;
		for(i=0;i<g_clients;i++) {
			if(m_busy[i]) {
				m_busy[i] = FALSE;
				signal TemperatureRead.readDone[i](result, temperature);
			}
		}
	}

	default event void TemperatureRead.readDone[uint8_t client](error_t result, float value) {
		err4("dflt[%u]", client);
	}

}
