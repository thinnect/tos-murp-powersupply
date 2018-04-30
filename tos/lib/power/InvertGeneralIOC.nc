/**
 * Invert GeneralIO set/clr commands.
 *
 * @author Raido Pahtma
 * @license MIT
*/
generic module InvertGeneralIOC() {
	provides interface GeneralIO;
	uses interface GeneralIO as SubGeneralIO;
}
implementation {

	async command void GeneralIO.set()        { call SubGeneralIO.clr();       }
	async command void GeneralIO.clr()        { call SubGeneralIO.set();       }
	async command void GeneralIO.toggle()     { call SubGeneralIO.toggle();    }
	async command bool GeneralIO.get()        { !call SubGeneralIO.get();      }
	async command void GeneralIO.makeInput()  { call SubGeneralIO.makeInput(); }
	async command bool GeneralIO.isInput()    { call SubGeneralIO.isInput();   }
	async command void GeneralIO.makeOutput() { call SubGeneralIO.makeOutput();}
	async command bool GeneralIO.isOutput()   { call SubGeneralIO.isOutput();  }

}
