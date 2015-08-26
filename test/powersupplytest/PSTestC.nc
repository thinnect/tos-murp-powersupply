/**
 * @author Raido Pahtma
 * @license MIT
*/
#include "logger.h"
configuration PSTestC {

}
implementation {

	components new PSTestP(1000);

	components MainC;
	PSTestP.Boot -> MainC;

	components new TimerMilliC();
	PSTestP.Timer -> TimerMilliC;

	components PowerSupplyReadC;
	PSTestP.Read -> PowerSupplyReadC.Read;

	#ifndef START_PRINTF_DELAY
		#define START_PRINTF_DELAY 50
	#endif

	components new StartPrintfC(START_PRINTF_DELAY);
	PSTestP.PrintfControl -> StartPrintfC.SplitControl;


}
