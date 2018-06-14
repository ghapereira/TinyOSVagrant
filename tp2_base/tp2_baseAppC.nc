configuration tp2_baseAppC { }

implementation {
  components MainC;
  components LedsC;
  components tp2_baseC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_BLINKTORADIOMSG);
  components new AMReceiverC(AM_BLINKTORADIOMSG);
  components SerialActiveMessageC as Serial;

  // components new PhotoC() as PhotoSensor;
  components new DemoSensorC() as Sensor;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;

  // App.ReadPhoto -> PhotoSensor;
  // App.Read -> Sensor;
}

