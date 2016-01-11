/**
 * @author Raido Pahtma
 * @license MIT
*/
#include "logger.h"
configuration PSTestC { }
implementation {

	components new PSTestP(2000);

	components MainC;
	PSTestP.Boot -> MainC;

	components new TimerMilliC();
	PSTestP.Timer -> TimerMilliC;

	components new VddVoltageC();
	PSTestP.Read[0] -> VddVoltageC.Read;

	components new SupplyVoltageC();
	PSTestP.Read[1] -> SupplyVoltageC.Read;

	components new BatteryVoltageC();
	PSTestP.Read[2] -> BatteryVoltageC.Read;

	#ifndef START_PRINTF_DELAY
		#define START_PRINTF_DELAY 50
	#endif

	components new StartPrintfC(START_PRINTF_DELAY);
	PSTestP.PrintfControl -> StartPrintfC.SplitControl;

}
