import SwiftUI

struct OnboardingAccentColorView: View {
    @Binding var selectedAccentColor: String
    let language: AppLanguage

    private let columns = [GridItem(.adaptive(minimum: 78), spacing: 16)]

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            OnboardingHeader(
                symbol: "paintpalette.fill",
                title: "theme.accentColor".localized(language),
                subtitle: "theme.chooseFavoriteColor".localized(language)
            )

            LazyVGrid(columns: columns, alignment: .leading, spacing: 16) {
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
            .padding(18)
            .surfaceCard(cornerRadius: 28)
        }
    }
}
