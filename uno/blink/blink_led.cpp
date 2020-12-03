#include <avr/io.h>
#include <util/delay.h>

static constexpr inline auto BLINK_DELAY_MS = 3000U;

namespace ftd {

using size_t = unsigned long;

// utility
template< class T, T... Ints >
class integer_sequence;

template<ftd::size_t... Ints>
using index_sequence = ftd::integer_sequence<ftd::size_t, Ints...>;

namespace detail {

template <ftd::size_t N, ftd::size_t ... Next>
struct indexSequenceHelper : public indexSequenceHelper<N-1U, N-1U, Next...>
 { };

template <ftd::size_t ... Next>
struct indexSequenceHelper<0U, Next ... >
 { using type = index_sequence<Next ... >; };

template <ftd::size_t N>
using makeIndexSequence = typename indexSequenceHelper<N>::type;

} // namespace detail


template<class T, T N>
using make_integer_sequence = typename ftd::detail::indexSequenceHelper<N>::type;

template<ftd::size_t N>
using make_index_sequence = ftd::make_integer_sequence<ftd::size_t, N>;

template<class... T>
using index_sequence_for = ftd::make_index_sequence<sizeof...(T)>;

template<class T, T v>
struct integral_constant {
    static constexpr T value = v;
    using value_type = T;
    using type = integral_constant; // using injected-class-name
    constexpr operator value_type() const noexcept { return value; }
    constexpr value_type operator()() const noexcept { return value; } //since c++14
};

//

template<typename T, typename U>
constexpr decltype(auto) forward(U && u) noexcept
{
    return static_cast<T &&>(u);
}

template<typename T> struct remove_reference { typedef T type; };
template<typename T> struct remove_reference<T&> { typedef T type; };
template<typename T> struct remove_reference<T&&> { typedef T type; };

template<typename T>
constexpr typename remove_reference<T>::type && move(T && arg) noexcept
{
  return static_cast<typename remove_reference<T>::type &&>(arg);
}

} // namespace ftd

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
