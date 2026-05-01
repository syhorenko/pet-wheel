import SwiftUI

struct AddPetView: View {
    @ObservedObject var viewModel: AddPetViewModel
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Pet Info") {
                    TextField("Name", text: $viewModel.name)

                    Picker("Type", selection: $viewModel.selectedType) {
                        ForEach(PetType.allCases) { type in
                            Label(type.displayName, title: { Text(type.displayName) })
                                .tag(type)
                        }
                    }
                }

                Section("Birthday (Optional)") {
                    Toggle("Add Birthday", isOn: $viewModel.hasBirthday)
                    if viewModel.hasBirthday {
                        DatePicker(
                            "Birthday",
                            selection: $viewModel.birthday,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                    }
                }

                Section("Notes (Optional)") {
                    TextEditor(text: $viewModel.notes)
                        .frame(minHeight: 80)
                }

                Section {
                    previewCard
                }
            }
            .navigationTitle("Add a Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onDismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.save()
                        onDismiss()
                    }
                    .disabled(!viewModel.canSave)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private var previewCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 48, height: 48)
                Text(viewModel.selectedType.emoji)
                    .font(.title2)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.name.isEmpty ? "Pet Name" : viewModel.name)
                    .font(.headline)
                    .foregroundStyle(viewModel.name.isEmpty ? .secondary : .primary)
                Text(viewModel.selectedType.displayName)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}
