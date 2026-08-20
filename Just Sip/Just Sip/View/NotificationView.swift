import SwiftUI

struct NotificationView: View {

    @AppStorage("remindersEnabled")
    private var remindersEnabled = true

    @AppStorage("reminderInterval")
    private var reminderInterval = 2

    var body: some View {

        NavigationStack {

            Form {

                Section {
                    Toggle(
                        "Water Reminders",
                        isOn: $remindersEnabled
                    )
                } header: {
                    Text("Reminders")
                }

                if remindersEnabled {

                    Section {

                        Picker(
                            "Remind Me Every",
                            selection: $reminderInterval
                        ) {
                            Text("30 mins")
                                .tag(30)

                            Text("1 hour")
                                .tag(60)

                            Text("2 hours")
                                .tag(120)

                            Text("3 hours")
                                .tag(180)

                            Text("4 hours")
                                .tag(240)
                        }

                    } header: {
                        Text("Reminder Interval")
                    }
                }

                Section {

                    Button {
                        NotificationManager.shared
                            .scheduleTestNotification()

                    } label: {
                        Label(
                            "Test Notification",
                            systemImage: "bell.badge"
                        )
                    }

                } footer: {
                    Text(
                        "A test notification will appear shortly."
                    )
                }
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    NotificationView()
}
