#if !os(watchOS)
import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(InterfaceKitTests.allTests),
    ]
}
#endif
#endif
