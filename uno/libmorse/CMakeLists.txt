# TODO: Split headers from sources
add_avr_library(morse
    morse.cpp
    morse.h
)

avr_target_link_libraries(morse
    ftd
)
