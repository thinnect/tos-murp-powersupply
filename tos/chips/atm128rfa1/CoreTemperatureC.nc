/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration CoreTemperatureC() {
	provides {
		interface Read<float>;
	}
}
implementation {

	components CoreTemperatureP;
	Read = CoreTemperatureP.TemperatureRead[unique("CoreTemperatureC")];

}
