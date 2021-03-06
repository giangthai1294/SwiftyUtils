//
//  Created by Tom Baranes on 23/04/16.
//  Copyright © 2016 Tom Baranes. All rights reserved.
//

import XCTest
import SwiftyUtils

final class DataExtensionTests: XCTestCase {
    let testString = "base 10 is so basic. base 16 is where it's at, yo."

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
}

extension DataExtensionTests {

    func testToHexString() {
        guard let data = testString.data(using: .utf8) else {
            XCTFail("Couldn't make data out of provided string")
            return
        }
        var hex = data.toHexString(spaces: true)
        // swiftlint:disable:next line_length
        XCTAssertTrue(hex == "62617365 20313020 69732073 6F206261 7369632E 20626173 65203136 20697320 77686572 65206974 27732061 742C2079 6F2E", "'\(hex)' == '62617365 20313020 69732073 6F206261 7369632E 20626173 65203136 20697320 77686572 65206974 27732061 742C2079 6F2E'")

        hex = data.toHexString(hexLeader: true)
        // swiftlint:disable:next line_length
        XCTAssertTrue(hex == "0x6261736520313020697320736F2062617369632E206261736520313620697320776865726520697427732061742C20796F2E")

        hex = data.toHexString()
        // swiftlint:disable:next line_length
        XCTAssertTrue(hex == "6261736520313020697320736F2062617369632E206261736520313620697320776865726520697427732061742C20796F2E")
    }

    func testHexToData() {
        // swiftlint:disable:next line_length
        var hexString = "6261736520313020697320736F2062617369632E206261736520313620697320776865726520697427732061742C20796F2E"
        do { // adding scope level so we can reuse variable names
            guard let data = Data(hexString: hexString) else {
                XCTFail("Couldn't make data out of provided string")
                return
            }
            guard let string = String(data: data, encoding: .utf8) else {
                XCTFail("Couldn't make string out of data")
                return
            }

            XCTAssertTrue(testString == string, "\(testString) == \(string)")
        }

        // swiftlint:disable:next line_length
        hexString = "62617365 20313020 69732073 6F206261 7369632E 20626173 65203136 20697320 77686572 65206974 27732061 742C2079 6F2E"
        do { // adding scope level so we can reuse variable names
            guard let data = Data(hexString: hexString) else {
                XCTFail("Couldn't make data out of provided string")
                return
            }
            guard let string = String(data: data, encoding: .utf8) else {
                XCTFail("Couldn't make string out of data")
                return
            }

            XCTAssertTrue(testString == string, "\(testString) == \(string)")
        }

        // swiftlint:disable:next line_length
        hexString = "0x6261736520313020697320736F2062617369632E206261736520313620697320776865726520697427732061742C20796F2E"
        do { // adding scope level so we can reuse variable names
            guard let data = Data(hexString: hexString) else {
                XCTFail("Couldn't make data out of provided string")
                return
            }
            guard let string = String(data: data, encoding: .utf8) else {
                XCTFail("Couldn't make string out of data")
                return
            }

            XCTAssertTrue(testString == string, "\(testString) == \(string)")
        }

        var badHexString = "agasfdlikasdgd" //illegal characters - letters
        do { // adding scope level so we can reuse variable names
            XCTAssertNil(Data(hexString: badHexString))
        }

        badHexString = "deadbe;fcaf$" //illegal characters - symbols
        do { // adding scope level so we can reuse variable names
            XCTAssertNil(Data(hexString: badHexString))
        }

        badHexString = "deadbeefcafee" //odd # of characters
        do { // adding scope level so we can reuse variable names
            XCTAssertNil(Data(hexString: badHexString))
        }
    }

    func testDataToBytesArray() {
        let count = 10
        let unsafe = UnsafeMutableBufferPointer<UInt8>.allocate(capacity: count)
        unsafe.initialize(repeating: 0)
        for index in 0..<count {
            unsafe[index] = UInt8(count - index)
        }

        let data = Data(buffer: unsafe)
        let array = data.bytesArray

        for index in 0..<count {
            XCTAssertTrue(array[index] == count - index)
        }
    }
}

// MARK: - Dictionary Mapping

extension DataExtensionTests {

    func testToDictionary_success() {
        let jsonObject = ["int": 1, "bool": true, "string": "test"] as [String: Any]
        let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: [])
        do {
            let dictionary = try data!.toDictionary()!
            XCTAssertTrue(NSDictionary(dictionary: dictionary).isEqual(to: jsonObject))
        } catch {
            XCTFail("Should not failed when mapping from a valid json")
        }
    }

    func testToDictionary_withoutValue() {
        do {
            _ = try "".data(using: .utf8)!.toDictionary()
            XCTFail("Should not successfully create a dictionary")
        } catch let error {
            XCTAssertNotNil(error)
        }
    }

}
