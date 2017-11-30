import UIKit

var x: Int

x = 10

print(x)

print("Value is \(x + 2), other value is \(x / 3)", x, x, separator: ", ")

var temperature = 98.6
temperature -= 0.011

print("My temperature is \(temperature)")

let tempText = String(format: "My temperature is %.1f", temperature)
print(tempText)

func display(degrees: Double, scale: String) {
    print("The temperature is \(degrees)° \(scale)")
}

display(degrees: 90.0, scale: "F")


