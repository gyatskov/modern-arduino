add_avr_executable(blink_led
    blink_led.cpp
)

avr_target_link_libraries(blink_led
    ftd
)

