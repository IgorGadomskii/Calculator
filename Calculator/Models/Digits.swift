
import Foundation

enum Digits: Int, CaseIterable, CustomStringConvertible {

    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    
    
    var description: String {
        "\(rawValue)"
    }
}
