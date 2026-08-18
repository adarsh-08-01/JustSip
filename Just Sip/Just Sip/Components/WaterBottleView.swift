import SwiftUI
import CoreMotion
import Observation

struct WaterBottleView: View {
    
    let waterProgress: CGFloat
    
    @State private var motion = MotionManager()
    
    private let bottleWidth: CGFloat = 260
    private let bottleHeight: CGFloat = 420
    private let bottleRadius: CGFloat = 55
    
    var body: some View {
        ZStack {
            
            // MARK: - Bottle Body
            
            RoundedRectangle(cornerRadius: bottleRadius)
                .fill(Color.blue.opacity(0.06))
                .frame(
                    width: bottleWidth,
                    height: bottleHeight
                )
            
            
            // MARK: - Water
            
            if waterProgress > 0 {
                WaveShape(
                    progress: waterProgress,
                    tilt: CGFloat(motion.roll)
                )
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
                    width: bottleWidth,
                    height: bottleHeight
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: bottleRadius
                    )
                )
                .animation(
                    .easeOut(duration: 0.2),
                    value: motion.roll
                )
            }
            
            
            // MARK: - Character
            
            Image("HydrationCharacter")
                .resizable()
                .scaledToFit()
                .frame(width: 230)
                .offset(y: -35)
            
            
            // MARK: - Bottle Border
            
            RoundedRectangle(cornerRadius: bottleRadius)
                .stroke(
                    Color.blue.opacity(0.15),
                    lineWidth: 2
                )
                .frame(
                    width: bottleWidth,
                    height: bottleHeight
                )
            
            
            // MARK: - Bottle Neck + Cap
            
            VStack(spacing: -5) {
                
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.indigo.opacity(0.8))
                    .frame(
                        width: 100,
                        height: 55
                    )
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.indigo.opacity(0.25))
                    .frame(
                        width: 75,
                        height: 20
                    )
            }
            .offset(y: -245)
        }
    }
}


// MARK: - Water Wave Shape

struct WaveShape: Shape {
    
    var progress: CGFloat
    var tilt: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get {
            AnimatablePair(progress, tilt)
        }
        set {
            progress = newValue.first
            tilt = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        
        var path = Path()
        
        // Keep progress between 0 and 1
        let safeProgress = min(
            max(progress, 0),
            1
        )
        
        // Calculate water height
        let waterTop = rect.height * (1 - safeProgress)
        
        // Limit phone tilt
        let safeTilt = min(
            max(tilt, -0.5),
            0.5
        )
        
        let tiltAmount = safeTilt * 80
        
        
        // MARK: - Water Surface
        
        path.move(
            to: CGPoint(
                x: 0,
                y: waterTop + tiltAmount
            )
        )
        
        path.addCurve(
            to: CGPoint(
                x: rect.width,
                y: waterTop - tiltAmount
            ),
            control1: CGPoint(
                x: rect.width * 0.33,
                y: waterTop + tiltAmount
            ),
            control2: CGPoint(
                x: rect.width * 0.66,
                y: waterTop - tiltAmount
            )
        )
        
        
        // MARK: - Bottom
        
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


// MARK: - Preview

#Preview {
    WaterBottleView(
        waterProgress: 0.5
    )
}
