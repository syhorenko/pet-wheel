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
                        .fill(Color.accentColor.opacity(0.15))
                        .frame(width: 60, height: 60)
                    Text(pet.type.emoji)
                        .font(.system(size: 30))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(pet.name)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    HStack(spacing: 6) {
                        Text(pet.type.displayName)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let age = pet.age {
                            Text("•")
                                .foregroundStyle(.secondary)
                                .font(.caption)
                            Text(age)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    if let last = pet.activityHistory.first {
                        Text("Last: \(last.emoji) \(last.name)")
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer()

                Button {
                    onSpinWheel()
                } label: {
                    Image(systemName: "arrow.triangle.2.circlepath.circle.fill")
                        .font(.title2)
                        .foregroundStyle(Color.accentColor)
                }
                .buttonStyle(.plain)

                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .padding(16)
        }
        .buttonStyle(.plain)
        .cardStyle()
    }
}
