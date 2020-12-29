#include "morse.h"

#include <avr/io.h>
#include <util/delay.h>

#include <array>
#include <various>

enum class Lexem {
    NONE = 0,
    SHORT,
    LONG,
    BREAK
};

static constexpr inline auto MAX_LEXEMES = 5;

using Code = ftd::array<Lexem, MAX_LEXEMES>;

constexpr Code&& translate(const char c)
{
    Code result;
    using L = Lexem;
    switch(c) {
        case 'A':
            result = Code (L::SHORT, L::LONG);
            break;
        case 'B':
            result = Code (L::LONG, L::SHORT, L::SHORT, L::SHORT);
            break;
        case 'C':
            result = Code (L::LONG, L::SHORT, L::LONG, L::SHORT);
            break;
        case 'D':
            result = Code (L::LONG, L::SHORT, L::SHORT);
            break;
        case 'E':
            result = Code (L::SHORT);
            break;
        case 'F':
            result = Code (L::SHORT, L::SHORT, L::LONG, L::SHORT);
            break;
        default:
            break;
    };
    return ftd::forward<Code>(result);
}

void morse(const char* str)
{
    constexpr auto SHORT_MS = 50;
    constexpr auto LONG_MS  = 100;
    constexpr auto BREAK_MS = 200;

    while(str++)
    {
        _delay_ms(BREAK_MS);
    }
}
