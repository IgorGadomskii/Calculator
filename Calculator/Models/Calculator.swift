

import Foundation

struct Calculator {
    
    private var newNumber: Decimal? {
        didSet {
            guard number != nil else { return }
            carryingNegative = false
            carryingDecimal = false
            carryingZeroCount = 0
            pressedClear = false
        }
    }
    private var expression: ArithmeticExpression?
    private var result: Decimal?
    
    private var carryingNegative: Bool = false
    private var carryingDecimal: Bool = false
    private var pressedClear: Bool = false
    
    
    private var containDecimals: Bool {
        return getNumberString(forNumber: number).contains(".")
    }
    private var carryingZeroCount: Int = 0
    
    var showAllClear: Bool {
            newNumber == nil && expression == nil && result == nil || pressedClear
    }
    
    private struct ArithmeticExpression: Equatable {
        
        var number: Decimal
        var operation: ArithmeticOperations
        
        
        func evaluate(with secondNumber: Decimal) -> Decimal {
            switch operation {
            case .addition:
                 return number + secondNumber
            case .subtraction:
                 return number - secondNumber
            case .multiplication:
                 return number * secondNumber
            case .division:
                 return number / secondNumber
            }
        }
    }
    
    var displayText: String  {
        return getNumberString(forNumber: number, withComas: true)
    }
    
    var number: Decimal? {
           if pressedClear || carryingDecimal {
               return newNumber
           }
           return newNumber ?? expression?.number ?? result
    }
    
    mutating func setDigit(_ digit: Digits) {
        
        if containDecimals && digit == .zero{
            carryingZeroCount += 1
        } else if canAddDigit(digit) {
            let numberString = getNumberString(forNumber: newNumber)
            newNumber = Decimal(string: numberString.appending("\(digit.rawValue)"))
        }
    }
    
    mutating func setOperation(_ operation: ArithmeticOperations){
        guard var number = newNumber ?? result else { return }
        
        if let existingExpression = expression {
            number = existingExpression.evaluate(with: number)
        }
        
        expression = ArithmeticExpression(number: number, operation: operation)
        
        newNumber = nil
    }
    
    mutating func toggleSign() {
        if let number = newNumber {
                   newNumber = -number
                   return
               }
               if let number = result {
                   result = -number
                   return
               }

               carryingNegative.toggle()
    }
    
    mutating func setPercent() {
        if let number = newNumber {
            newNumber = number / 100
        }
        
        if let number = result {
            result = number / 100
        }
    }
    
    
    mutating func setDecimal(){
        if containDecimals {
            return
        }
        carryingDecimal = true
    }
    
    mutating func evaluate(){
        guard let number = newNumber, let expressionToEvaluate = expression else { return }
        result = expressionToEvaluate.evaluate(with: number)
        expression = nil
        newNumber = nil
    }
    
    
    mutating func allClear(){
        newNumber = nil
        expression = nil
        result = nil
        carryingNegative = false
        carryingDecimal = false
        carryingZeroCount = 0
    }
    
    
    mutating func clear(){
        newNumber = nil
        carryingNegative = false
        carryingDecimal = false
        carryingZeroCount = 0
                
        pressedClear = true
    }
    
    private func getNumberString(forNumber number: Decimal?,
                                 withComas: Bool = false) -> String {
        var numberString = (withComas ? number?.formatted(.number) : number.map(String.init)) ?? "0"
        
        if carryingNegative {
            numberString.insert("-", at: numberString.startIndex)
        }
        
        if carryingDecimal {
            numberString.insert(".", at: numberString.endIndex)
        }
        
        if carryingZeroCount > 0 {
            numberString.append(String(repeating: "0", count: carryingZeroCount))
        }
        
        return numberString
    }
    
    private func canAddDigit(_ digit: Digits) -> Bool {
            return number != nil || digit != .zero
        }
    
    func operationIsHighlighted(_ operation: ArithmeticOperations) -> Bool {
        return expression?.operation == operation && newNumber == nil
    }
}
