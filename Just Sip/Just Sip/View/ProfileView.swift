import SwiftUI
import PhotosUI

struct ProfileView: View {

    // MARK: - Profile Data

    @AppStorage("userName")
    private var userName = ""

    @AppStorage("profileImageData")
    private var profileImageData = ""

    // MARK: - Water Data

    @Binding var dailyGoal: Int
    @Binding var waterConsumed: Int

    // MARK: - UI State

    @State private var selectedPhoto: PhotosPickerItem?
    @State private var editedName = ""

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(spacing: 24) {

                    // MARK: - Profile Photo

                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {

                        ZStack(alignment: .bottomTrailing) {

                            if let image = profileImage {

                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(
                                        width: 120,
                                        height: 120
                                    )
                                    .clipShape(Circle())

                            } else {

                                Circle()
                                    .fill(
                                        Color.indigo.opacity(0.12)
                                    )
                                    .frame(
                                        width: 120,
                                        height: 120
                                    )

                                Image(systemName: "person.fill")
                                    .font(
                                        .system(size: 50)
                                    )
                                    .foregroundStyle(.indigo)
                            }

                            Circle()
                                .fill(.indigo)
                                .frame(
                                    width: 38,
                                    height: 38
                                )
                                .overlay {

                                    Image(systemName: "camera.fill")
                                        .font(.system(size: 15))
                                        .foregroundStyle(.white)
                                }
                        }
                    }
                    .buttonStyle(.plain)

                    Text("Tap photo to change")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    // MARK: - Name

                    VStack(alignment: .leading, spacing: 8) {

                        Text("Your Name")
                            .font(.headline)

                        TextField(
                            "Enter your name",
                            text: $editedName
                        )
                        .textFieldStyle(.roundedBorder)
                    }
                    .padding(.horizontal, 25)

                    // MARK: - Save

                    Button {

                        userName = editedName
                            .trimmingCharacters(
                                in: .whitespacesAndNewlines
                            )

                    } label: {

                        Text("Save Profile")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(
                                maxWidth: .infinity
                            )
                            .frame(height: 52)
                            .background(.indigo)
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 16
                                )
                            )
                    }
                    .padding(.horizontal, 25)

                    // MARK: - Today's Hydration

                    VStack(alignment: .leading, spacing: 14) {

                        Text("Today's Hydration")
                            .font(.headline)

                        HStack(spacing: 12) {

                            ProfileStatCard(
                                title: "Consumed",
                                value: "\(waterConsumed) ml",
                                icon: "drop.fill"
                            )

                            ProfileStatCard(
                                title: "Daily Goal",
                                value: "\(dailyGoal) ml",
                                icon: "target"
                            )
                        }
                    }
                    .padding(.horizontal, 25)
                }
                .padding(.top, 25)
                .padding(.bottom, 30)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)

            // MARK: - Load Existing Name

            .onAppear {
                editedName = userName
            }

            // MARK: - Load Selected Photo

            .onChange(of: selectedPhoto) { _, newPhoto in

                guard let newPhoto else {
                    return
                }

                Task {

                    do {

                        if let data = try await newPhoto
                            .loadTransferable(type: Data.self) {

                            await MainActor.run {

                                profileImageData =
                                    data.base64EncodedString()
                            }
                        }

                    } catch {

                        print(
                            "Failed to load profile photo: \(error)"
                        )
                    }
                }
            }
        }
    }

    // MARK: - Stored Profile Image

    private var profileImage: UIImage? {

        guard !profileImageData.isEmpty else {
            return nil
        }

        guard let data = Data(
            base64Encoded: profileImageData
        ) else {
            return nil
        }

        return UIImage(data: data)
    }
}

// MARK: - Profile Stat Card

struct ProfileStatCard: View {

    let title: String
    let value: String
    let icon: String

    var body: some View {

        VStack(spacing: 8) {

            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundStyle(.indigo)

            Text(value)
                .font(.headline)

            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(
            maxWidth: .infinity
        )
        .padding(.vertical, 18)
        .background(
            Color.indigo.opacity(0.08)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 18
            )
        )
    }
}

#Preview {

    ProfileView(
        dailyGoal: .constant(5000),
        waterConsumed: .constant(2500)
    )
}
