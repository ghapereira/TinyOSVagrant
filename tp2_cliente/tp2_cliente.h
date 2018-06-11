#define PAYLOAD_SIZE_TP2 13

#define ID_FLOOD_REQ 0x42
#define ID_RESPOSTA  0x93

#define BASE_ADDR 0x00 // Endereco da base

#define SELF_ADDR 0x14 // Endereco do sensor; o grupo possui 0x13, 0x14 e 0x15

#define SAMPLING_FREQUENCY 200 // Realiza leituras a cada 200 milissegundos

typedef nx_struct iot_tp2_grupo7_payload {
    nx_uint16_t TEMPERATURA;
    nx_uint16_t LUMINOSIDADE;
    nx_uint8_t  ID_RESTANTE;
    nx_uint8_t  PAYLOAD[PAYLOAD_SIZE_TP2];
} iot_tp2_grupo7_payload;

typedef nx_struct iot_tp2_struct {
    nx_uint16_t SRC_ADDR;
    nx_uint16_t DST_ADDR;
    nx_uint8_t  TYPE;
    nx_uint8_t  LENGTH;
    nx_uint8_t  HOPS;
    nx_uint16_t FATHER_ID;

    iot_tp2_grupo7_payload PAYLOAD;
} iot_tp2_struct;

enum {
    AM_BLINKTORADIOMSG = 6,
    TIMER_PERIOD_MILLI = 250
};
