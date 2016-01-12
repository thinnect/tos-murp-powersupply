/**
 * @author Raido Pahtma
 * @license MIT
*/
#include "logger.h"
configuration ResistanceTestC { }
implementation {

	components new ResistanceTestP(2000) as Test;

	components MainC;
	Test.Boot -> MainC;

	components new TimerMilliC();
	Test.Timer -> TimerMilliC;

	// ------------------------------------------------------------------------

	components new ResistanceReadP(1600, 0, 18000, 10) as R1Read;
	Test.Read[0] -> R1Read.ResistanceRead;

	components new ResistanceReadP(1600, 20000, 0, 10) as R2Read;
	Test.Read[1] -> R2Read.ResistanceRead;

	components new DummyGeneralIOC();
	R1Read.VoltagePin -> DummyGeneralIOC;
	R2Read.VoltagePin -> DummyGeneralIOC;

	components HplAtm128GeneralIOC as Pins;
	R1Read.ReadPin -> Pins.PortF2;
	R1Read.GroundPin -> Pins.PortG2;
	R2Read.ReadPin -> Pins.PortF2;
	R2Read.GroundPin -> Pins.PortG2;

	components new Atm128AdcConfigC(ATM128_ADC_SNGL_ADC2, ATM128_ADC_VREF_1_6, ATM128_ADC_PRESCALE);
	R1Read.Atm128AdcConfig -> Atm128AdcConfigC;
	R2Read.Atm128AdcConfig -> Atm128AdcConfigC;

	// ------------------------------------------------------------------------

	#ifndef START_PRINTF_DELAY
		#define START_PRINTF_DELAY 50
	#endif

	components new StartPrintfC(START_PRINTF_DELAY);
	Test.PrintfControl -> StartPrintfC.SplitControl;

}
