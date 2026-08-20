import SwiftUI

struct WaterBottleView: View {

    // MARK: - Water Progress

    let waterProgress: CGFloat

    // MARK: - Motion

    @State private var motion = MotionViewModel()

    // MARK: - Bottle Size

    private let bottleWidth: CGFloat = 260
    private let bottleHeight: CGFloat = 420
    private let bottleCornerRadius: CGFloat = 55

    var body: some View {

        ZStack {

            // MARK: - Bottle Background

            RoundedRectangle(
                cornerRadius: bottleCornerRadius
            )
            .fill(
                Color.blue.opacity(0.06)
            )
            .frame(
                width: bottleWidth,
                height: bottleHeight
            )

            // MARK: - Water

            WaveShape(
                progress: waterProgress,
                tilt: waterProgress > 0
                    ? CGFloat(motion.roll)
                    : 0
            )
            .fill(
                LinearGradient(
                    colors: [
                        Color.blue.opacity(0.75),
                        Color.blue.opacity(0.55)
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
                    cornerRadius: bottleCornerRadius
                )
            )

            // MARK: - Character

            Image("HydrationCharacter")
                .resizable()
                .scaledToFit()
                .frame(width: 230)
                .offset(y: -35)

            // MARK: - Bottle Border

            RoundedRectangle(
                cornerRadius: bottleCornerRadius
            )
            .stroke(
                Color.blue.opacity(0.10),
                lineWidth: 2
            )
            .frame(
                width: bottleWidth,
                height: bottleHeight
            )

            // MARK: - Bottle Neck + Cap

            // MARK: - Bottle Neck + Cap
            // MARK: - Bottle Neck + Cap

            VStack(spacing: -3) {

                // Cap
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.indigo.opacity(0.8))
                    .frame(
                        width: 80,
                        height: 42
                    )

                // Small neck
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.indigo.opacity(0.25))
                    .frame(
                        width: 60,
                        height: 14
                    )
            }
            .offset(y: -235)
        }
        .frame(
            width: bottleWidth,
            height: bottleHeight
        )
        .onAppear {
            motion.start()
        }
        .onDisappear {
            motion.stop()
        }
    }
}

// MARK: - Water Wave Shape

struct WaveShape: Shape {

    var progress: CGFloat
    var tilt: CGFloat

    var animatableData:
        AnimatablePair<CGFloat, CGFloat> {

        get {
            AnimatablePair(
                progress,
                tilt
            )
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

        // MARK: - Zero Water

        if safeProgress <= 0.001 {
            return path
        }

        // MARK: - Water Level

        let waterTop =
            rect.height * (1 - safeProgress)

        // MARK: - Gyro Tilt

        let safeTilt = min(
            max(tilt, -0.5),
            0.5
        )

        let tiltAmount =
            safeTilt * 60

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

        // MARK: - Bottom Right

        path.addLine(
            to: CGPoint(
                x: rect.width,
                y: rect.height
            )
        )

        // MARK: - Bottom Left

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

    VStack(spacing: 40) {

        WaterBottleView(
            waterProgress: 0
        )

        WaterBottleView(
            waterProgress: 0.25
        )
    }
}
