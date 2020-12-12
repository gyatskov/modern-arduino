APP_NAME=blink_led

AVR_PORT=/dev/ttyACM0
AVR_PROGRAMMER=arduino
AVR_UPLOADER=avrdude
AVR_BAUD=115200
AVR_CPU_FREQ=16000000UL
AVR_DEVICE=atmega328p

AVR_SPECS_FILE=/usr/local/avr/lib/gcc/avr/11.0.0/device-specs/specs-$(AVR_DEVICE)

blink_led: $(APP_NAME).cpp
	avr-g++ -Os -DF_CPU=$(AVR_CPU_FREQ) -specs=$(AVR_SPECS_FILE) -c -o $(APP_NAME).o $(APP_NAME).cpp
	avr-g++ -specs=$(AVR_SPECS_FILE) $(APP_NAME).o -o $(APP_NAME).elf
	avr-objcopy -O ihex -R .eeprom $(APP_NAME).elf $(APP_NAME).hex
	avr-size $(APP_NAME).elf

ast: $(APP_NAME).cpp
	avr-g++ -Os -fdump-tree-all-graph -DF_CPU=$(AVR_CPU_FREQ) -specs=$(AVR_SPECS_FILE) -c -o $(APP_NAME).o $(APP_NAME).cpp

upload:
	avrdude -v -p $(AVR_DEVICE) -c $(AVR_PROGRAMMER) -P $(AVR_PORT) -b $(AVR_BAUD) -U flash:w:$(APP_NAME).hex:i

clean:
	rm $(FILENAME).o
	rm $(FILENAME).elf
	rm $(FILENAME).hex
