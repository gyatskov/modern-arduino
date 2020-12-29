#include <avr/io.h>
#include <util/delay.h>

#include <various>

static constexpr inline auto BLINK_DELAY_MS = 3000U;


template<unsigned long Index, typename Fun>
static inline constexpr void static_for(Fun&& fun) {
    fun(ftd::integral_constant<ftd::size_t, Index>());
    if constexpr(Index > 0) {
        static_for<Index-1, Fun>(ftd::move(fun));
    }
}

int main (void) {
    /*Set to one the fifth bit of DDRB to one
    **Set digital pin 13 to output mode */
    DDRB |= _BV(DDB5);

    static_for<200>([] (const auto wait_ms){
        /*Set to one the fifth bit of PORTB to one
        **Set to HIGH the pin 13 */
        PORTB |= _BV(PORTB5);

        _delay_ms(wait_ms);

        /*Set to zero the fifth bit of PORTB
        **Set to LOW the pin 13 */
        PORTB &= ~_BV(PORTB5);

        /*Wait 3000 ms */
        _delay_ms(BLINK_DELAY_MS);
    }
    );
}
