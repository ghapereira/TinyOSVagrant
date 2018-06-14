// TODO: preciso de arquivos diferentes para a base e para o mote? (provavelmente)
// TODO: como se comunicar com o programa externo? Isso só vai precisar ficar no arquivo da base...
// TODO: lógica da montagem de topologia fica no programa externo

#include <Timer.h>
#include "tp2_cliente.h"

module tp2_clienteC {
    uses interface Boot;
    uses interface Leds;
    uses interface Timer<TMilli> as Timer0;
    uses interface Packet;
    uses interface AMPacket;
    uses interface AMSend;
    uses interface Receive;
    uses interface SplitControl as AMControl;
    uses interface Read<uint16_t>;
    // uses interface Read<uint16_t>;
}

implementation {
    // ID do pai
    uint16_t father_id;
    // Hops a partir do sink
    uint16_t hops;
    // Ultimo flood recebido
    uint8_t last_flood_id;

    event void Boot.booted() {
        father_id = DEFAULT_FATHER_ID;
        hops = DEFAULT_HOPS;
        last_flood_id = DEFAULT_FLOOD_ID;
        call AMControl.start();
        call Timer0.startPeriodic(SAMPLING_FREQUENCY);
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
        call Read.read();
    }

    event void Read.readDone(error_t result, uint16_t data) {
        if (result != SUCCESS) {
            return;
        }

        // Troca estado do led vermelho para mostrar que esta fazendo leituras
        call Leds.led0Toggle();

        if (!busy) {
            iot_tp2_struct* tp2pkt = (iot_tp2_struct *)
                (call Packet.getPayload(&pkt, sizeof(iot_tp2_struct)));

            if (tp2pkt == NULL) {
                return;
            }

            // TODO a quais dados o parametro data se refere?
            tp2pkt->PAYLOAD.TEMPERATURA = data;
            tp2pkt->PAYLOAD.LUMINOSIDADE = data;

            tp2pkt->SRC_ADDR = SELF_ADDR;
            tp2pkt->DST_ADDR = BASE_ADDR;
            tp2pkt->TYPE = ID_RESPOSTA;
            tp2pkt->LENGTH = 5;

            tp2pkt->HOPS = hops;
            tp2pkt->FATHER_ID = father_id;

            send_result = call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(iot_tp2_struct));

            if (send_result == SUCCESS) {
                busy = TRUE;
                // LED2: yellow
                call Leds.led2Toggle();
            }
        }
    }

    // Fim do procedimento de envio
    event void AMSend.sendDone(message_t* msg, error_t err) {
        if (&pkt == msg) {
            busy = FALSE;
        }
    }

    // Processa pacote de flood
    void processa_flood(iot_tp2_struct* flood_pkt) {
        // Troca pai se nao tem pai, ou se pai e de flood_id diferente
	bool deve_trocar_pai = father_id == DEFAULT_FATHER_ID || 
			       hops == DEFAULT_HOPS || 
			       last_flood_id != flood_pkt->FLOOD_ID;
	
	// Apos verificar se o pai nao era de um flood anterior, atualiza o flood
	last_flood_id = flood_pkt->FLOOD_ID;

	if (deve_trocar_pai) {
	    father_id = flood_pkt->SRC_ADDR;
            hops = flood_pkt->HOPS + 1;            
	    return;
        }

	// Troca pai se mais proximo do sink
        /*
	if (flood_pkt->hops < hops) {
	    father_id = flood_pkt->SRC_ADDR;
            hops = flood_pkt->HOPS + 1;
  	}
	*/

        // Procede com a continuacao do flood
        if (!busy) {
            iot_tp2_struct* tp2pkt = (iot_tp2_struct *)
                (call Packet.getPayload(&pkt, sizeof(iot_tp2_struct)));

            if (tp2pkt == NULL) {
                return;
            }

            tp2pkt->SRC_ADDR = SELF_ADDR;
            tp2pkt->DST_ADDR = BASE_ADDR;
            tp2pkt->TYPE = ID_FLOOD_REQ;

            tp2pkt->HOPS = hops;
            tp2pkt->FATHER_ID = father_id;
	    tp2pkt->FLOOD_ID = 

            send_result = call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(iot_tp2_struct));

            if (send_result == SUCCESS) {
                busy = TRUE;
            }
        }
    }

    // Processa resposta do servidor
    void processa_resposta(iot_tp2_struct* resposta_pkt) {}

    // Evento de recepcao dos dados
    event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len) {
        
        if (len == sizeof(iot_tp2_struct)) {	    
            iot_tp2_struct* tp2pkt = (iot_tp2_struct *)payload;

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
