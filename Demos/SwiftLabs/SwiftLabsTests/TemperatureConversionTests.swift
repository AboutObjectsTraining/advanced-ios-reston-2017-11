import XCTest
@testable import SwiftLabs

class TemperatureConversionTests: XCTestCase
{
    override func setUp() { super.setUp(); print() }
    override func tearDown() { print(); super.tearDown() }
    
    func testConvertCelsiusToFahrenheit() {
        let fahrenheit = convertedToFahrenheit(celsius: 0.0)
        XCTAssertEqual(fahrenheit, 32.0)
    }
    
    func testConvertFahrenheitToCelsius() {
        let celsius = convertedToCelsius(fahrenheit: 32.0)
        XCTAssertEqual(celsius, 0.0)
    }
    
    func testArrays() {
         let a = Array<Int>()
        
        let numbers = [3, 1, 4, 5, 2, 6]
        let sortedNumbers = numbers.sorted()
        print(sortedNumbers)

        let otherSortedNumbers = numbers.sorted(by: >)
        print(otherSortedNumbers)
        
        let weirdSortedNumbers = numbers.sorted(by: weird)
        print(weirdSortedNumbers)
    }
}

func weird(left: Int, right: Int) -> Bool {
    return left < 3
}
