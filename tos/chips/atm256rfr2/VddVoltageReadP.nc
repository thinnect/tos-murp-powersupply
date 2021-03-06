/**
 * @author Raido Pahtma
 * @license MIT
*/
#include "Atm128Adc.h"
generic configuration VddVoltageReadP(uint8_t g_clients, uint32_t g_delay_ms) {
	provides {
		interface Read<uint32_t> as VoltageRead[uint8_t client];
	}
}
implementation {

	components new VirtualizeReadC(g_clients, uint32_t);
	VoltageRead = VirtualizeReadC.Read;

	components new VddVoltageReadM(g_delay_ms);
	VirtualizeReadC.SubRead -> VddVoltageReadM.VoltageRead;

	components new AdcReadClientC() as VddReadClientC;
	VddVoltageReadM.Read -> VddReadClientC;

	components new Atm128AdcConfigC(ATM128_ADC_SNGL_EVDD, ATM128_ADC_VREF_1_6, ATM128_ADC_PRESCALE);
	VddReadClientC.Atm128AdcConfig -> Atm128AdcConfigC;

	components new TimerMilliC();
	VddVoltageReadM.Timer -> TimerMilliC;

}
