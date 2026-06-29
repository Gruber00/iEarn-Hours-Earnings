import SwiftUI

struct ChartStylePicker: View {
    @Binding var chartStyle: String
    let language: AppLanguage

    var body: some View {
        Picker("chart.style".localized(language), selection: $chartStyle) {
            ForEach(ChartStyle.allCases) { style in
                Label(style.displayKey.localized(language), systemImage: style.symbolName)
                    .tag(style.rawValue)
            }
        }
        .pickerStyle(.inline)
    }
}
