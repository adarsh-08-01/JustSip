import SwiftUI
import SwiftData

struct SettingsView: View {

    @State private var showResetAlert = false

    @Binding var dailyGoal: Int
    @Binding var waterConsumed: Int

    @Environment(\.modelContext)
    private var modelContext

    @AppStorage("remindersEnabled")
    private var remindersEnabled = true

    @AppStorage("reminderInterval")
    private var reminderInterval = 30

    // MARK: - Reset Today's Water

    private func resetTodayWater() {

        let calendar = Calendar.current

        let startOfToday =
            calendar.startOfDay(for: Date())

        guard let tomorrow =
                calendar.date(
                    byAdding: .day,
                    value: 1,
                    to: startOfToday
                )
        else {
            return
        }

        let descriptor =
            FetchDescriptor<WaterEntry>(
                predicate: #Predicate { entry in
                    entry.date >= startOfToday &&
                    entry.date < tomorrow
                }
            )

        do {

            let todayEntries =
                try modelContext.fetch(descriptor)

            for entry in todayEntries {
                modelContext.delete(entry)
            }

            try modelContext.save()

            waterConsumed = 0

            print("✅ Today's water reset")

        } catch {

            print(
                "❌ Failed to reset today's water: \(error)"
            )
        }
    }

    // MARK: - Body

    var body: some View {

        NavigationStack {

            Form {

                // MARK: - Water Goal

                Section {

                    Picker(
                        "Daily Goal",
                        selection: $dailyGoal
                    ) {

                        ForEach(
                            Array(
                                stride(
                                    from: 1500,
                                    through: 6000,
                                    by: 250
                                )
                            ),
                            id: \.self
                        ) { amount in

                            Text("\(amount) ml")
                                .tag(amount)
                        }
                    }

                } header: {

                    Text("Water Goal")

                } footer: {

                    Text(
                        "Set how much water you want to drink each day."
                    )
                }

//                // MARK: - Reminders
//
//                Section {
//
//                    Toggle(
//                        "Water Reminders",
//                        isOn: $remindersEnabled
//                    )
//                    .onChange(of: remindersEnabled) { _, enabled in
//
//                        if enabled {
//
//                            Task {
//
//                                let granted =
//                                    await NotificationManager
//                                    .shared
//                                    .requestPermission()
//
//                                if granted {
//
//                                    NotificationManager
//                                        .shared
//                                        .scheduleWaterReminder(
//                                            intervalMinutes:
//                                                reminderInterval
//                                        )
//                                }
//
//                            }
//
//                        } else {
//
//                            NotificationManager
//                                .shared
//                                .cancelReminders()
//                        }
//                    }
//
//                    if remindersEnabled {
//
//                        Picker(
//                            "Remind Me Every",
//                            selection: $reminderInterval
//                        ) {
//
//                            Text("30 mins")
//                                .tag(30)
//
//                            Text("1 hour")
//                                .tag(60)
//
//                            Text("2 hours")
//                                .tag(120)
//
//                            Text("3 hours")
//                                .tag(180)
//
//                            Text("4 hours")
//                                .tag(240)
//                        }
//                        .onChange(
//                            of: reminderInterval
//                        ) { _, newValue in
//
//                            if remindersEnabled {
//
//                                NotificationManager
//                                    .shared
//                                    .scheduleWaterReminder(
//                                        intervalMinutes:
//                                            newValue
//                                    )
//                            }
//                        }
//                    }
//
//                    // MARK: - Test Notification
//
//                    Button {
//
//                        NotificationManager
//                            .shared
//                            .scheduleTestNotification()
//
//                    } label: {
//
//                        Label(
//                            "Test Notification (10 sec)",
//                            systemImage: "bell.badge"
//                        )
//                    }
//
//                } header: {
//
//                    Text("Reminders")
//
//                } footer: {
//
//                    Text(
//                        "JustSip can remind you to drink water throughout the day."
//                    )
//                }

                // MARK: - Data

                Section("Data") {

                    Button(role: .destructive) {

                        showResetAlert = true

                    } label: {

                        Label(
                            "Reset Today's Water",
                            systemImage:
                                "arrow.counterclockwise"
                        )
                    }
                }
                .alert(
                    "Reset Today's Water?",
                    isPresented: $showResetAlert
                ) {

                    Button(
                        "Cancel",
                        role: .cancel
                    ) {
                    }

                    Button(
                        "Reset",
                        role: .destructive
                    ) {

                        resetTodayWater()
                    }

                } message: {

                    Text(
                        "This will remove all water entries recorded today. This action cannot be undone."
                    )
                }

                // MARK: - About

                Section("About") {

                    HStack {

                        Text("App")

                        Spacer()

                        Text("JustSip")
                            .foregroundStyle(.secondary)
                    }

                    HStack {

                        Text("Version")

                        Spacer()

                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {

    SettingsView(
        dailyGoal: .constant(3000),
        waterConsumed: .constant(2000)
    )
}
