/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module InputVoltageReadM(uint32_t g_reference_mV, uint32_t g_high_resistor, uint32_t g_low_resistor, uint32_t g_delay_ms) {
	provides interface Read<uint32_t> as VoltageRead;
	uses {
		interface Read<uint16_t>;
		interface GeneralIO as EnablePin; // Set for sampling
		interface GeneralIO as ReadPin;
		interface GeneralIO as SinkPin;   // Cleared for sampling
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "ivr"
	#define __LOG_LEVEL__ ( LOG_LEVEL_InputVoltageReadM & BASE_LOG_LEVEL )
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
			call EnablePin.makeOutput();
			call EnablePin.set();
			call SinkPin.makeOutput();
			call SinkPin.clr(); // Sink the current
			call ReadPin.makeInput();
			call ReadPin.clr();
			call Timer.startOneShot(g_delay_ms);
			return SUCCESS;
		}
		warn1("busy");
		return EBUSY;
	}

	event void Read.readDone(error_t result, uint16_t value) {
		uint32_t voltage = (uint32_t)g_reference_mV*value*(g_high_resistor + g_low_resistor)/g_low_resistor/1024;
		debug1("rd(%u, %u)", result, value);
		m_busy = FALSE;
		call EnablePin.makeInput();
		call EnablePin.clr();
		call SinkPin.makeInput();
		call SinkPin.set(); // Pull up
		call ReadPin.set(); // Pull up
		signal VoltageRead.readDone(result, voltage);
	}

}
