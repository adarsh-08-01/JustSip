import Foundation
import CoreMotion
import Observation

@Observable
final class MotionViewModel {

    // MARK: - Motion Manager

    private let motionManager = CMMotionManager()

    // MARK: - Public Motion Value

    var roll: Double = 0

    // MARK: - Private

    private var isRunning = false

    // MARK: - Start Motion

    func start() {

        guard !isRunning else {
            return
        }

        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available.")
            return
        }

        isRunning = true

        // 30 updates per second.
        // Good balance between smoothness and performance.
        motionManager.deviceMotionUpdateInterval = 1.0 / 30.0

        motionManager.startDeviceMotionUpdates(
            using: .xArbitraryZVertical,
            to: OperationQueue.main
        ) { [weak self] motion, error in

            guard let self else {
                return
            }

            if let error {
                print("Motion error: \(error)")
                return
            }

            guard let motion else {
                return
            }

            // Raw gyro value
            let rawRoll = motion.attitude.roll

            // Limit extreme movement
            let clampedRoll = min(
                max(rawRoll, -0.7),
                0.7
            )

            // Smooth the movement
            let smoothing: Double = 0.15

            self.roll += (
                clampedRoll - self.roll
            ) * smoothing
        }
    }

    // MARK: - Stop Motion

    func stop() {

        guard isRunning else {
            return
        }

        motionManager.stopDeviceMotionUpdates()

        isRunning = false
    }

    // MARK: - Deinit

    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
