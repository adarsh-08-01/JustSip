import Foundation
import SwiftData

@Model
final class WaterEntry {
    
    var amount: Int
    var date: Date
    
    init(
        amount: Int,
        date: Date = Date()
    ) {
        self.amount = amount
        self.date = date
    }
}
