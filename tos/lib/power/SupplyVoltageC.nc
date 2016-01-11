/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration SupplyVoltageC() {
	provides {
		interface Read<uint32_t>;
	}
}
implementation {

	components SupplyVoltageP;
	Read = SupplyVoltageP.VoltageRead[unique("SupplyVoltageC")];

}
