import SwiftUI

struct PetCardView: View {
    let pet: Pet
    let onTap: () -> Void
    let onSpinWheel: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color.neonPurple.opacity(0.15))
                        .frame(width: 60, height: 60)
                    Circle()
                        .strokeBorder(Color.neonPurple.opacity(0.30), lineWidth: 1)
                        .frame(width: 60, height: 60)
                    Text(pet.type.emoji)
                        .font(.system(size: 30))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(pet.name)
                        .font(.headline)
                        .foregroundStyle(.white)
                    HStack(spacing: 6) {
                        Text(pet.type.displayName)
                            .font(.caption)
                            .foregroundStyle(Color.mutedText)
                        if let age = pet.age {
                            Text("•")
                                .font(.caption)
                                .foregroundStyle(Color.mutedText)
                            Text(age)
                                .font(.caption)
                                .foregroundStyle(Color.mutedText)
                        }
                    }
                    if let last = pet.activityHistory.first {
                        Text("Last: \(last.emoji) \(last.name)")
                            .font(.caption2)
                            .foregroundStyle(Color.mutedText.opacity(0.6))
                    }
                }

                Spacer()

                Button {
                    onSpinWheel()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.neonPurple)
                }
                .buttonStyle(.plain)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(Color.white.opacity(0.20))
            }
            .padding(16)
        }
        .buttonStyle(.plain)
        .cardStyle()
    }
}
