import Foundation
import CoreMotion
import Observation

@Observable
final class MotionManager {
    
    private let motionManager = CMMotionManager()
    
    var roll: Double = 0
    var pitch: Double = 0
    
    init() {
        startMotionUpdates()
    }
    
    private func startMotionUpdates() {
        
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
        
        motionManager.startDeviceMotionUpdates(
            using: .xArbitraryZVertical,
            to: .main
        ) { [weak self] motion, error in
            
            guard let motion else {
                return
            }
            
            self?.roll = motion.attitude.roll
            self?.pitch = motion.attitude.pitch
        }
    }
    
    deinit {
        motionManager.stopDeviceMotionUpdates()
    }
}
