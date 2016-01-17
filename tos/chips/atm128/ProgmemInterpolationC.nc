/**
 * @author Raido Pahtma
 * @license MIT
 *
 * Implementation for interpolation and search functions. The table must consist of floats stored in PROGMEM.
*/
#include "ProgmemInterpolation.h"
module ProgmemInterpolationC { }
implementation {

	#define __MODUUL__ "intr"
	#define __LOG_LEVEL__ ( LOG_LEVEL_ProgmemInterpolationC & BASE_LOG_LEVEL )
	#include "log.h"

	uint8_t find_idx_from_table(float resistance, const float table[][2], uint8_t table_rows, bool nc) {
		uint16_t idx;
		uint8_t maxIdx = table_rows - 1;
		uint8_t minIdx = 0;
		float res;

		while(maxIdx > minIdx + 1) {
			idx = minIdx + (maxIdx - minIdx) / 2;
			res = pgm_read_float(&table[idx][0]);
			debug2("idx: %d, min: %d, max: %d", idx, minIdx, maxIdx);
			if(resistance == res) {
				debug2("found: %d", idx);
				return idx;
			}

			if((nc && (resistance < res)) || (!nc && (resistance > res))) {
				debug2("min: %d", minIdx);
				minIdx = idx;
			} else {
				debug2("max: %d", maxIdx);
				maxIdx = idx;
			}
		}

		debug1("idx: %d", minIdx);
		return minIdx;
	}

	float progmem_interpolate(float resistance, const float table[][2], uint8_t table_rows, bool nc) @C() {
		uint8_t idx = find_idx_from_table(resistance, table, table_rows, nc);
		float base = pgm_read_float(&table[idx][1]);
		float diff = 0;

		if(idx < table_rows - 1) { // idx is not the last element of the table
			float maxRes = pgm_read_float(&table[idx][0]);
			float maxVal = pgm_read_float(&table[idx][1]);

			float minRes = pgm_read_float(&table[idx + 1][0]);
			float minVal = pgm_read_float(&table[idx + 1][1]);

			diff = (maxRes - resistance) * (minVal - maxVal) / (maxRes - minRes);
			debug1("maxRes:%"PRIi32" minRes:%"PRIi32" res:%"PRIi32" baseT:%"PRIi32" diff:%"PRIi32,
				(int32_t)maxRes, (int32_t)minRes, (int32_t)resistance, (int32_t)base, (int32_t)diff);
		}

		return base + diff;
	}

}
