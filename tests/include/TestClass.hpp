/**
 * @file  TestClass.hpp
 * @brief TestClass
 *
 * Class definition for TestClass
 *
 * @author     Clay Freeman
 * @date       April 15, 2015
 */

#ifndef _TESTCLASS_HPP
#define _TESTCLASS_HPP

union ISOFunction {
  void* o;
  void (*f)();
};

class TestClass {
  private:
    void* dlhandle = nullptr;
  public:
    TestClass();
    ~TestClass();
    void callModule();
};

#endif
