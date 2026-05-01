import SwiftUI

struct PetDetailView: View {
    @ObservedObject var viewModel: PetDetailViewModel
    @EnvironmentObject var appCoordinator: AppCoordinator
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                petHeader
                if !viewModel.pet.notes.isEmpty || viewModel.isEditing {
                    notesSection
                }
                activityHistorySection
            }
            .padding(16)
        }
        .navigationTitle(viewModel.pet.name)
        .navigationBarTitleDisplayMode(.large)
        .toolbar { toolbarContent }
        .sheet(isPresented: $viewModel.isEditing) {
            editSheet
        }
    }

    private var petHeader: some View {
        VStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 100, height: 100)
                Text(viewModel.pet.type.emoji)
                    .font(.system(size: 54))
            }

            VStack(spacing: 4) {
                Text(viewModel.pet.type.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let age = viewModel.pet.age {
                    Text(age + " old")
                        .font(.caption)
                        .foregroundStyle(.tertiary)
                }
            }

            Button {
                appCoordinator.showWheel(for: viewModel.pet)
            } label: {
                Label("Spin the Wheel", systemImage: "arrow.triangle.2.circlepath")
                    .primaryButtonStyle()
            }
        }
        .padding(20)
        .cardStyle()
    }

    private var notesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Notes", systemImage: "note.text")
                .font(.headline)
            Text(viewModel.pet.notes.isEmpty ? "No notes yet." : viewModel.pet.notes)
                .font(.body)
                .foregroundStyle(viewModel.pet.notes.isEmpty ? .tertiary : .primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .cardStyle()
    }

    private var activityHistorySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Activity History", systemImage: "clock.arrow.circlepath")
                .font(.headline)
                .padding(.bottom, 4)

            if viewModel.recentActivities.isEmpty {
                Text("No activities yet. Spin the wheel!")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            } else {
                ForEach(viewModel.recentActivities) { activity in
                    ActivityRowView(activity: activity)
                    if activity.id != viewModel.recentActivities.last?.id {
                        Divider()
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
            }
        }
    }

    private var editSheet: some View {
        NavigationStack {
            Form {
                Section("Pet Name") {
                    TextField("Name", text: $viewModel.editedName)
                }
                Section("Notes") {
                    TextEditor(text: $viewModel.editedNotes)
                        .frame(minHeight: 100)
                }
            }
            .navigationTitle("Edit \(viewModel.pet.name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.cancelEditing() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { viewModel.saveEdits() }
                        .disabled(viewModel.editedName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
}

struct ActivityRowView: View {
    let activity: PetActivity

    var body: some View {
        HStack(spacing: 12) {
            Text(activity.emoji)
                .font(.title3)
            VStack(alignment: .leading, spacing: 2) {
                Text(activity.name)
                    .font(.subheadline.weight(.medium))
                Text(activity.date.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
