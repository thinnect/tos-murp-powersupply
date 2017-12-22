/**
 * Progmem table based interpolation for NTCLE_413_428
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include "ProgmemInterpolation.h"
module NTCLE_413_428_ReadC {
	provides interface Read<float>[uint8_t id];
	uses interface Read<uint32_t> as SubRead[uint8_t id];
}
implementation {

	#define __MODUUL__ "ntc"
	#define __LOG_LEVEL__ ( LOG_LEVEL_NTCLE_413_428_ReadC & BASE_LOG_LEVEL )
	#include "log.h"

	enum {
		ntc_table_rows = 30
	};

	const float ntc_table[ntc_table_rows][2] PROGMEM = {
		{ 190953.00, -40 },
		{ 145953.00, -35 },
		{ 112440.00, -30 },
		{  87285.00, -25 },
		{  68260.00, -20 },
		{  53762.00, -15 },
		{  42636.00, -10 },
		{  34038.00,  -5 },
		{  27348.00,   0 },
		{  22108.00,   5 },
		{  17979.00,  10 },
		{  14706.00,  15 },
		{  12094.00,  20 },
		{  10000.00,  25 },
		{   8310.80,  30 },
		{   6941.10,  35 },
		{   5824.90,  40 },
		{   4910.60,  45 },
		{   4158.30,  50 },
		{   3536.20,  55 },
		{   3019.70,  60 },
		{   2588.80,  65 },
		{   2228.00,  70 },
		{   1924.60,  75 },
		{   1668.40,  80 },
		{   1451.30,  85 },
		{   1266.70,  90 },
		{   1109.20,  95 },
		{    974.26, 100 },
		{    858.33, 105 }
	};

	command error_t Read.read[uint8_t id]() {
		return call SubRead.read[id]();
	}

	event void SubRead.readDone[uint8_t id](error_t result, uint32_t resistance) {
		float value = 0;
		if(result == SUCCESS) {
			info1("resistance %"PRIu32, resistance);
			value = progmem_interpolate((float)resistance, ntc_table, ntc_table_rows, TRUE);
		}
		signal Read.readDone[id](result, value);
	}

	default error_t command SubRead.read[uint8_t id]() {
		return EINVAL;
	}

	default event void Read.readDone[uint8_t id](error_t result, float value) { }

}
