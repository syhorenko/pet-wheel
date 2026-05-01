import SwiftUI

struct WheelView: View {
    @ObservedObject var viewModel: WheelViewModel
    let onDismiss: () -> Void

    private var showResultBinding: Binding<Bool> {
        Binding(
            get: { viewModel.showResult },
            set: { if !$0 { viewModel.dismissResult() } }
        )
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()

                VStack(spacing: 0) {
                    petHeader
                        .padding(.top, 8)

                    Spacer()

                    wheelSection

                    Spacer()

                    spinButton
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                }
            }
            .navigationTitle("Activity Wheel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { onDismiss() }
                        .foregroundStyle(Color.neonPurple)
                }
            }
            .sheet(isPresented: showResultBinding) {
                if let activity = viewModel.selectedActivity {
                    ActivityResultView(
                        pet: viewModel.pet,
                        activity: activity,
                        onRecord: {
                            viewModel.recordActivity()
                            onDismiss()
                        },
                        onDismiss: viewModel.dismissResult
                    )
                    .presentationDetents([.medium])
                    .presentationBackground(Color.cardSurface)
                }
            }
        }
    }

    private var petHeader: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Color.neonPurple.opacity(0.12))
                    .frame(width: 48, height: 48)
                Circle()
                    .strokeBorder(Color.neonPurple.opacity(0.25), lineWidth: 1)
                    .frame(width: 48, height: 48)
                Text(viewModel.pet.type.emoji)
                    .font(.title2)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(viewModel.pet.name)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text("What activity today?")
                    .font(.caption)
                    .foregroundStyle(Color.mutedText)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }

    private var wheelSection: some View {
        ZStack(alignment: .top) {
            Circle()
                .strokeBorder(
                    LinearGradient(
                        colors: [Color.neonPurple.opacity(0.55), Color.neonPurple.opacity(0.10)],
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                )
                .frame(width: 318, height: 318)
                .shadow(color: Color.neonPurple.opacity(0.30), radius: 16)
                .padding(.top, 16)

            WheelSpinnerView(
                activities: viewModel.activities,
                rotationAngle: viewModel.rotationAngle
            )
            .frame(width: 300, height: 300)
            .padding(.top, 16)

            WheelPointerView()
                .frame(height: 340)
        }
    }

    private var spinButton: some View {
        Button {
            viewModel.spin()
        } label: {
            HStack(spacing: 10) {
                if viewModel.isSpinning {
                    ProgressView()
                        .tint(.white)
                        .scaleEffect(0.85)
                }
                Text(viewModel.isSpinning ? "Spinning..." : "Spin the Wheel!")
                    .font(.headline.weight(.semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                viewModel.isSpinning
                    ? LinearGradient(
                        colors: [Color.neonPurple.opacity(0.45), Color.neonPurpleLight.opacity(0.35)],
                        startPoint: .leading, endPoint: .trailing)
                    : LinearGradient(
                        colors: [Color.neonPurple, Color.neonPurpleLight],
                        startPoint: .leading, endPoint: .trailing)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.neonPurple.opacity(viewModel.isSpinning ? 0.10 : 0.50), radius: 18, x: 0, y: 4)
        }
        .disabled(viewModel.isSpinning)
    }
}

struct ActivityResultView: View {
    let pet: Pet
    let activity: PetActivity
    let onRecord: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white.opacity(0.18))
                .frame(width: 36, height: 4)
                .padding(.top, 14)

            VStack(spacing: 14) {
                ZStack {
                    Circle()
                        .fill(Color.neonPurple.opacity(0.14))
                        .frame(width: 100, height: 100)
                    Circle()
                        .strokeBorder(Color.neonPurple.opacity(0.28), lineWidth: 1.5)
                        .frame(width: 100, height: 100)
                    Text(activity.emoji)
                        .font(.system(size: 50))
                }
                .shadow(color: Color.neonPurple.opacity(0.25), radius: 12)

                VStack(spacing: 6) {
                    Text(activity.name)
                        .font(.title.weight(.bold))
                        .foregroundStyle(.white)
                    Text("Time for \(pet.name) to \(activity.name.lowercased())!")
                        .font(.subheadline)
                        .foregroundStyle(Color.mutedText)
                        .multilineTextAlignment(.center)
                }
            }

            VStack(spacing: 12) {
                Button("Log Activity") {
                    onRecord()
                }
                .primaryButtonStyle()

                Button("Spin Again") {
                    onDismiss()
                }
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Color.mutedText)
                .padding(.bottom, 4)
            }
        }
        .padding(.horizontal, 28)
        .frame(maxWidth: .infinity)
    }
}
