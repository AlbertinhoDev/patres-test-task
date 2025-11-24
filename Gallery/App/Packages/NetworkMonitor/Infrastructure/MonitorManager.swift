import Foundation
import Network

final class MonitorManager {
}

extension MonitorManager: MonitorDataSource {
    func checkConnect() async -> Bool {
        await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            
            monitor.pathUpdateHandler = { path in
                continuation.resume(returning: path.status == .satisfied)
                monitor.cancel()
            }
                        
            monitor.start(queue: .global())
        }
    }
}
