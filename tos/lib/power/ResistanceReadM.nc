/**
 * @author Raido Pahtma
 * @license MIT
 *
 * g_reference_mV - ADC reference voltage value in millivolts
 * g_resistor_one - resistor closest to voltage divider input or 0 if this is the sensor
 * g_resistor_two - resistor closest to voltage divider ground or 0 if this is the sensor
 * g_delay_ms - delay after powering up the sensor and before taking a sample
*/
generic module ResistanceReadM(uint32_t g_reference_mV, uint32_t g_resistor_one, uint32_t g_resistor_two, uint32_t g_delay_ms) {
	provides interface Read<uint32_t> as ResistanceRead;
	uses {
		interface Read<uint32_t> as VoltageRead;
		interface Read<uint16_t>;
		interface GeneralIO as VoltagePin;
		interface GeneralIO as ReadPin;
		interface GeneralIO as GroundPin;
		interface Timer<TMilli>;
	}
}
implementation {

	#define __MODUUL__ "res"
	#define __LOG_LEVEL__ ( LOG_LEVEL_ResistanceReadM & BASE_LOG_LEVEL )
	#include "log.h"

	bool m_busy = FALSE;
	uint32_t m_source_mV = 0;

	command error_t ResistanceRead.read() {
		if(!m_busy) {
			debug1("read");
			call VoltagePin.makeOutput();
			call VoltagePin.set(); // Provide current
			call ReadPin.makeInput();
			call ReadPin.clr();
			call GroundPin.makeOutput();
			call GroundPin.clr(); // Sink the current
			call Timer.startOneShot(g_delay_ms);
			m_busy = TRUE;
			return SUCCESS;
		}
		warn1("busy");
		return EBUSY;
	}

	event void Timer.fired() {
		error_t err = call VoltageRead.read();
		if(err != SUCCESS) {
			warn1("sread %u", err);
			signal Read.readDone(err, 0);
		}
	}

	event void VoltageRead.readDone(error_t result, uint32_t value) {
		debug1("srd(%u, %"PRIu32")", result, value); // source voltage in millivolts
		if(result == SUCCESS) {
			error_t err = call Read.read();
			if(err != SUCCESS) {
				warn1("rread %u", err);
				signal Read.readDone(err, 0);
			}
			m_source_mV = value;
		} else {
			signal Read.readDone(result, 0);
		}
	}

	event void Read.readDone(error_t result, uint16_t value) {
		uint32_t resistance = 0;
		debug1("rd(%u, %u)", result, value);

		call GroundPin.makeInput();
		call GroundPin.set(); // Pull up
		// ReadPin is already an input
		call ReadPin.set(); // Pull up
		call VoltagePin.makeInput();
		call VoltagePin.set(); // Pull up
		m_busy = FALSE;

		if(result == SUCCESS) {
			float adc_mV = (float)g_reference_mV*value/1024;
			float prop = adc_mV/m_source_mV;

			if(g_resistor_one == 0) {
				resistance = (uint32_t)(g_resistor_two * (1 - prop) / prop); // Sensor is resistor one - closest to input voltage
			} else {
				resistance = (uint32_t)(g_resistor_one * prop / (1 - prop)); // Sensor is resistor two - closest to ground
			}
		}

		signal ResistanceRead.readDone(result, resistance);
	}

}
