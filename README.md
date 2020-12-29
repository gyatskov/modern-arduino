# Modern Arduino
Arduino with modern CMake, modern C++ but without Arduino IDE.

# Requirements
 * CMake >= 3.16
 * AVR-GCC >= 10

# Configuration
```
mkdir build
cd build
cmake -DCMAKE_PREFIX_PATH=/usr/local/avr -DCMAKE_TOOLCHAIN_FILE=../cmake/avr-toolchain.cmake ../
```

# Build
Example of `blink_led` application:
```
cmake --build . --target blink_led
```

# Upload
Example of `blink_led` application:
```
cmake --build . --target upload_blink_led
```
