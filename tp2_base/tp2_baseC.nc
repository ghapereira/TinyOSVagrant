// TODO: preciso de arquivos diferentes para a base e para o mote? (provavelmente)
// TODO: como se comunicar com o programa externo? Isso só vai precisar ficar no arquivo da base...
// TODO: lógica da montagem de topologia fica no programa externo

#include <Timer.h>
#include "tp2_base.h"

module tp2_baseC {
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
  event void Boot.booted() {
    call AMControl.start();
  }

  // Evento disparado quando o radio completou a inicializacao
  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      // Verifica o input do usuário para saber se deve fazer o flood
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

  bool send_result;

  event void Timer0.fired() {
    counter++;

    if (!busy) {
      iot_tp2_struct* tp2pkt = (iot_tp2_struct *)
                               (call Packet.getPayload(&pkt, sizeof(iot_tp2_struct)));

      if (tp2pkt == NULL) {
        return;
      }

      send_result = call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(iot_tp2_struct));
      if (send_result == SUCCESS) {
        busy = TRUE;
      }
    }
  }

  // Fim do procedimento de envio
  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

  // TODO: metodo de recepcao de comandos via serial
  // TODO: metodo de envio de comandos para serial

  // Evento de recepcao dos dados
  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
    if (len == sizeof(iot_tp2_struct)) {
      iot_tp2_struct* tp2pkt = (iot_tp2_struct *)payload;

      // Elimina pacote se origem e si proprio
      // TODO: como obter si proprio?
      if (tp2pkt->SRC_ADDR == SELF_ADDR) {
        return msg;
      }

      // redireciona mensagem se nao e o destino
      if (tp2pkt->DST_ADDR != SELF_ADDR) {
        send_result = call AMSend.send(AM_BROADCAST_ADDR, &tp2pkt, sizeof(iot_tp2_struct));
        // TODO: o que fazer se o envio falhar?
        return msg;
      }
    }

    return msg;
  }
}