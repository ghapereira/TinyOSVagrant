typedef nx_struct BlinkToRadioMsg {
    nx_uint16_t node_id;
    nx_uint16_t counter;
} BlinkToRadioMsg;

enum {
    AM_BLINKTORADIOMSG = 6,
    TIMER_PERIOD_MILLI = 250
};
