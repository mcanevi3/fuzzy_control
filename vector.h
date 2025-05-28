#ifndef VECTOR_H
#define VECTOR_H

#include <initializer_list>
#include <iostream>
#include <stdexcept>
#include "real.h"

namespace fuzzy
{
    class vector
    {
    private:
        real* _arr;
        int _size;

    public:
        // Constructors and destructor
        explicit vector(int size);
        vector(std::initializer_list<real> list);
        vector(const vector& other);
        vector& operator=(const vector& other);
        ~vector();

        int length() const { return _size; }

        // Indexing operator
        real& operator[](int index);
        const real& operator[](int index) const;

        // Arithmetic operators
        vector operator+(const vector& rhs) const;
        vector operator-(const vector& rhs) const;
        vector operator*(real scalar) const; // scalar multiplication

        // Dot product
        real dot(const vector& rhs) const;

        void print() const;
    };
}

#endif
