import SwiftUI
import SwiftData

struct HistoryView: View {

    // MARK: - SwiftData

    @Query(
        sort: \WaterEntry.date,
        order: .reverse
    )
    private var entries: [WaterEntry]

    // MARK: - Settings

    @AppStorage("dailyGoal")
    private var dailyGoal: Int = 5000

    // MARK: - Body

    var body: some View {

        NavigationStack {

            ScrollView {

                VStack(
                    alignment: .leading,
                    spacing: 24
                ) {

                    // MARK: - Weekly Summary

                    weeklySummaryCard

                    // MARK: - Goal Status

                    goalStatusCard

                    // MARK: - Daily Activity

                    dailyActivityCard

                    // MARK: - Today's Entries

                    todayEntriesSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .padding(.bottom, 30)
            }
            .background(
                Color(.systemGroupedBackground)
                    .ignoresSafeArea()
            )
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
        }
    }

    // MARK: - Weekly Summary Card

    private var weeklySummaryCard: some View {

        VStack(
            alignment: .leading,
            spacing: 18
        ) {

            Text("Weekly Overview")
                .font(.headline)

            HStack(
                alignment: .firstTextBaseline
            ) {

                Text("\(weekTotal) ml")
                    .font(
                        .system(
                            size: 36,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.indigo)

                Spacer()

                VStack(
                    alignment: .trailing,
                    spacing: 3
                ) {

                    Text("Daily Average")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text("\(dailyAverage) ml")
                        .font(
                            .system(
                                size: 17,
                                weight: .semibold
                            )
                        )
                }
            }

            // MARK: - Weekly Chart

            HStack(
                alignment: .bottom,
                spacing: 12
            ) {

                ForEach(
                    weeklyDays,
                    id: \.self
                ) { date in

                    weeklyBar(
                        date: date
                    )
                }
            }
            .frame(height: 150)

            // MARK: - Chart Legend

            HStack {

                Text(
                    "\(completedDays) of 7 days completed"
                )
                .font(.caption)
                .foregroundStyle(.secondary)

                Spacer()

                Text(
                    "Goal: \(dailyGoal) ml"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
        }
        .padding(20)
        .background(
            Color(.secondarySystemGroupedBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }

    // MARK: - Weekly Bar

    private func weeklyBar(
        date: Date
    ) -> some View {

        let total = totalForDay(date)

        let progress = min(
            CGFloat(total) /
            CGFloat(max(dailyGoal, 1)),
            1
        )

        let isToday = Calendar.current.isDateInToday(date)

        return VStack(
            spacing: 7
        ) {

            Spacer(minLength: 0)

            GeometryReader { geometry in

                VStack {

                    Spacer()

                    RoundedRectangle(
                        cornerRadius: 6
                    )
                    .fill(
                        isToday
                        ? Color.indigo
                        : Color.indigo.opacity(0.35)
                    )
                    .frame(
                        height: max(
                            6,
                            geometry.size.height * progress
                        )
                    )
                }
            }
            .frame(height: 105)

            Text(
                date,
                format: .dateTime.weekday(
                    .narrow
                )
            )
            .font(
                .system(
                    size: 12,
                    weight: isToday
                    ? .bold
                    : .regular
                )
            )
            .foregroundStyle(
                isToday
                ? .indigo
                : .secondary
            )
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Goal Status Card

    private var goalStatusCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Goal Completion")
                .font(.headline)

            VStack(spacing: 14) {

                statusRow(
                    icon: "🎉",
                    title: "Completed",
                    count: completedDays,
                    description: "Reached your daily goal"
                )

                Divider()

                statusRow(
                    icon: "💧",
                    title: "In Progress",
                    count: inProgressDays,
                    description: "Started drinking today"
                )

                Divider()

                statusRow(
                    icon: "❌",
                    title: "Missed",
                    count: missedDays,
                    description: "No water recorded"
                )
            }
        }
        .padding(20)
        .background(
            Color(.secondarySystemGroupedBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }

    // MARK: - Status Row

    private func statusRow(
        icon: String,
        title: String,
        count: Int,
        description: String
    ) -> some View {

        HStack(spacing: 14) {

            Text(icon)
                .font(.title2)
                .frame(
                    width: 38,
                    height: 38
                )
                .background(
                    Color(.tertiarySystemGroupedBackground)
                )
                .clipShape(Circle())

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(title)
                    .font(
                        .system(
                            size: 16,
                            weight: .semibold
                        )
                    )

                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(count)")
                .font(
                    .system(
                        size: 22,
                        weight: .bold
                    )
                )
                .foregroundStyle(.indigo)
        }
    }

    // MARK: - Daily Activity Card

    private var dailyActivityCard: some View {

        VStack(
            alignment: .leading,
            spacing: 16
        ) {

            Text("Daily Activity")
                .font(.headline)

            ForEach(
                weeklyDays.reversed(),
                id: \.self
            ) { date in

                dailyActivityRow(
                    date: date
                )

                if date != weeklyDays.first {
                    Divider()
                }
            }
        }
        .padding(20)
        .background(
            Color(.secondarySystemGroupedBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }

    // MARK: - Daily Activity Row

    private func dailyActivityRow(
        date: Date
    ) -> some View {

        let total = totalForDay(date)

        let percentage = completionPercentage(
            total
        )

        return HStack(spacing: 14) {

            VStack(
                alignment: .leading,
                spacing: 3
            ) {

                Text(
                    date,
                    format: .dateTime.weekday(
                        .abbreviated
                    )
                )
                .font(
                    .system(
                        size: 15,
                        weight: .semibold
                    )
                )

                Text(
                    date,
                    format: .dateTime.month().day()
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }
            .frame(
                width: 60,
                alignment: .leading
            )

            VStack(
                alignment: .leading,
                spacing: 6
            ) {

                ProgressView(
                    value: min(
                        Double(total) /
                        Double(max(dailyGoal, 1)),
                        1
                    )
                )
                .tint(.indigo)

                Text(
                    "\(total) / \(dailyGoal) ml"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(percentage)%")
                .font(
                    .system(
                        size: 14,
                        weight: .semibold
                    )
                )
                .foregroundStyle(.indigo)
        }
        .padding(.vertical, 5)
    }

    // MARK: - Today's Entries

    private var todayEntriesSection: some View {

        VStack(
            alignment: .leading,
            spacing: 14
        ) {

            Text("Today's Entries")
                .font(.headline)

            if todayEntries.isEmpty {

                HStack {

                    Image(systemName: "drop")
                        .foregroundStyle(.indigo)

                    Text("No water recorded today")
                        .foregroundStyle(.secondary)

                    Spacer()
                }
                .padding(20)

            } else {

                ForEach(todayEntries) { entry in

                    HStack {

                        Image(
                            systemName: "drop.fill"
                        )
                        .foregroundStyle(.indigo)

                        Text(
                            "\(entry.amount) ml"
                        )
                        .fontWeight(.medium)

                        Spacer()

                        Text(
                            entry.date,
                            style: .time
                        )
                        .foregroundStyle(.secondary)
                    }

                    if entry.id != todayEntries.last?.id {
                        Divider()
                    }
                }
            }
        }
        .padding(20)
        .background(
            Color(.secondarySystemGroupedBackground)
        )
        .clipShape(
            RoundedRectangle(
                cornerRadius: 24
            )
        )
    }

    // MARK: - Today's Entries

    private var todayEntries: [WaterEntry] {

        let calendar = Calendar.current

        return entries.filter {
            calendar.isDateInToday($0.date)
        }
    }

    // MARK: - Weekly Days

    private var weeklyDays: [Date] {

        let calendar = Calendar.current

        let today = calendar.startOfDay(
            for: Date()
        )

        return (0..<7)
            .reversed()
            .compactMap { offset in

                calendar.date(
                    byAdding: .day,
                    value: -offset,
                    to: today
                )
            }
    }

    // MARK: - Total For Day

    private func totalForDay(
        _ date: Date
    ) -> Int {

        let calendar = Calendar.current

        return entries
            .filter {
                calendar.isDate(
                    $0.date,
                    inSameDayAs: date
                )
            }
            .reduce(0) {
                $0 + $1.amount
            }
    }

    // MARK: - Week Total

    private var weekTotal: Int {

        weeklyDays.reduce(0) { result, date in

            result + totalForDay(date)
        }
    }

    // MARK: - Daily Average

    private var dailyAverage: Int {

        guard !weeklyDays.isEmpty else {
            return 0
        }

        return weekTotal / weeklyDays.count
    }

    // MARK: - Completed Days

    private var completedDays: Int {

        weeklyDays.filter {
            totalForDay($0) >= dailyGoal
        }.count
    }

    // MARK: - In Progress Days

    private var inProgressDays: Int {

        weeklyDays.filter {

            let total = totalForDay($0)

            return total > 0 &&
                   total < dailyGoal

        }.count
    }

    // MARK: - Missed Days

    private var missedDays: Int {

        weeklyDays.filter {
            totalForDay($0) == 0
        }.count
    }

    // MARK: - Completion Percentage

    private func completionPercentage(
        _ total: Int
    ) -> Int {

        guard dailyGoal > 0 else {
            return 0
        }

        return min(
            Int(
                Double(total) /
                Double(dailyGoal) *
                100
            ),
            100
        )
    }
}

// MARK: - Preview

#Preview {

    HistoryView()
        .modelContainer(
            for: WaterEntry.self,
            inMemory: true
        )
}
