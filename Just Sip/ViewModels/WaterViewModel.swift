import Foundation
import Observation
import SwiftData

@Observable
final class WaterViewModel {
    
    // MARK: - Daily Goal
    
    var dailyGoal: Int = 5000
    
    // MARK: - Water Consumed
    
    var waterConsumed: Int = 0
    
    // MARK: - Progress
    
    var progress: Double {
        guard dailyGoal > 0 else {
            return 0
        }
        
        return Double(waterConsumed) / Double(dailyGoal)
    }
    
    // MARK: - Add Water
    
    func addWater(_ amount: Int,
                  context : ModelContext) {
        waterConsumed += amount
        
        let entry = WaterEntry(amount: amount)
        
        context.insert(entry)
        do{
            try context.save()
        } catch {
            print("Faild to save water entry: \(error)")
        }
    }
    // MARK: - Load Today's Water
    func loadToday(from entries: [WaterEntry]) {
        
        let todayEntries = entries.filter {
            Calendar.current.isDateInToday($0.date)
        }
        
        waterConsumed = todayEntries.reduce(0) {
            $0 + $1.amount
        }
    }
    func loadTodayWater(
        context: ModelContext
    ){
        let calendar = Calendar.current
        
        let startOfToday = calendar.startOfDay(for: Date())
        
        let tomorrow = calendar.date(
            byAdding: .day,
            value: 1,
            to: startOfToday)!
        let descriptor = FetchDescriptor<WaterEntry>(
            predicate: #Predicate { entry in
                entry.date >= startOfToday &&
                entry.date < tomorrow
            }
        )
        do{
            let entries = try context.fetch(descriptor)
            
            waterConsumed = entries.reduce(0){
                $0 + $1.amount
            }
        } catch{
            print("Failed to load today's water: \(error)")
        }
    }
}
