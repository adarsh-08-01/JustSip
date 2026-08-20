import Foundation
import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {

    static let shared = NotificationManager()

    private override init() {
        super.init()

        UNUserNotificationCenter.current().delegate = self
    }

    // MARK: - Permission

    func requestPermission() async -> Bool {
        do {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(
                    options: [.alert, .sound, .badge]
                )

            print("Notification permission: \(granted)")

            return granted

        } catch {
            print("Notification permission error: \(error)")
            return false
        }
    }

    // MARK: - Water Reminder

    func scheduleWaterReminder(intervalMinutes: Int) {

        let center = UNUserNotificationCenter.current()

        // Remove previous reminder
        center.removePendingNotificationRequests(
            withIdentifiers: ["waterReminder"]
        )

        let content = UNMutableNotificationContent()

        content.title = "Time for a sip 💧"
        content.body = "Stay hydrated and keep your JustSip goal on track."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(intervalMinutes * 60),
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: "waterReminder",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in

            if let error {
                print("❌ Reminder error: \(error)")
            } else {
                print(
                    "✅ Reminder scheduled every \(intervalMinutes) minutes"
                )
            }
        }
    }

    // MARK: - Cancel Reminder

    func cancelReminders() {

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: ["waterReminder"]
            )

        print("✅ Water reminders cancelled")
    }

    // MARK: - Test Notification

    func scheduleTestNotification() {

        let content = UNMutableNotificationContent()

        content.title = "JustSip 💧"
        content.body = "Time to drink some water!"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "testNotification",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in

            if let error {
                print("❌ Test notification error: \(error)")
            } else {
                print("✅ Test notification scheduled for 10 seconds")
            }
        }
    }

    // MARK: - Show Notification While App Is Open

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification
    ) async -> UNNotificationPresentationOptions {

        [.banner, .sound]
    }
}
