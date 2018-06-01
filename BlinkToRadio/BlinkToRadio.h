typedef nx_struct BlinkToRadioMsg {
    nx_uint16_t node_id;
    nx_uint16_t counter;
} BlinkToRadioMsg;

typedef nx_struct iot_tp2_grupo7_payload {
    nx_uint16_t TEMPERATURA;
    nx_uint16_t LUMINOSIDADE;
    nx_uint8_t  ID_RESTANTE;
    nx_uint8_t  PAYLOAD[13];
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
