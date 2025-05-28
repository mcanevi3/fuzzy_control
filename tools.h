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
}

#endif
