##########################################################################
# Input variables
#
# AVR_DEVICE (default: atmega328p)
#     the name of AVR the application is built for
# AVR_CPU_FREQ (default: 16000000UL = 16 MHz)
#     the speed in MHz of the AVR DEVICE
# AVR_UPLOADER (default: avrdude)
#     the application used to upload to the DEVICE
# AVR_PORT (default: /dev/ttyACM0)
#     the port used for the upload tool, e.g. serial port
# AVR_PROGRAMMER (default: arduino) the programmer hardware used, e.g. arduino
##########################################################################


##########################################################################
# add_avr_executable
# - IN_VAR: EXECUTABLE_NAME
#
# Creates targets and dependencies for AVR toolchain, building an
# executable. Calls add_executable with ELF file as target name, so
# any link dependencies need to be using that target, e.g. for
# target_link_libraries(<EXECUTABLE_NAME>-${AVR_DEVICE}.elf ...).
##########################################################################

function( add_avr_executable EXECUTABLE_NAME )

    if( NOT ARGN )
       message( FATAL_ERROR "No source files given for ${EXECUTABLE_NAME}." )
    endif( NOT ARGN )

    # Target file names
    set( elf_file ${EXECUTABLE_NAME}.elf )
    set( hex_file ${EXECUTABLE_NAME}.hex )
    set( map_file ${EXECUTABLE_NAME}.map )
    set( eeprom_image ${EXECUTABLE_NAME}-eeprom.hex )

    # Target ELF file
    add_executable( ${elf_file}
        EXCLUDE_FROM_ALL ${ARGN}
    )

    # Specs file from library
    find_file(AVR_SPECS_FILE
        NAMES "specs-${AVR_DEVICE}"
        PATHS "${CMAKE_PREFIX_PATH}/lib/gcc/avr/${CMAKE_CXX_COMPILER_VERSION}/device-specs"
        REQUIRED
     )
    message(STATUS "Using specs file: ${AVR_SPECS_FILE}")

    # Compilation flags
    target_compile_options( ${elf_file}
        PUBLIC
         -ffunction-sections      # generate separate ELF section for each function
         -fdata-sections          # generate separate ELF section for each data item
         -fpack-struct            # pack all struct members together without intermediate space (breaks bin compat)
         -fshort-enums            # use no more than required bytes for enums (breaks bin compat)
         -funsigned-char          # C: let char := unsigned char
         -funsigned-bitfields     # C: let bitfield := unsigned bitfield
         -specs=${AVR_SPECS_FILE} # use specs file determined above
         -DF_CPU=${AVR_CPU_FREQ}  # specify CPU rate
         -Os                      # optimize for size
    )

    # Linking flags
    # * Use correct specs file
    # * Generate map file
    # * Remove unused functions
    # * Try replacing CALL/JMP with RCALL/RJMP
    target_link_options( ${elf_file}
        PUBLIC
         -specs=${AVR_SPECS_FILE}
         -Wl,--gc-sections -mrelax
         -Wl,-Map,${map_file}
     )

     # HEX file
     add_custom_command(
         OUTPUT ${hex_file}
         COMMAND
             ${AVR_OBJCOPY} -j .text -j .data -O ihex ${elf_file} ${hex_file}
         COMMAND
             ${AVR_SIZE} ${elf_file}
         DEPENDS
             ${elf_file}
     )

     # EEPROM
     add_custom_command(
         OUTPUT ${eeprom_image}
         COMMAND
             ${AVR_OBJCOPY} -j .eeprom --set-section-flags=.eeprom=alloc,load
                 --change-section-lma .eeprom=0 --no-change-warnings
                 -O ihex ${elf_file} ${eeprom_image}
         DEPENDS
             ${elf_file}
     )

     # Executable
     add_custom_target( ${EXECUTABLE_NAME}
         ALL
         DEPENDS ${hex_file} ${eeprom_image}
     )

     # Make the result of the executable target the elf file
     set_target_properties( ${EXECUTABLE_NAME}
         PROPERTIES
             OUTPUT_NAME "${elf_file}"
     )

    # clean
    get_directory_property( clean_files ADDITIONAL_MAKE_CLEAN_FILES )
    set_directory_properties(
       PROPERTIES
          ADDITIONAL_MAKE_CLEAN_FILES "${map_file}"
    )

    # upload executable - with avrdude
    add_custom_target(
       upload_${EXECUTABLE_NAME}
       ${AVR_DUDE} -p ${AVR_DEVICE} -c ${AVR_PROGRAMMER}
          -b ${AVR_BAUD}
          -U flash:w:${hex_file}
          -P ${AVR_PORT}
       DEPENDS ${hex_file}
       COMMENT "Uploading ${hex_file} to ${AVR_DEVICE} (${AVR_PORT}) using ${AVR_PROGRAMMER}"
    )

    # upload eeprom only - with avrdude
    # see also bug http://savannah.nongnu.org/bugs/?40142
    add_custom_target(
       upload_eeprom_${EXECUTABLE_NAME}
       ${AVR_DUDE} -p ${AVR_DEVICE} -c ${AVR_PROGRAMMER}
          -b ${AVR_BAUD}
          -U eeprom:w:${eeprom_image}
          -P ${AVR_PORT}
       DEPENDS ${eeprom_image}
       COMMENT "Uploading ${eeprom_image} to ${AVR_DEVICE} using ${AVR_PROGRAMMER}"
    )

    # get status
    add_custom_target(
       get_status_${EXECUTABLE_NAME}
       ${AVR_UPLOADTOOL} -p ${AVR_DEVICE} -c ${AVR_PROGRAMMER} -P ${AVR_UPLOADTOOL_PORT} -n -v
       COMMENT "Get status from ${AVR_DEVICE}"
    )

    # disassemble
    add_custom_target(
       disassemble_${EXECUTABLE_NAME}
       ${AVR_OBJDUMP} -h -S ${elf_file} > ${EXECUTABLE_NAME}.lst
       DEPENDS ${elf_file}
    )

    # size
    add_custom_target(
       size_${EXECUTABLE_NAME}
          ${AVR_SIZE_TOOL} ${AVR_SIZE_ARGS} ${elf_file}  "|" ${AWK} -f firmwaresize_${EXECUTABLE_NAME}.awk
       DEPENDS ${elf_file} firmwaresize_${EXECUTABLE_NAME}.awk
    )

    add_custom_target(
       firmwaresize_${EXECUTABLE_NAME}.awk
       COMMAND
         echo "BEGIN {ORS=\"\";print \"\\\\n\\\\033[1;33mFirmware size (\"}" > firmwaresize_${EXECUTABLE_NAME}.awk
       COMMAND
         echo "/^Device/ {print \$2 \") is...  \"}" >> firmwaresize_${EXECUTABLE_NAME}.awk
       COMMAND
         echo "/^Program/ {print \"Flash (program): \" \$2 \" \" \$3 \" \" \$4 \")  \"}" >> firmwaresize_${EXECUTABLE_NAME}.awk
       COMMAND
         echo "/^Data/ {print \"RAM\ (globals): \" \$2 \" \" \$3 \" \" \$4 \")  \"}" >> firmwaresize_${EXECUTABLE_NAME}.awk
       COMMAND
         echo "END {print \"\\\\033[0m\\\\n\\\\n\"}" >> firmwaresize_${EXECUTABLE_NAME}.awk
       VERBATIM
    )

endfunction( add_avr_executable EXECUTABLE_NAME )
