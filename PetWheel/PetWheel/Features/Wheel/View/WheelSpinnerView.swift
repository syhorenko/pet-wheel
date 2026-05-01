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

            // Center hub
            Circle()
                .fill(Color(.systemBackground))
                .frame(width: 48, height: 48)
                .shadow(radius: 4)

            Image(systemName: "pawprint.fill")
                .foregroundStyle(Color.accentColor)
                .font(.title3)
        }
        .rotationEffect(.degrees(rotationAngle))
    }
}

struct WheelSliceView: View {
    let activity: PetActivity
    let index: Int
    let total: Int
    let sliceDegrees: Double

    private var startAngle: Angle {
        .degrees(sliceDegrees * Double(index) - 90)
    }

    private var endAngle: Angle {
        .degrees(sliceDegrees * Double(index + 1) - 90)
    }

    private var midAngle: Angle {
        .degrees(sliceDegrees * Double(index) + sliceDegrees / 2 - 90)
    }

    private var sliceColor: Color {
        Color.wheelColors[index % Color.wheelColors.count].opacity(0.85)
    }

    var body: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2

            ZStack {
                Path { path in
                    path.move(to: center)
                    path.addArc(
                        center: center,
                        radius: radius,
                        startAngle: startAngle,
                        endAngle: endAngle,
                        clockwise: false
                    )
                    path.closeSubpath()
                }
                .fill(sliceColor)

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
                .font(.system(size: 28))
                .foregroundStyle(Color.primary)
                .shadow(radius: 2)
            Spacer()
        }
    }
}
