// TODO: preciso de arquivos diferentes para a base e para o mote? (provavelmente)
// TODO: como se comunicar com o programa externo? Isso só vai precisar ficar no arquivo da base...
// TODO: lógica da montagem de topologia fica no programa externo

#include <Timer.h>
#include "tp2_base.h"
#include "Serial.h"

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
        call Timer0.startPeriodic(200);
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

    // Quando o timer e ativado, envia os dados obtidos das leituras
    event void Timer0.fired() {
        counter++;
    }

    // Fim do procedimento de envio
    event void AMSend.sendDone(message_t* msg, error_t err) {
        if (&pkt == msg) {
            busy = FALSE;
        }
    }

    // Processa pacote de flood
    void processa_flood(iot_tp2_struct* flood_pkt) {}

    // Processa resposta do servidor
    void processa_resposta(iot_tp2_struct* resposta_pkt) {}

    // Evento de recepcao dos dados
    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
        if (len == sizeof(iot_tp2_struct)) {
            iot_tp2_struct* tp2pkt = (iot_tp2_struct *)payload;

            // green
            call Leds.led1Toggle();

            // Elimina pacote se origem e si proprio
            if (tp2pkt->SRC_ADDR == SELF_ADDR) {
                return msg;
            }

            if (tp2pkt == NULL) {
                return msg;
            }

            // redireciona mensagem se nao e o destino
            if (tp2pkt->DST_ADDR != SELF_ADDR) {
                // A redirecao e feita aqui mesmo?
                send_result = call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(iot_tp2_struct));
                // TODO: o que fazer se o envio falhar?
                return msg;
            }

            // Red
            call Leds.led0Toggle();

            // processa mensagem:
            switch (tp2pkt->TYPE) {
                case ID_FLOOD_REQ:
                    //  -> recepção de flood
                    processa_flood(tp2pkt);
                    break;
                case ID_RESPOSTA:
                    processa_resposta(tp2pkt);
                    //  -> recepção de leitura
                    break;
                default:
                    // erro
            }
        }

        return msg;
    }
}
