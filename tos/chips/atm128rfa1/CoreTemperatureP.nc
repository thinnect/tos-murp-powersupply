/**
 * @author Raido Pahtma
 * @license MIT
*/
configuration CoreTemperatureP {
	provides {
		interface Read<float> as TemperatureRead[uint8_t client];
	}
}
implementation {

	components new CoreTemperatureReadP(uniqueCount("CoreTemperatureC"), 10);
	TemperatureRead = CoreTemperatureReadP.TemperatureRead;

}
