/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration InputVoltageReadP(uint8_t g_clients, uint32_t g_reference_mV, uint32_t g_high_resistor, uint32_t g_low_resistor, uint32_t g_delay_ms) {
	provides {
		interface Read<uint32_t> as VoltageRead[uint8_t client];
	}
	uses {
		interface Read<uint16_t>;
		interface GeneralIO as EnablePin;
		interface GeneralIO as ReadPin;
		interface GeneralIO as SinkPin;
	}
}
implementation {

	components new VirtualizeReadC(g_clients, uint32_t);
	VoltageRead = VirtualizeReadC.Read;

	components new InputVoltageReadM(g_reference_mV, g_high_resistor, g_low_resistor, g_delay_ms);
	VirtualizeReadC.SubRead -> InputVoltageReadM.VoltageRead;
	InputVoltageReadM.Read = Read;
	InputVoltageReadM.EnablePin = EnablePin;
	InputVoltageReadM.ReadPin = ReadPin;
	InputVoltageReadM.SinkPin = SinkPin;

	components new TimerMilliC();
	InputVoltageReadM.Timer -> TimerMilliC;

}
