
import Foundation

enum ArithmeticOperations: CaseIterable, CustomStringConvertible {
    
    case addition
    case subtraction
    case multiplication
    case division
    
    var description: String {
        switch self{
        case .addition:
            return "+"
        case .subtraction:
            return "-"
        case .multiplication:
            return "×"
        case . division:
            return "÷"
        }
    }
}
