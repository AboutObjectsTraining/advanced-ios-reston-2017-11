import Foundation

func convertedToCelsius(fahrenheit: Double) -> Double {
    return (fahrenheit - 32) * (5.0/9.0)
}

func convertedToFahrenheit(celsius: Double) -> Double {
    return (celsius * 9.0/5.0) + 32
}

//func compareCelsiusToFahrenheit<T: Comparable>(celsius: T, fahrenheit: T) -> Bool {
//
//}


struct TemperatureConverter: Equatable {
    
    static func ==(left: TemperatureConverter, right: TemperatureConverter) -> Bool {
        return left.kelvin == right.kelvin
    }

    var kelvin: Double {
        willSet { print(newValue) }
        didSet { print(oldValue) }
    }
    
//    func setKelvin(newValue: Double) {
//        if willSet != nil { willSet(newValue) }
//        let oldValue = _kelvin
//        // Now really set the instance variable
//        _kelvin = newValue
//        if didSet != nil { didSet(oldValue)}
//    }
//    
}
