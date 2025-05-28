#ifndef REAL_H
#define REAL_H

namespace fuzzy
{
    using real = double;
    constexpr real INF_VAL = std::numeric_limits<real>::infinity();
    constexpr real NAN_VAL = std::numeric_limits<real>::quiet_NaN();
}

#endif