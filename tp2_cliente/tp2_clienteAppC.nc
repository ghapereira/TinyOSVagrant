configuration tp2_clienteAppC { }

implementation {
  components MainC;
  components LedsC;
  components tp2_clienteC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC as Radio;
  components SerialActiveMessageC as Serial; 
  components new AMSenderC(AM_BLINKTORADIOMSG);
  components new AMReceiverC(AM_BLINKTORADIOMSG);
  components new PhotoC() as Sensor;
  //components new DemoSensorC() as Sensor;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;

  App.RadioPacket -> AMSenderC;		//App.Packet -> AMSenderC; (it was App.RadioPacket -> Radio; originally)
  App.RadioAMPacket -> AMSenderC;	//App.AMPacket -> AMSenderC; (it was App.RadioAMPacket -> Radio; originally)
  App.RadioAMControl -> Radio;		//App.AMControl -> ActiveMessageC;
  App.RadioSend -> AMSenderC;		//App.AMSend -> AMSenderC; 
  App.RadioReceive -> AMReceiverC;
  App.Read -> Sensor;

}
  

  
  //App.RadioControl -> Radio; 	    
      
  
 
