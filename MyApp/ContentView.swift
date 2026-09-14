import SwiftUI

private let tipPercentageOptions = [0, 15, 18, 20, 25]

struct ContentView: View {
    @State private var billAmountText: String = ""
    @State private var selectedTipPercentage: Int = 18
    @State private var numberOfPeople: Int = 1

    private var calculation: TipCalculation {
        TipCalculation(
            billAmount: Double(billAmountText) ?? 0,
            tipPercentage: selectedTipPercentage,
            numberOfPeople: numberOfPeople
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Bill") {
                    TextField("Bill Amount", text: $billAmountText)
                        .keyboardType(.decimalPad)
                        .accessibilityIdentifier("billAmountField")
                }

                Section("Tip Percentage") {
                    Picker("Tip Percentage", selection: $selectedTipPercentage) {
                        ForEach(tipPercentageOptions, id: \.self) { percentage in
                            Text(percentage == 0 ? "No Tip" : "\(percentage)%")
                                .tag(percentage)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("tipPercentagePicker")
                }

                Section("People") {
                    Stepper("Number of People: \(numberOfPeople)", value: $numberOfPeople, in: 1...50)
                        .accessibilityIdentifier("numberOfPeopleStepper")
                }

                Section("Results") {
                    LabeledContent("Tip Amount") {
                        Text(calculation.tipAmount, format: .currency(code: currencyCode))
                    }
                    .accessibilityIdentifier("tipAmountValue")

                    LabeledContent("Total") {
                        Text(calculation.totalAmount, format: .currency(code: currencyCode))
                    }
                    .accessibilityIdentifier("totalAmountValue")

                    LabeledContent("Per Person") {
                        Text(calculation.amountPerPerson, format: .currency(code: currencyCode))
                    }
                    .accessibilityIdentifier("perPersonAmountValue")
                }
            }
            .navigationTitle("Tip Splitter")
        }
    }

    private var currencyCode: String {
        Locale.current.currency?.identifier ?? "USD"
    }
}

#Preview {
    ContentView()
}
