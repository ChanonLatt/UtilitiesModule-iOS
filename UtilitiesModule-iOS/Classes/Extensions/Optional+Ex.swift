
import Foundation

extension Optional {
    
    func unwrap( _ execute: (Wrapped)->Void) {
        if let value = self {
            execute(value)
        }
    }
    
    var isNil: Bool {
        self == nil
    }
    
    var isNotNil: Bool {
        !isNil
    }
}