/**
 * @author Raido Pahtma
 * @license MIT
 *
 * g_reference_mV - ADC reference voltage value in millivolts
 * g_resistor_one - resistor closest to voltage divider input or 0 if this is the sensor
 * g_resistor_two - resistor closest to voltage divider ground or 0 if this is the sensor
 * g_delay_ms - delay after powering up the sensor and before taking a sample
*/
generic configuration ResistanceReadP(uint32_t g_reference_mV, uint32_t g_resistor_one, uint32_t g_resistor_two, uint32_t g_delay_ms) {
	provides interface Read<uint32_t> as ResistanceRead;
	uses {
		interface Atm128AdcConfig;
		interface GeneralIO as VoltagePin;
		interface GeneralIO as ReadPin;
		interface GeneralIO as GroundPin;
	}
}
implementation {

	components new ResistanceReadM(g_reference_mV, g_resistor_one, g_resistor_two, g_delay_ms);
	ResistanceRead = ResistanceReadM.ResistanceRead;

	ResistanceReadM.VoltagePin = VoltagePin;
	ResistanceReadM.ReadPin = ReadPin;
	ResistanceReadM.GroundPin = GroundPin;

	components new AdcReadClientC();
	AdcReadClientC.Atm128AdcConfig = Atm128AdcConfig;
	ResistanceReadM.Read -> AdcReadClientC;

	components new TimerMilliC();
	ResistanceReadM.Timer -> TimerMilliC;

	components new VddVoltageC();
	ResistanceReadM.VoltageRead -> VddVoltageC.Read;

}
