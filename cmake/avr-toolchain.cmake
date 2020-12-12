set(CAMKE_SYSTEM_NAME      Generic)
set(CMAKE_SYSTEM_PROCESSOR avr)

# Toolchain binaries
find_program( AVR_CC        avr-gcc REQUIRED)
find_program( AVR_CXX       avr-g++ REQUIRED)
find_program( AVR_OBJCOPY   avr-objcopy REQUIRED)
find_program( AVR_SIZE      avr-size REQUIRED)
find_program( AVR_OBJDUMP   avr-objdump REQUIRED)
find_program( AVR_DUDE      avrdude REQUIRED)
find_program( AVR_AR        avr-ar REQUIRED)
find_program( AVR_ADDR2LINE avr-addr2line REQUIRED)

# Toolchain spec file

set(CMAKE_C_COMPILER    "${AVR_CC}")
set(CMAKE_CXX_COMPILER  "${AVR_CXX}")
set(CMAKE_AR            "${AVR_AR}")
set(CMAKE_ADDR2LINE     "${AVR_ADDR2LINE}")

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)


