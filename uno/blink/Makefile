PORT=/dev/ttyACM0
PROGRAMMER=arduino
BAUD=115200
APP_NAME=blink_led

SPECS_FILE=/usr/local/avr/lib/gcc/avr/11.0.0/device-specs/specs-atmega328p
DEVICE=ATMEGA328P

blink_led: $(APP_NAME).cpp
	avr-g++ -Os -DF_CPU=16000000UL -specs=$(SPECS_FILE) -c -o $(APP_NAME).o $(APP_NAME).cpp
	avr-g++ -specs=$(SPECS_FILE) $(APP_NAME).o -o $(APP_NAME).elf
	avr-objcopy -O ihex -R .eeprom $(APP_NAME).elf $(APP_NAME).hex
	avr-size $(APP_NAME).elf

upload:
	avrdude -v -p $(DEVICE) -c $(PROGRAMMER) -P $(PORT) -b $(BAUD) -U flash:w:$(APP_NAME).hex:i

clean:
	rm $(FILENAME).o
	rm $(FILENAME).elf
	rm $(FILENAME).hex
