/**
 * @author ...
 * @license MIT
*/
configuration PowerSupplyReadC {
	provides {
		interface Read<int16_t>;
	}
}
implementation {

	components new PowerSupplyReadP();
	Read = PowerSupplyReadP;

}
