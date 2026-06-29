import SwiftUI

struct AccentColorPicker: View {
    @Binding var selectedAccentColor: String
    let language: AppLanguage

    private let columns = [GridItem(.adaptive(minimum: 74), spacing: 14)]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("theme.chooseFavoriteColor".localized(language))
                .font(.subheadline)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                ForEach(AppAccentColor.allCases) { accentColor in
                    AccentColorCircle(
                        accentColor: accentColor,
                        isSelected: selectedAccentColor == accentColor.rawValue
                    ) {
                        withAnimation(.smooth) {
                            selectedAccentColor = accentColor.rawValue
                        }
                    }
                }
            }
        }
        .padding(.vertical, 4)
    }
}
