import SwiftUI

struct MonthStepper: View {
    @Binding var selectedMonth: Date
    let language: AppLanguage
    @State private var directionPulse = 0

    var body: some View {
        HStack(spacing: 14) {
            Button(action: previousMonth) {
                Image(systemName: "chevron.left")
                    .font(.headline.bold())
                    .frame(width: 42, height: 42)
                    .symbolEffect(.bounce, value: directionPulse)
            }
            .glassButtonIfAvailable()
            .accessibilityLabel("home.previousMonth".localized(language))

            Text(selectedMonth.appMonthTitle(language: language))
                .font(.title3.bold())
                .frame(maxWidth: .infinity)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Button(action: nextMonth) {
                Image(systemName: "chevron.right")
                    .font(.headline.bold())
                    .frame(width: 42, height: 42)
                    .symbolEffect(.bounce, value: directionPulse)
            }
            .glassButtonIfAvailable()
            .accessibilityLabel("home.nextMonth".localized(language))
        }
        .padding(8)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func previousMonth() {
        directionPulse += 1
        withAnimation(.smooth) {
            selectedMonth = DateHelper.addingMonths(-1, to: selectedMonth)
        }
    }

    private func nextMonth() {
        directionPulse += 1
        withAnimation(.smooth) {
            selectedMonth = DateHelper.addingMonths(1, to: selectedMonth)
        }
    }
}
