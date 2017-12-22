/**
 * Progmem table based interpolation for a random linear light sensor.
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include "ProgmemInterpolation.h"
module LinearLightTableC {
	provides interface Read<float>[uint8_t id];
	uses interface Read<uint32_t> as SubRead[uint8_t id];
}
implementation {

	#define __MODUUL__ "lght"
	#define __LOG_LEVEL__ ( LOG_LEVEL_LinearLightTableC & BASE_LOG_LEVEL )
	#include "log.h"

	enum {
		table_rows = 2
	};

	const float table[table_rows][2] PROGMEM = {
		{ 25000, 0.0 },
		{ 600, 100.0 }
	};

	command error_t Read.read[uint8_t id]() {
		return call SubRead.read[id]();
	}

	event void SubRead.readDone[uint8_t id](error_t result, uint32_t resistance) {
		float value = 0;
		if(result == SUCCESS) {
			info1("resistance %"PRIu32, resistance);
			value = progmem_interpolate((float)resistance, table, table_rows, TRUE);
			if(value < 0) {
				value = 0;
			}
		}
		signal Read.readDone[id](result, value);
	}

	default error_t command SubRead.read[uint8_t id]() {
		return EINVAL;
	}

	default event void Read.readDone[uint8_t id](error_t result, float value) { }

}
