import SwiftUI

struct PetDetailView: View {
    @ObservedObject var viewModel: PetDetailViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {
                    petHeader
                    if !viewModel.pet.notes.isEmpty || viewModel.isEditing {
                        notesSection
                    }
                    activityHistorySection
                }
                .padding(16)
            }
        }
        .navigationTitle(viewModel.pet.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar { toolbarContent }
        .sheet(isPresented: $viewModel.isEditing) {
            editSheet
        }
    }

    private var petHeader: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.neonPurple.opacity(0.12))
                    .frame(width: 110, height: 110)
                Circle()
                    .strokeBorder(Color.neonPurple.opacity(0.30), lineWidth: 1.5)
                    .frame(width: 110, height: 110)
                Text(viewModel.pet.type.emoji)
                    .font(.system(size: 56))
            }
            .shadow(color: Color.neonPurple.opacity(0.20), radius: 16)

            VStack(spacing: 4) {
                Text(viewModel.pet.type.displayName)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.mutedText)
                if let age = viewModel.pet.age {
                    Text(age + " old")
                        .font(.caption)
                        .foregroundStyle(Color.mutedText.opacity(0.7))
                }
            }

            Button {
                appCoordinator.showWheel(for: viewModel.pet)
            } label: {
                Label("Spin the Wheel", systemImage: "arrow.triangle.2.circlepath")
                    .primaryButtonStyle()
            }
        }
        .padding(24)
        .cardStyle()
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("Notes", systemImage: "note.text")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.mutedText)
            Text(viewModel.pet.notes.isEmpty ? "No notes yet." : viewModel.pet.notes)
                .font(.body)
                .foregroundStyle(viewModel.pet.notes.isEmpty ? Color.mutedText.opacity(0.5) : .white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardStyle()
    }

    private var activityHistorySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Activity History", systemImage: "clock.arrow.circlepath")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.mutedText)

            if viewModel.recentActivities.isEmpty {
                VStack(spacing: 8) {
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundStyle(Color.neonPurple.opacity(0.5))
                    Text("No activities yet. Spin the wheel!")
                        .font(.subheadline)
                        .foregroundStyle(Color.mutedText)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
            } else {
                ForEach(viewModel.recentActivities) { activity in
                    ActivityRowView(activity: activity)
                    if activity.id != viewModel.recentActivities.last?.id {
                        Divider()
                            .background(Color.cardBorder)
                    }
                }
            }
        }
        .padding(16)
        .cardStyle()
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing) {
            Menu {
                Button("Edit", systemImage: "pencil") { viewModel.startEditing() }
                Divider()
                Button("Delete", systemImage: "trash", role: .destructive) {
                    viewModel.delete()
                    dismiss()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .foregroundStyle(Color.neonPurple)
            }
        }
    }

    private var editSheet: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                Form {
                    Section {
                        TextField("Name", text: $viewModel.editedName)
                            .foregroundStyle(.white)
                    } header: {
                        Text("Pet Name")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.mutedText)
                            .textCase(nil)
                    }
                    .listRowBackground(Color.cardSurface)
                    .listRowSeparatorTint(Color.white.opacity(0.08))

                    Section {
                        TextEditor(text: $viewModel.editedNotes)
                            .frame(minHeight: 100)
                            .foregroundStyle(.white)
                            .scrollContentBackground(.hidden)
                    } header: {
                        Text("Notes")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(Color.mutedText)
                            .textCase(nil)
                    }
                    .listRowBackground(Color.cardSurface)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Edit \(viewModel.pet.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.cancelEditing() }
                        .foregroundStyle(Color.mutedText)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { viewModel.saveEdits() }
                        .disabled(viewModel.editedName.trimmingCharacters(in: .whitespaces).isEmpty)
                        .foregroundStyle(Color.neonPurple)
                        .fontWeight(.semibold)
                }
            }
        }
    }
}

struct ActivityRowView: View {
    let activity: PetActivity

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.cardSurface2)
                    .frame(width: 36, height: 36)
                Text(activity.emoji)
                    .font(.body)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.name)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white)
                Text(activity.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(Color.mutedText)
            }
        }
    }
}
