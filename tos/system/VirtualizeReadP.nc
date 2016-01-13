/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module VirtualizeReadP(uint8_t client_count, typedef data_type) {
	provides {
		interface Init;
		interface Read<data_type>[uint8_t client];
	}
	uses {
		interface Read<data_type> as SubRead;
	}
}
implementation {

	#define __MODUUL__ "vtrd"
	#define __LOG_LEVEL__ ( LOG_LEVEL_VirtualizeReadP & BASE_LOG_LEVEL )
	#include "log.h"

	bool m_busy[client_count];
	bool m_reading = FALSE;

	command error_t Init.init() {
		uint8_t i;
		for(i=0;i<client_count;i++) {
			m_busy[i] = FALSE;
		}
		return SUCCESS;
	}

	command error_t Read.read[uint8_t client]() {
		if(!m_busy[client]) {
			debug1("read");
			if(!m_reading) {
				error_t err = call SubRead.read();
				if(err != SUCCESS) {
					return err;
				}
				m_reading = TRUE;
			}
			m_busy[client] = TRUE;
			return SUCCESS;
		}
		warn1("busy");
		return EBUSY;
	}

	event void SubRead.readDone(error_t result, data_type value) {
		uint8_t i;
		m_reading = FALSE;
		for(i=0;i<client_count;i++) {
			if(m_busy[i]) {
				m_busy[i] = FALSE;
				signal Read.readDone[i](result, value);
			}
		}
	}

	default event void Read.readDone[uint8_t client](error_t result, data_type value) { }

}
