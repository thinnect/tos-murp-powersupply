/**
 * @author Raido Pahtma
 * @license MIT
*/
configuration SupplyVoltageP {
	provides {
		interface Read<uint32_t> as VoltageRead[uint8_t client];
	}
}
implementation {

	components new InputVoltageReadP(uniqueCount("SupplyVoltageC"), 1600, 20, 18, 10);
	VoltageRead = InputVoltageReadP.VoltageRead;

	components HplAtm128GeneralIOC as Pins;
	InputVoltageReadP.ReadPin -> Pins.PortF2;
	InputVoltageReadP.SinkPin -> Pins.PortG2;

	components new AdcReadClientC() as SupplyReadClientC;
	InputVoltageReadP.Read -> SupplyReadClientC;

	components new Atm128AdcConfigC(ATM128_ADC_SNGL_ADC2, ATM128_ADC_VREF_1_6, ATM128_ADC_PRESCALE);
	SupplyReadClientC.Atm128AdcConfig -> Atm128AdcConfigC;

}
