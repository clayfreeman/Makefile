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
  struct tm result;
  time_t raw = 0;

  // Fetch time
  time(&raw);
  localtime_r(&raw, &result);

  std::cout << mktime(&result) << " seconds since the Epoch\n";
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
