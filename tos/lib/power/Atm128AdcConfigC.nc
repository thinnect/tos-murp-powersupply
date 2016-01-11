/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module Atm128AdcConfigC(uint8_t adc_channel, uint8_t adc_ref_voltage, uint8_t adc_prescaler) {
	provides interface Atm128AdcConfig;
}
implementation {

	async command uint8_t Atm128AdcConfig.getChannel()    { return adc_channel;     }
	async command uint8_t Atm128AdcConfig.getRefVoltage() { return adc_ref_voltage; }
	async command uint8_t Atm128AdcConfig.getPrescaler()  { return adc_prescaler;   }

}
