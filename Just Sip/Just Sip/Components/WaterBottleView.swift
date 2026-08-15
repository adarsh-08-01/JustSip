import Foundation
import Observation
import SwiftUI



final class WaterEntity{
    var amount: Int
    var date: Date
    
    init(
        amount: Int,
        date: Date = Date()
    ){
        self.amount = amount
        self.date = date
    }
}
struct WaterBottleView: View {
    
    // Temporary value.
    // Later this will come from our WaterViewModel.
    let waterProgress: CGFloat
    var body: some View {
        ZStack {
            
            // MARK: Bottle Body
            RoundedRectangle(cornerRadius: 55)
                .fill(Color.blue.opacity(0.06))
                .frame(width: 260, height: 420)
            
            // MARK: Character
            Image("HydrationCharacter")
                .resizable()
                .scaledToFit()
                .frame(width: 230)
                .offset(y: -35)
            
            // MARK: Water
            WaveShape()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.indigo.opacity(0.85),
                            Color.blue.opacity(0.75)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(
                    width: 260,
                    height: 420 * waterProgress
                )
                .frame(
                    width: 260,
                    height: 420,
                    alignment: .bottom
                )
                .clipShape(
                    RoundedRectangle(cornerRadius: 55)
                )
            
            // MARK: Bottle Neck + Cap
            VStack(spacing: -5) {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.indigo.opacity(0.8))
                    .frame(width: 100, height: 55)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.indigo.opacity(0.25))
                    .frame(width: 75, height: 20)
            }
            .offset(y: -245)
        }
    }
}


// MARK: - Water Wave Shape

struct WaveShape: Shape {
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        let waveHeight: CGFloat = 15
        
        path.move(
            to: CGPoint(
                x: 0,
                y: waveHeight
            )
        )
        
        path.addCurve(
            to: CGPoint(
                x: rect.width,
                y: waveHeight
            ),
            control1: CGPoint(
                x: rect.width * 0.25,
                y: -waveHeight
            ),
            control2: CGPoint(
                x: rect.width * 0.75,
                y: waveHeight * 2
            )
        )
        
        path.addLine(
            to: CGPoint(
                x: rect.width,
                y: rect.height
            )
        )
        
        path.addLine(
            to: CGPoint(
                x: 0,
                y: rect.height
            )
        )
        
        path.closeSubpath()
        
        return path
    }
}


#Preview {
    WaterBottleView(
        waterProgress: 0.10
    )
}
