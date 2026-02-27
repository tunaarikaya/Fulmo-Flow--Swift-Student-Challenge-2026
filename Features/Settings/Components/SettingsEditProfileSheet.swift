import SwiftUI
import PhotosUI

struct SettingsEditProfileSheet: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var draftName      = ""
    @State private var draftStatus    = ""
    @State private var draftAge       = 0
    @State private var draftBloodType = ""
    @State private var draftOxygen    = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var draftImageData: Data? = nil

    var body: some View {
        NavigationStack {
            Form {
                Section("Identity") {
                    // Profile Photo Selection
                    HStack {
                        Spacer()
                        VStack(spacing: 12) {
                            ZStack {
                                if let data = draftImageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                } else {
                                    Circle()
                                        .fill(Color.teal.opacity(0.12))
                                        .frame(width: 100, height: 100)
                                    Image(systemName: "person.crop.circle.fill")
                                        .resizable()
                                        .frame(width: 90, height: 90)
                                        .foregroundStyle(.teal)
                                }

                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    Image(systemName: "camera.fill")
                                        .font(.system(.footnote))
                                        .foregroundColor(.white)
                                        .frame(width: 32, height: 32)
                                        .background(Color.teal)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                                }
                                .offset(x: 34, y: 34)
                            }

                            Text("Change Photo")
                                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                .foregroundColor(.teal)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .listRowBackground(Color.clear)

                    LabeledContent("Full Name") {
                        TextField("Full Name", text: $draftName)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                    }
                    LabeledContent("Health Status") {
                        TextField("e.g. IPF Warrior", text: $draftStatus)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                    }
                }

                Section("Medical Data") {
                    Picker("Age", selection: $draftAge) {
                        ForEach(viewModel.ages, id: \.self) { age in
                            Text("\(age)").tag(age)
                        }
                    }
                    .pickerStyle(.menu)

                    Picker("Blood Type", selection: $draftBloodType) {
                        ForEach(viewModel.bloodTypes, id: \.self) { Text($0).tag($0) }
                    }
                    LabeledContent("Oxygen Level") {
                        TextField("e.g. 96%", text: $draftOxygen)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { commitAndDismiss() }
                        .fontWeight(.semibold)
                        .disabled(draftName.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
        .presentationSizing(.form)
        .presentationDragIndicator(.visible)
        .onAppear {
            draftName      = viewModel.profile.name
            draftStatus    = viewModel.profile.status
            draftAge       = viewModel.profile.age
            draftBloodType = viewModel.profile.bloodType
            draftOxygen    = viewModel.profile.oxygenLevel
            draftImageData = viewModel.profileImageData
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    draftImageData = data
                }
            }
        }
    }

    private func commitAndDismiss() {
        viewModel.profile = ProfileModel(
            name:        draftName.trimmingCharacters(in: .whitespaces),
            status:      draftStatus.trimmingCharacters(in: .whitespaces),
            age:         draftAge,
            bloodType:   draftBloodType,
            oxygenLevel: draftOxygen.trimmingCharacters(in: .whitespaces)
        )
        viewModel.saveProfileImage(draftImageData)
        dismiss()
    }
}
