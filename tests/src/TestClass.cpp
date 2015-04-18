/**
 * @file  TestClass.cpp
 * @brief TestClass
 *
 * Class implementation for TestClass
 *
 * @author     Clay Freeman
 * @date       April 15, 2015
 */

#include <dlfcn.h>
#include "../include/TestClass.hpp"
#include "../modules/include/TestModule.hpp"

/**
 * @brief TestClass Constructor
 *
 * Opens a handle to the shared object at "modules/src/TestModule.so"
 *
 * @remarks
 * The handle provided by dlopen(...) should be closed by the destructor from
 * this class
 */
TestClass::TestClass() {
  // Open a shared object handle
  this->dlhandle = dlopen("modules/src/TestModule.so", RTLD_NOW);
}

/**
 * @brief TestClass Destructor
 *
 * Closes the handle given by dlopen(...)
 */
TestClass::~TestClass() {
  // Close the shared object handle
  dlclose(this->dlhandle);
}

/**
 * @brief Call Module
 *
 * Responsible for fetching an instance of TestModule from the dynamically
 * linked shared object
 */
void TestClass::callModule() {
  // Fetch a pointer to the helper function "_load"
  TestModule* (*m)() = (TestModule* (*)())dlsym(this->dlhandle, "_load");
  // Create a TestModule and immediately destroy it (to call the constructor to
  // prevent this example from requiring inheritance)
  delete m();
}
