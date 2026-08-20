import SwiftUI
import SwiftData

struct HomeView: View {

    // MARK: - View Model

    @State private var viewModel = WaterViewModel()
   
    //MARK: - Profile Image
    @AppStorage("profileImageData")
    private var profileImageData = ""
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
    }    // MARK: - SwiftData

    @Environment(\.modelContext)
    private var modelContext

    @Query(sort: \WaterEntry.date, order: .reverse)
    private var entries: [WaterEntry]

    // MARK: - Sheets

    @State private var showQuickAdd = false
    @State private var showHistory = false
    @State private var showSettings = false
    @State private var showProfile = false
    @State private var showNotifications = false

    var body: some View {

        VStack(spacing: 0) {

            // MARK: - Top Bar

            HStack {

                Button {

                    showProfile = true

                } label: {

                    Group {

                        if let profileImage {

                            Image(uiImage: profileImage)
                                .resizable()
                                .scaledToFill()

                        } else {

                            Image(systemName: "person")
                                .font(
                                    .system(
                                        size: 18,
                                        weight: .medium
                                    )
                                )
                                .foregroundStyle(.indigo)
                        }
                    }
                    .frame(
                        width: 44,
                        height: 44
                    )
                    .background(
                        Color.indigo.opacity(0.08)
                    )
                    .clipShape(Circle())
                    .overlay {

                        Circle()
                            .stroke(
                                Color.indigo.opacity(0.15),
                                lineWidth: 1
                            )
                    }
                }

                Spacer()

                Button {
                    showNotifications = true
                } label: {
                    Image(systemName: "bell")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.indigo)
                        .frame(width: 48, height: 48)
                        .background(Color(.systemBackground))
                        .clipShape(Circle())
                        .shadow(
                            color: .black.opacity(0.08),
                            radius: 8,
                            y: 3
                        )
                }
            }
            .padding(.horizontal, 20)
                .padding(.top, 25)
                .padding(.bottom, 8)
            // MARK: - Water Amount

            VStack(spacing: 6) {

                Text("\(viewModel.waterConsumed.formatted()) ml")
                    .font(
                        .system(
                            size: 46,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.indigo)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                Text(
                    "of \(viewModel.dailyGoal.formatted()) ml Goal"
                )
                .font(
                    .system(
                        size: 17,
                        weight: .medium
                    )
                )
                .foregroundStyle(.secondary)
            }
            .frame(height: 105)

            // MARK: - Bottle

            WaterBottleView(
                waterProgress: CGFloat(
                    min(
                        max(viewModel.progress, 0),
                        1
                    )
                )
            )
            .frame(
                width: 260,
                height: 420
            )
            .padding(.horizontal, 30)
            .padding(.top, 50)
            .padding(.bottom, 15)
            
            // MARK: - Add Button

            Button {

                showQuickAdd = true

            } label: {

                Image(systemName: "plus")
                    .font(
                        .system(
                            size: 30,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(.indigo)
                    .frame(
                        width: 72,
                        height: 72
                    )
                    .background(
                        Color(.systemBackground)
                    )
                    .clipShape(Circle())
                    .shadow(
                        color: .black.opacity(0.12),
                        radius: 10,
                        y: 5
                    )
            }
            .frame(height: 82)

            // MARK: - Bottom Navigation

            HStack {

                Button {

                    showHistory = true

                } label: {

                    VStack(spacing: 6) {

                        Image(systemName: "chart.bar")
                            .font(.system(size: 21))

                        Text("History")
                            .font(.caption)
                    }
                    .foregroundStyle(.indigo)
                }

                Spacer()

                Button {

                    showSettings = true

                } label: {

                    VStack(spacing: 4) {

                        Image(systemName: "gearshape")
                            .font(.system(size: 21))

                        Text("Settings")
                            .font(.caption)
                    }
                    .foregroundStyle(.indigo)
                }
            }
            .padding(.horizontal, 30)
            .frame(height: 75)
        }
        .frame(maxWidth: .infinity)
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
        )

        // MARK: - Quick Add

        .sheet(isPresented: $showQuickAdd) {

            QuickAddView { amount in

                withAnimation(.easeInOut(duration: 0.8)) {

                    viewModel.addWater(
                        amount,
                        context: modelContext
                    )
                }
            }
            .presentationDetents(
                [.height(330)]
            )
            .presentationDragIndicator(
                .visible
            )
        }

        // MARK: - History

        .sheet(isPresented: $showHistory) {

            HistoryView()
        }

        // MARK: - Profile
        .sheet(isPresented: $showProfile) {

            ProfileView(
                dailyGoal: $viewModel.dailyGoal,
                waterConsumed: $viewModel.waterConsumed
            )
        }
        // MARK: - Settings

        .sheet(isPresented: $showSettings) {

            SettingsView(
                dailyGoal: $viewModel.dailyGoal,
                waterConsumed: $viewModel.waterConsumed
            )
        }
        
        //MARK: - Notification
        .sheet(isPresented: $showNotifications) {
            NotificationView()
        }

        // MARK: - Load Data

        .task {

            viewModel.loadTodayWater(
                context: modelContext
            )
        }

        .onAppear {

            viewModel.loadToday(
                from: entries
            )
        }
    }

    // MARK: - Bottom Button

    private func bottomButton(
        icon: String,
        title: String
    ) -> some View {

        Button {

            print("\(title) tapped")

        } label: {

            VStack(spacing: 4) {

                Image(systemName: icon)
                    .font(.system(size: 21))

                Text(title)
                    .font(.caption)
            }
            .foregroundStyle(.indigo)
        }
    }
}

#Preview {

    HomeView()
        .modelContainer(
            for: WaterEntry.self,
            inMemory: true
        )
}
