#include "BlinkToRadio.h"

module BlinkToRadioC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
}

implementation {
  // Método que ativa os leds
  void setLeds(uint16_t val) {
    // Led vermelho
    if (val & 0x01) {
      call Leds.led0On();
    } else {
      call Leds.led0Off();
    }

    // Led verde
    if (val & 0x02) {
      call Leds.led1On();
    } else {
      call Leds.led1Off();
    }

    // Led amarelo
    if (val & 0x04) {
      call Leds.led2On();
    } else {
      call Leds.led2Off();
    }
  }

  event void Boot.booted() {
    call AMControl.start();
  }

  // Evento disparado quando o radio completou a inicializacao
  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      // Inicializa o timer
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    } else {
      call AMControl.start();
    }
  }

  // Evento de desativacao do radio
  event void AMControl.stopDone(error_t err) { }

  // mensagem a ser enviada
  message_t pkt;

  // Global counter init
  uint16_t counter = 0;

  // Global busy flag
  bool busy = FALSE;

  event void Timer0.fired() {
    counter++;

    if (!busy) {
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg *)
                                (call Packet.getPayload(&pkt,
                                                        sizeof(BlinkToRadioMsg)));

      if (btrpkt == NULL) {
        return;
      }

      btrpkt->node_id = TOS_NODE_ID;
      btrpkt->counter = counter;

      if (call AMSend.send(AM_BROADCAST_ADDR,
                          &pkt,
                          sizeof(BlinkToRadioMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
  }

  // Fim do procedimento de envio
  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy == FALSE;
    }
  }

  // Evento de recepção dos dados
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    if (len == sizeof(BlinkToRadioMsg)) {
      BlinkToRadioMsg* btrpkt = (BlinkToRadioMsg *)payload;
      setLeds(btrpkt->counter);
    }

    return msg;
  }

}
