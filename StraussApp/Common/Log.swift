import Foundation

protocol Loging {
    func log(_ error: Error, file: String, line: Int, function: String)
}

extension Loging {
    func log(_ error: Error, file: String = #file, line: Int = #line, function: String = #function) {
        debugPrint("DEBUG: \(file) - \(line) - \(function)")
        debugPrint("Error: \(error.localizedDescription)")
    }
}


