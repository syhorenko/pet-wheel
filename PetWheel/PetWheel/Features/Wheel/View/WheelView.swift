import SwiftUI

struct WheelView: View {
    @ObservedObject var viewModel: WheelViewModel
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                petHeader
                    .padding(.top, 8)

                Spacer()

                wheelSection

                Spacer()

                spinButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
            }
            .navigationTitle("Activity Wheel")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") { onDismiss() }
                }
            }
            .sheet(isPresented: $viewModel.showResult) {
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
                }
            }
        }
    }

    private var petHeader: some View {
        HStack(spacing: 12) {
            Text(viewModel.pet.type.emoji)
                .font(.largeTitle)
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.pet.name)
                    .font(.headline)
                Text("What activity today?")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
    }

    private var wheelSection: some View {
        ZStack(alignment: .top) {
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
            HStack {
                if viewModel.isSpinning {
                    ProgressView()
                        .tint(.white)
                        .padding(.trailing, 4)
                }
                Text(viewModel.isSpinning ? "Spinning..." : "Spin the Wheel!")
            }
            .primaryButtonStyle()
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
            VStack(spacing: 8) {
                Text(activity.emoji)
                    .font(.system(size: 72))
                Text(activity.name)
                    .font(.largeTitle.weight(.bold))
                Text("Time for \(pet.name) to \(activity.name.lowercased())!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 8)

            VStack(spacing: 12) {
                Button("Log Activity") {
                    onRecord()
                }
                .primaryButtonStyle()

                Button("Spin Again") {
                    onDismiss()
                }
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .padding(28)
        .frame(maxWidth: .infinity)
    }
}
