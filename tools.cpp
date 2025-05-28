#include "tools.h"
#include <cmath>
#include <random>

namespace fuzzy {
vector arange(real stop) {
  int size = static_cast<int>(std::ceil(stop));
  if (size <= 0)
    size = 0;
  vector v(size);
  for (int i = 0; i < size; ++i)
    v[i] = static_cast<real>(i);
  return v;
}

vector arange(real start, real stop, real step) {
  if (step == 0)
    throw std::invalid_argument("Step must be non-zero.");

  int size = static_cast<int>(std::ceil((stop - start) / step));
  if (size <= 0)
    size = 0;
  vector v(size);
  real val = start;
  for (int i = 0; i < size; ++i) {
    v[i] = val;
    val += step;
  }
  return v;
}

vector linspace(real start, real end, int num) {
  if (num <= 0)
    return vector(0);

  vector v(num);
  if (num == 1) {
    v[0] = start;
    return v;
  }
  real step = (end - start) / (num - 1);
  for (int i = 0; i < num; ++i)
    v[i] = start + i * step;
  return v;
}

vector randn(int size) {
  vector v(size);
  std::random_device rd;
  std::mt19937 gen(rd());
  std::normal_distribution<real> dist(0.0, 1.0);
  for (int i = 0; i < size; ++i)
    v[i] = dist(gen);
  return v;
}
vector zeros(int size) {
  vector v(size);
  return v;
}
vector ones(int size) {
  vector v(size);
  for (int i = 0; i < size; i++) {
    v[i] = 1;
  }
  return v;
}

real min(const vector &v) {
  if (v.length() == 0)
    throw std::runtime_error("Empty vector");
  real min_val = v[0];
  for (int i = 1; i < v.length(); ++i)
    if (v[i] < min_val)
      min_val = v[i];
  return min_val;
}

real max(const vector &v) {
  if (v.length() == 0)
    throw std::runtime_error("Empty vector");
  real max_val = v[0];
  for (int i = 1; i < v.length(); ++i)
    if (v[i] > max_val)
      max_val = v[i];
  return max_val;
}

int argmin(const vector &v) {
  if (v.length() == 0)
    throw std::runtime_error("Empty vector");
  int min_index = 0;
  for (int i = 1; i < v.length(); ++i)
    if (v[i] < v[min_index])
      min_index = i;
  return min_index;
}

int argmax(const vector &v) {
  if (v.length() == 0)
    throw std::runtime_error("Empty vector");
  int max_index = 0;
  for (int i = 1; i < v.length(); ++i)
    if (v[i] > v[max_index])
      max_index = i;
  return max_index;
}

vector find(const vector& v, real value) {
    std::vector<real> indices;
    for (int i = 0; i < v.length(); ++i) {
        if (v[i] == value) {
            indices.push_back(static_cast<real>(i));
        }
    }
    return vector(indices.begin(), indices.end());
}
} // namespace fuzzy
