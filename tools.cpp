#include <cmath>
#include <random>
#include "tools.h"

namespace fuzzy
{
    vector arange(real stop)
    {
        int size = static_cast<int>(std::ceil(stop));
        if (size <= 0) size = 0;
        vector v(size);
        for (int i = 0; i < size; ++i)
            v[i] = static_cast<real>(i);
        return v;
    }

    vector arange(real start, real stop, real step)
    {
        if (step == 0)
            throw std::invalid_argument("Step must be non-zero.");

        int size = static_cast<int>(std::ceil((stop - start) / step));
        if (size <= 0) size = 0;
        vector v(size);
        real val = start;
        for (int i = 0; i < size; ++i)
        {
            v[i] = val;
            val += step;
        }
        return v;
    }

    vector linspace(real start, real end, int num)
    {
        if (num <= 0)
            return vector(0);

        vector v(num);
        if (num == 1)
        {
            v[0] = start;
            return v;
        }
        real step = (end - start) / (num - 1);
        for (int i = 0; i < num; ++i)
            v[i] = start + i * step;
        return v;
    }

    vector randn(int size)
    {
        vector v(size);
        std::random_device rd;
        std::mt19937 gen(rd());
        std::normal_distribution<real> dist(0.0, 1.0);
        for (int i = 0; i < size; ++i)
            v[i] = dist(gen);
        return v;
    }
}
