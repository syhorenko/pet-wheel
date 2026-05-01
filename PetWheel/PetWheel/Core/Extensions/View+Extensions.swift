import SwiftUI

extension View {
    func cardStyle() -> some View {
        self
            .background(Color.cardSurface)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(Color.cardBorder, lineWidth: 1)
            )
    }

    func primaryButtonStyle() -> some View {
        self
            .font(.headline.weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.neonPurple, Color.neonPurpleLight],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .shadow(color: Color.neonPurple.opacity(0.45), radius: 14, x: 0, y: 4)
    }
}
