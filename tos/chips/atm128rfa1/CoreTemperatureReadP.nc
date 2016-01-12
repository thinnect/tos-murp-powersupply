/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration CoreTemperatureReadP(uint8_t g_clients, uint32_t g_delay_ms) {
	provides {
		interface Read<float> as TemperatureRead[uint8_t client];
	}
}
implementation {

	components new CoreTemperatureReadM(g_clients, g_delay_ms);
	TemperatureRead = CoreTemperatureReadM.TemperatureRead;

	components new AdcReadClientC();
	CoreTemperatureReadM.Read -> AdcReadClientC;

	components new Atm128AdcConfigC(ATM128_ADC_INT_TEMP, ATM128_ADC_VREF_1_6, ATM128_ADC_PRESCALE);
	AdcReadClientC.Atm128AdcConfig -> Atm128AdcConfigC;

	components new TimerMilliC();
	CoreTemperatureReadM.Timer -> TimerMilliC;

	components MainC;
	MainC.SoftwareInit -> CoreTemperatureReadM.Init;

}
