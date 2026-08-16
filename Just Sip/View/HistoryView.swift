import SwiftUI
import SwiftData

struct HistoryView: View {
    
    @Query(
        sort: \WaterEntry.date,
        order: .reverse
    )
    private var entries: [WaterEntry]
    
    var body: some View {
        NavigationStack {
            List {
                
                // MARK: - Today's Summary
                
                Section {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text("\(todayTotal) ml")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundStyle(.indigo)
                        
                        Text("of 5,000 ml Goal")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        ProgressView(
                            value: min(
                                Double(todayTotal) / 3000.0,
                                1.0
                            )
                        )
                        .tint(.indigo)
                    }
                    .padding(.vertical, 8)
                }
                
                // MARK: - Today's Entries
                
                Section("Today's Entries") {
                    
                    if todayEntries.isEmpty {
                        
                        ContentUnavailableView(
                            "No Water Yet",
                            systemImage: "drop",
                            description: Text(
                                "Start drinking water to see your entries here."
                            )
                        )
                        
                    } else {
                        
                        ForEach(todayEntries) { entry in
                            
                            HStack {
                                
                                Image(systemName: "drop.fill")
                                    .foregroundStyle(.indigo)
                                
                                Text("\(entry.amount) ml")
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Text(entry.date, style: .time)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    // MARK: - Today's Entries
    
    private var todayEntries: [WaterEntry] {
        
        let calendar = Calendar.current
        
        return entries.filter {
            calendar.isDateInToday($0.date)
        }
    }
    
    // MARK: - Today's Total
    
    private var todayTotal: Int {
        
        todayEntries.reduce(0) {
            $0 + $1.amount
        }
    }
}

#Preview {
    HistoryView()
}
