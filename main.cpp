#include "vector.h"
#include "tools.h"
#include <iostream>

using namespace fuzzy;
int main()
{
    auto v = vector{1.0, 2.0, 3.0,4,5};
    v.print();

    auto w = arange(5);
    w.print();

    auto x = linspace(0, 1, 5);
    x.print();

    auto y = v + w * 2.0;
    y.print();

    auto dotp = v.dot(w);
    std::cout << "Dot product: " << dotp << std::endl;

    auto r = randn(5);
    r.print();

    return 0;
}
