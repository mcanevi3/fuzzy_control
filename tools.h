#ifndef TOOLS_H
#define TOOLS_H

#include "real.h"
#include "vector.h"

namespace fuzzy
{
    vector arange(real stop);
    vector arange(real start, real stop, real step = 1);
    vector linspace(real start, real end, int num);
    vector randn(int size);
    vector zeros(int size);
    vector ones(int size);

    real min(const vector& v);
    real max(const vector& v);
    int argmin(const vector& v);
    int argmax(const vector& v);

    fuzzy::vector find(const fuzzy::vector& v, fuzzy::real value);

    struct vector_enumerator
    {
        const vector& vec;

        struct iterator
        {
            size_t index;
            const real* ptr;

            bool operator!=(const iterator& other) const { return ptr != other.ptr; }
            void operator++() { ++index; ++ptr; }
            std::pair<size_t, real> operator*() const { return {index, *ptr}; }
        };

        iterator begin() const { return {0, vec.begin()}; }
        iterator end() const { return {0, vec.end()}; }
    };

    inline vector_enumerator enumerate(const vector& v)
    {
        return vector_enumerator{v};
    }
}

#endif
