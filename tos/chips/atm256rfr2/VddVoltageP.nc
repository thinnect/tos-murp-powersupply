/**
 * @author Raido Pahtma
 * @license MIT
*/
configuration VddVoltageP {
	provides {
		interface Read<uint32_t> as VoltageRead[uint8_t client];
	}
}
implementation {

	components new VddVoltageReadP(uniqueCount("VddVoltageC"), 10);
	VoltageRead = VddVoltageReadP.VoltageRead;

}
