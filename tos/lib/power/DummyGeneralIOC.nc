/**
 * @author Raido Pahtma
 * @license MIT
*/
generic module DummyGeneralIOC() {
	provides interface GeneralIO;
}
implementation {

	bool m_output = FALSE;
	bool m_set = FALSE;

	async command void GeneralIO.set()        { atomic m_set = TRUE;     }
	async command void GeneralIO.clr()        { atomic m_set = FALSE;    }
	async command void GeneralIO.toggle()     { atomic m_set = !m_set;   }
	async command bool GeneralIO.get()        { atomic return m_set;     }
	async command void GeneralIO.makeInput()  { atomic m_output = FALSE; }
	async command bool GeneralIO.isInput()    { atomic return !m_output; }
	async command void GeneralIO.makeOutput() { atomic m_output = TRUE;  }
	async command bool GeneralIO.isOutput()   { atomic return m_output;  }

}
