#define PAYLOAD_SIZE_TP2 13

#define ID_FLOOD_REQ 0x42
#define ID_RESPOSTA  0x93

#define BASE_ADDR 0x00 // Endereco da base
#define SELF_ADDR 0x00

typedef nx_struct iot_tp2_grupo7_payload {
    nx_uint16_t TEMPERATURA;
    nx_uint16_t LUMINOSIDADE;
    nx_uint8_t  ID_RESTANTE;

    // 13 bytes filler para contabilizar o tamanho total
    nx_uint32_t FILLER_1;
    nx_uint32_t FILLER_2;
    nx_uint32_t FILLER_3;
    nx_uint8_t  FILLER_4;
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
