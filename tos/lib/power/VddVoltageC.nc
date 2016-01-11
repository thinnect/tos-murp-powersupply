/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration VddVoltageC() {
	provides {
		interface Read<uint32_t>;
	}
}
implementation {

	components VddVoltageP;
	Read = VddVoltageP.VoltageRead[unique("VddVoltageC")];

}
