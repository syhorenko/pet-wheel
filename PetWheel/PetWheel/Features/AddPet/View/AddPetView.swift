import SwiftUI

struct AddPetView: View {
    @ObservedObject var viewModel: AddPetViewModel
    let onDismiss: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                Form {
                    Section {
                        TextField("Name", text: $viewModel.name)
                            .foregroundStyle(.white)
                        typePicker
                    } header: {
                        formHeader("Pet Info")
                    }
                    .listRowBackground(Color.cardSurface)
                    .listRowSeparatorTint(Color.white.opacity(0.08))

                    Section {
                        Toggle("Add Birthday", isOn: $viewModel.hasBirthday)
                            .tint(Color.neonPurple)
                            .foregroundStyle(.white)
                        if viewModel.hasBirthday {
                            DatePicker(
                                "Birthday",
                                selection: $viewModel.birthday,
                                in: ...Date(),
                                displayedComponents: .date
                            )
                            .foregroundStyle(.white)
                        }
                    } header: {
                        formHeader("Birthday (Optional)")
                    }
                    .listRowBackground(Color.cardSurface)
                    .listRowSeparatorTint(Color.white.opacity(0.08))

                    Section {
                        TextEditor(text: $viewModel.notes)
                            .frame(minHeight: 80)
                            .foregroundStyle(.white)
                            .scrollContentBackground(.hidden)
                    } header: {
                        formHeader("Notes (Optional)")
                    }
                    .listRowBackground(Color.cardSurface)

                    Section {
                        previewCard
                    } header: {
                        formHeader("Preview")
                    }
                    .listRowBackground(Color.cardSurface2)
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Add a Pet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { onDismiss() }
                        .foregroundStyle(Color.mutedText)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.save()
                        onDismiss()
                    }
                    .disabled(!viewModel.canSave)
                    .foregroundStyle(viewModel.canSave ? Color.neonPurple : Color.mutedText)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func formHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption.weight(.semibold))
            .foregroundStyle(Color.mutedText)
            .textCase(nil)
    }

    private var typePicker: some View {
        Picker("Type", selection: $viewModel.selectedType) {
            ForEach(PetType.allCases) { type in
                Text("\(type.emoji) \(type.displayName)").tag(type)
            }
        }
        .foregroundStyle(.white)
        .tint(Color.neonPurple)
    }

    private var previewCard: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.neonPurple.opacity(0.15))
                    .frame(width: 48, height: 48)
                Circle()
                    .strokeBorder(Color.neonPurple.opacity(0.30), lineWidth: 1)
                    .frame(width: 48, height: 48)
                Text(viewModel.selectedType.emoji)
                    .font(.title2)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.name.isEmpty ? "Pet Name" : viewModel.name)
                    .font(.headline)
                    .foregroundStyle(viewModel.name.isEmpty ? Color.mutedText : .white)
                Text(viewModel.selectedType.displayName)
                    .font(.caption)
                    .foregroundStyle(Color.mutedText)
            }
        }
        .padding(.vertical, 4)
    }
}
