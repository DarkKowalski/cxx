#include "lib.h"

namespace ya_std {

std::ostream &operator<<(std::ostream &os, const std::string &str) {
  return os << str.c_str();
}

std::ostream &endl(std::ostream &os) {
  os << std::endl;
  return os;
}

std::ostream& cout() {
  return std::cout;
}

} // namespace ya_std