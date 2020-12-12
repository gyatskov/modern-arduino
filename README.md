# Modern Arduino
Arduino with modern CMake, modern C++ and without Arduino IDE.

# Building
```
mkdir build
cmake ../ -DCMAKE_PREFIX_PATH=/usr/local/avr -DCMAKE_TOOLCHAIN_FILE=../cmake/avr-toolchain.cmake
```

