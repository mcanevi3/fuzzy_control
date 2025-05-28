#include "vector.h"

namespace fuzzy
{
    vector::vector(int size) : _size(size)
    {
        if (_size <= 0)
            throw std::invalid_argument("Size must be positive.");
        _arr = new real[_size]{0};
    }

    vector::vector(std::initializer_list<real> list) : _size(static_cast<int>(list.size()))
    {
        _arr = new real[_size];
        int i = 0;
        for (auto val : list)
            _arr[i++] = val;
    }

    vector::vector(const vector& other) : _size(other._size)
    {
        _arr = new real[_size];
        for (int i = 0; i < _size; ++i)
            _arr[i] = other._arr[i];
    }

    vector& vector::operator=(const vector& other)
    {
        if (this == &other)
            return *this;

        delete[] _arr;
        _size = other._size;
        _arr = new real[_size];
        for (int i = 0; i < _size; ++i)
            _arr[i] = other._arr[i];
        return *this;
    }

    vector::~vector()
    {
        delete[] _arr;
    }

    real& vector::operator[](int index)
    {
        if (index < 0 || index >= _size)
            throw std::out_of_range("Index out of bounds");
        return _arr[index];
    }

    const real& vector::operator[](int index) const
    {
        if (index < 0 || index >= _size)
            throw std::out_of_range("Index out of bounds");
        return _arr[index];
    }

    vector vector::operator+(const vector& rhs) const
    {
        if (_size != rhs._size)
            throw std::invalid_argument("Vectors must be the same size for addition.");
        vector result(_size);
        for (int i = 0; i < _size; ++i)
            result._arr[i] = _arr[i] + rhs._arr[i];
        return result;
    }

    vector vector::operator-(const vector& rhs) const
    {
        if (_size != rhs._size)
            throw std::invalid_argument("Vectors must be the same size for subtraction.");
        vector result(_size);
        for (int i = 0; i < _size; ++i)
            result._arr[i] = _arr[i] - rhs._arr[i];
        return result;
    }

    vector vector::operator*(real scalar) const
    {
        vector result(_size);
        for (int i = 0; i < _size; ++i)
            result._arr[i] = _arr[i] * scalar;
        return result;
    }

    real vector::dot(const vector& rhs) const
    {
        if (_size != rhs._size)
            throw std::invalid_argument("Vectors must be the same size for dot product.");
        real result = 0;
        for (int i = 0; i < _size; ++i)
            result += _arr[i] * rhs._arr[i];
        return result;
    }

    void vector::print() const
    {
        std::cout << "[ ";
        for (int i = 0; i < _size; ++i)
            std::cout << _arr[i] << " ";
        std::cout << "]\n";
    }
}
