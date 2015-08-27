/**
 * @file  TestModule.cpp
 * @brief TestModule
 *
 * Class implementation for TestModule
 *
 * @author     Clay Freeman
 * @date       April 15, 2015
 */

#include <ctime>
#include <iostream>
#include "../include/TestModule.hpp"

/**
 * @brief TestModule Constructor
 *
 * Prints the time and number of seconds since the Unix epoch in local time
 */
TestModule::TestModule() {
  time_t result = time(nullptr);
  std::cout << localtime_r(&result, nullptr)
            << result << " seconds since the Epoch\n";
}

/**
 * @brief Load
 *
 * Helper function to instantiate a new TestModule and return a pointer to it
 *
 * @remarks
 * The memory for the TestModule must be deleted externally
 *
 * @return A TestModule pointer
 */
extern "C" TestModule* _load() {
  return new TestModule;
}
