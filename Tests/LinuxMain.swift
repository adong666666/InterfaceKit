#if !os(watchOS)
import XCTest

import InterfaceKitTests

var tests = [XCTestCaseEntry]()
tests += InterfaceKitTests.allTests()
XCTMain(tests)
#endif
