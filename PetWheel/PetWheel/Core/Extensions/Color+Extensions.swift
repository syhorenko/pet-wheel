import SwiftUI

extension Color {
    static let appBackground  = Color(red: 0.05, green: 0.05, blue: 0.08)
    static let cardSurface    = Color(red: 0.10, green: 0.10, blue: 0.15)
    static let cardSurface2   = Color(red: 0.14, green: 0.14, blue: 0.21)
    static let cardBorder     = Color.white.opacity(0.08)
    static let neonPurple     = Color(red: 0.49, green: 0.23, blue: 0.93)
    static let neonPurpleLight = Color(red: 0.60, green: 0.31, blue: 0.96)
    static let mutedText      = Color(red: 0.54, green: 0.54, blue: 0.66)

    static let wheelColors: [Color] = [
        Color(red: 0.49, green: 0.23, blue: 0.93), // violet
        Color(red: 0.93, green: 0.28, blue: 0.60), // hot pink
        Color(red: 0.23, green: 0.51, blue: 0.96), // electric blue
        Color(red: 0.02, green: 0.71, blue: 0.83), // cyan
        Color(red: 0.98, green: 0.45, blue: 0.09), // orange
        Color(red: 0.92, green: 0.71, blue: 0.03), // yellow
        Color(red: 0.06, green: 0.72, blue: 0.51), // emerald
        Color(red: 0.94, green: 0.27, blue: 0.27), // red
    ]
}
