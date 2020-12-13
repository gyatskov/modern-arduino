cmake_minimum_required(VERSION 3.16)

project(arduino
    VERSION 0.0.1
    LANGUAGES CXX
)

include(FeatureSummary)

set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

feature_summary(WHAT ALL)

# Host-specific settings which can be overridden
set(AVR_PORT /dev/ttyACM0)
set(AVR_PROGRAMMER arduino)
set(AVR_UPLOADER avrdude)
set(AVR_BAUD 115200)

include(cmake/avr-functions.cmake)

add_subdirectory(uno)
