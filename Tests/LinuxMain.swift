import XCTest

import filterTests

var tests = [XCTestCaseEntry]()
tests += filterTests.allTests()
XCTMain(tests)
