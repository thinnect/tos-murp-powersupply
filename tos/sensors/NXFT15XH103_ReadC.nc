/**
 * Progmem table based interpolation for NXFT15XH103
 *
 * @author Raido Pahtma
 * @license MIT
 */
#include "ProgmemInterpolation.h"
module NXFT15XH103_ReadC {
	provides interface Read<float>[uint8_t id];
	uses interface Read<uint32_t> as SubRead[uint8_t id];
}
implementation {

	#define __MODUUL__ "ntc"
	#define __LOG_LEVEL__ ( LOG_LEVEL_NXFT15XH103_ReadC & BASE_LOG_LEVEL )
	#include "log.h"

	enum {
		ntc_table_rows = 34
	};

	const float ntc_table[ntc_table_rows][2] PROGMEM = {
		{ 197388.00, -40 },
		{ 149395.00, -35 },
		{ 114345.00, -30 },
		{  88381.00, -25 },
		{  68915.00, -20 },
		{  54166.00, -15 },
		{  42889.00, -10 },
		{  34196.00,  -5 },
		{  27445.00,   0 },
		{  22165.00,   5 },
		{  18010.00,  10 },
		{  14720.00,  15 },
		{  12099.00,  20 },
		{  10000.00,  25 },
		{   8309.00,  30 },
		{   6939.00,  35 },
		{   5824.00,  40 },
		{   4911.00,  45 },
		{   4160.00,  50 },
		{   3539.00,  55 },
		{   3024.00,  60 },
		{   2593.00,  65 },
		{   2233.00,  70 },
		{   1929.00,  75 },
		{   1673.00,  80 },
		{   1455.00,  85 },
		{   1270.00,  90 },
		{   1112.00,  95 },
		{    976.00, 100 },
		{    860.00, 105 },
		{    759.00, 110 },
		{    673.00, 115 },
		{    598.00, 120 },
		{    532.00, 125 }
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
