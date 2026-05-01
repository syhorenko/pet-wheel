import SwiftUI

struct WheelSpinnerView: View {
    let activities: [PetActivity]
    let rotationAngle: Double

    private var sliceDegrees: Double { 360.0 / Double(activities.count) }

    var body: some View {
        ZStack {
            ForEach(Array(activities.enumerated()), id: \.offset) { index, activity in
                WheelSliceView(
                    activity: activity,
                    index: index,
                    total: activities.count,
                    sliceDegrees: sliceDegrees
                )
            }

            Circle()
                .strokeBorder(Color.white.opacity(0.10), lineWidth: 2)

            Circle()
                .fill(Color.appBackground)
                .frame(width: 56, height: 56)
                .shadow(color: Color.neonPurple.opacity(0.55), radius: 10)

            Circle()
                .strokeBorder(Color.neonPurple.opacity(0.55), lineWidth: 1.5)
                .frame(width: 56, height: 56)

            Image(systemName: "pawprint.fill")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.neonPurple)
        }
        .rotationEffect(.degrees(rotationAngle))
    }
}

struct WheelSliceView: View {
    let activity: PetActivity
    let index: Int
    let total: Int
    let sliceDegrees: Double

    private var startAngle: Angle { .degrees(sliceDegrees * Double(index) - 90) }
    private var endAngle: Angle { .degrees(sliceDegrees * Double(index + 1) - 90) }
    private var midAngle: Angle { .degrees(sliceDegrees * Double(index) + sliceDegrees / 2 - 90) }

    private var sliceColor: Color {
        Color.wheelColors[index % Color.wheelColors.count]
    }

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2

            ZStack {
                Path { path in
                    path.move(to: center)
                    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    path.closeSubpath()
                }
                .fill(sliceColor)

                Path { path in
                    path.move(to: center)
                    path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
                    path.closeSubpath()
                }
                .stroke(Color.black.opacity(0.25), lineWidth: 1.5)

                let labelRadius = radius * 0.65
                let labelX = center.x + labelRadius * cos(midAngle.radians)
                let labelY = center.y + labelRadius * sin(midAngle.radians)

                Text(activity.emoji)
                    .font(total <= 8 ? .title2 : .body)
                    .rotationEffect(.degrees(sliceDegrees * Double(index) + sliceDegrees / 2))
                    .position(x: labelX, y: labelY)
            }
        }
    }
}

struct WheelPointerView: View {
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(.white)
                .shadow(color: Color.neonPurple.opacity(0.9), radius: 8)
            Spacer()
        }
    }
}
