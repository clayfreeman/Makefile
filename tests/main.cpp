/**
 * @file  main.cpp
 * @brief Dynamic Makefile
 *
 * Test driver to showcase the dynamic Makefile
 *
 * @author     Clay Freeman
 * @date       April 15, 2015
 */

#include <iostream>
#include "include/TestClass.hpp"

int main() {
  // Instantiate a TestClass
  TestClass test;
  // Indirectly load a TestModule and call its printTime method (x3)
  for (int i = 0; i < 3; i++)
    test.callModule();

  return 0;
}
