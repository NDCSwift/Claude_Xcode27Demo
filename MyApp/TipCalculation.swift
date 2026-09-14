import Foundation

struct TipCalculation {
    var billAmount: Double
    var tipPercentage: Int
    var numberOfPeople: Int

    var tipAmount: Double {
        billAmount * Double(tipPercentage) / 100
    }

    var totalAmount: Double {
        billAmount + tipAmount
    }

    var amountPerPerson: Double {
        numberOfPeople > 0 ? totalAmount / Double(numberOfPeople) : totalAmount
    }
}
