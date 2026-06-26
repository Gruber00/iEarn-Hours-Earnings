import SwiftUI

struct CurrencyPicker: View {
    @Binding var currency: String
    let language: AppLanguage

    var body: some View {
        Picker("settings.currency".localized(language), selection: $currency) {
            ForEach(SettingsViewModel.currencies, id: \.self) { currency in
                Text(currency).tag(currency)
            }
        }
    }
}
