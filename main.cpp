#include "vector.h"
#include "tools.h"
#include <iostream>

using namespace fuzzy;
int main()
{
    auto vec1=vector{1,2,3};
    // for(auto v:vec1)
    // {
    //     std::cout << v<<" " << std::endl;
    // }
    for (auto [i, v] : enumerate(vec1))
    {
        std::cout << i << ": " << v << "\n";
    }

    return 0;
}
