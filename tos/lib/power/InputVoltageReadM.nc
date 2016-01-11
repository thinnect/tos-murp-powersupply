/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module InputVoltageReadM(uint8_t g_clients, uint32_t g_reference_mV, uint32_t g_high_resistor, uint32_t g_low_resistor, uint32_t g_delay_ms) {
	provides {
		interface Init;
		interface Read<uint32_t> as VoltageRead[uint8_t client];
	}
	uses {
		interface Read<uint16_t>;
		interface GeneralIO as ReadPin;
		interface GeneralIO as SinkPin;
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "ivr"
	#define __LOG_LEVEL__ ( LOG_LEVEL_InputVoltageReadP & BASE_LOG_LEVEL )
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

	command error_t VoltageRead.read[uint8_t client]() {
		if(!m_busy[client]) {
			debug1("read");
			if(!m_reading) {
				m_reading = TRUE;
				call SinkPin.makeOutput();
				call SinkPin.clr(); // Sink the current
				call ReadPin.makeInput();
				call ReadPin.clr();
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
		uint32_t voltage = (uint32_t)g_reference_mV*value*(g_high_resistor + g_low_resistor)/g_low_resistor/1024;
		debug1("rd(%u, %u)", result, value);
		m_reading = FALSE;
		call SinkPin.makeInput();
		call SinkPin.set(); // Pull up
		call ReadPin.set(); // Pull up
		for(i=0;i<g_clients;i++) {
			if(m_busy[i]) {
				m_busy[i] = FALSE;
				signal VoltageRead.readDone[i](result, voltage);
			}
		}
	}

	default event void VoltageRead.readDone[uint8_t client](error_t result, uint32_t value) {
		err4("dflt[%u]", client);
	}

}
