/**
 * @author Raido Pahtma
 * @license MIT
*/
generic configuration VirtualizeReadC(uint8_t client_count, typedef data_type) {
	provides interface Read<data_type>[uint8_t client];
	uses interface Read<data_type> as SubRead;
}
implementation {

	components new VirtualizeReadP(client_count, data_type);
	Read = VirtualizeReadP.Read;
	VirtualizeReadP.SubRead = SubRead;

	components MainC;
	MainC.SoftwareInit -> VirtualizeReadP.Init;

}
