import Foundation
import Observation

@Observable
final class WaterViewModel {
    
    // MARK: - Daily Goal
    
    var dailyGoal: Int = 3000
    
    // MARK: - Water Consumed
    
    var waterConsumed: Int = 2000
    
    // MARK: - Progress
    
    var progress: Double {
        guard dailyGoal > 0 else {
            return 0
        }
        
        return Double(waterConsumed) / Double(dailyGoal)
    }
    
    // MARK: - Add Water
    
    func addWater(_ amount: Int) {
        waterConsumed += amount
    }
}
