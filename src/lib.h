#pragma once

#include <iostream>

namespace ya_std {

std::ostream &operator<<(std::ostream &os, const std::string &str);

std::ostream &endl(std::ostream &os);

std::ostream& cout();

extern "C" int asm_sum(int a, int b);

} // namespace ya_std