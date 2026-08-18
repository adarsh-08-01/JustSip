import Foundation
import UserNotifications

final class NotificationManager {

    static let shared = NotificationManager()

    private init() {}

    // MARK: - Request Permission

    func requestPermission() async -> Bool {

        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(
                    options: [.alert, .sound, .badge]
                )

            return granted

        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    // MARK: - Schedule Reminder

    func scheduleWaterReminder(intervalMinutes: Int) {

        let center = UNUserNotificationCenter.current()

        // Remove previous water reminders
        center.removePendingNotificationRequests(
            withIdentifiers: ["waterReminder"]
        )

        let content = UNMutableNotificationContent()

        content.title = "Time for a sip 💧"
        content.body = "Stay hydrated and keep your JustSip goal on track."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(intervalMinutes * 60 * 60),
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "waterReminder",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in

            if let error = error {
                print("Failed to schedule reminder: \(error)")
            } else {
                print(
                    "Water reminder scheduled every \(intervalMinutes) hour(s)."
                )
            }
        }
    }

    // MARK: - Cancel Reminders

    func cancelWaterReminders() {

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: ["waterReminder"]
            )

        print("Water reminders cancelled.")
    }
}
