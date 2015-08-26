/**
 * @author ...
 * @license MIT
*/
generic module PowerSupplyReadP() {
	provides {
		interface Read<int16_t>;
	}
	//uses {
	//	interface Read<uint16_t> as Input1Read; // 5V ADC input
	//	interface Read<uint16_t> as Input2Read; // 3.3V ADC input
	//}
}
implementation {

	#define __MODUUL__ "psread"
	#define __LOG_LEVEL__ ( LOG_LEVEL_PowerSupplyReadP & BASE_LOG_LEVEL )
	#include "log.h"

	bool m_busy = FALSE;

	task void readNotImplemented() {
		#warning "Read not implemented"
		err1("Read not implemented yet");
		m_busy = FALSE;
		signal Read.readDone(FAIL, 0);
	}

	command error_t Read.read() {
		if(!m_busy) {
			debug1("read");
			m_busy = TRUE;
			post readNotImplemented();
			return SUCCESS;
		}
		warn1("busy");
		return EBUSY;
	}

}
