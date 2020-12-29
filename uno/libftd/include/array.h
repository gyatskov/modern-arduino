#pragma once

#include "various.h"
#include "cstddef"
#include "cstring"


namespace ftd {


template<class T, size_t N>
class array
{
public:
    using type = array<T,N>;

    template<typename... Ts>
    constexpr array(Ts&&... ts)
    {
        T copy[N] = { ftd::forward<Ts>(ts)... };
        memcpy(_data, copy, N*sizeof(T));
    }


    constexpr explicit array() {
        for(size_t i = 0; i < N; i++)
        {
            _data[i] = T{};
        }
    }

    explicit array(const array& other) {
        *this = other;
    }

    explicit array(const array&& other) {
        *this = other;
    }

    ~array() = default;

    constexpr array& operator=(const array& other) {
        for(size_t i = 0; i < N; i++)
        {
            _data[i] = other._data[i];
        }
        return *this;
    }

    T* data() {
        return _data;
    }

    const T* data() const {
        return _data;
    }

private:
    T _data[N];
};

//template<typename... Ts>
//constexpr auto make_array(Ts&&... ts)
//    -> ftd::array<std::common_type_t<Ts...>,sizeof...(Ts)>
//{
//    return { std::forward<Ts>(ts)... };
//}


} // namespace ftd
