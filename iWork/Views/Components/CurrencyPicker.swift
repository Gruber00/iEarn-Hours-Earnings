import SwiftUI

struct CurrencyPicker: View {
    @Binding var currency: String

    var body: some View {
        Picker("Währung", selection: $currency) {
            ForEach(SettingsViewModel.currencies, id: \.self) { currency in
                Text(currency).tag(currency)
            }
        }
    }
}
