#include "lib.h"

int main() {

  for (int i = 0; i < ya_std::asm_sum(ya_std::one(), ya_std::two()); ++i) {
    ya_std::cout() << "Hello, World!" << ya_std::endl;
  }
  return 0;
}
