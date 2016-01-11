/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration BatteryVoltageC() {
	provides {
		interface Read<uint32_t>;
	}
}
implementation {

	components BatteryVoltageP;
	Read = BatteryVoltageP.VoltageRead[unique("BatteryVoltageC")];

}
