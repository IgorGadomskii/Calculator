

import Foundation

struct Calculator {
    
    private var  newNumber: Decimal?
    private var expression: ArithmeticExpression?
    private var result: Decimal?
    
    
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
    
    private var number: Decimal? {
        newNumber ?? expression?.number ?? result
    }
    
    mutating func setDigit(_ digit: Digits) {
        
        guard canAddDigit(digit) else { return }
        let numberString = getNumberString(forNumber: newNumber)
        newNumber = Decimal(string: numberString.appending("\(digit.rawValue)"))
        
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
        
    }
    
    
    mutating func setDecimal(){
        
    }
    
    mutating func evaluate(){
        guard let number = newNumber, let expressionToEvaluate = expression else { return }
        result = expressionToEvaluate.evaluate(with: number)
        expression = nil
        newNumber = nil
    }
    
    
    mutating func allClear(){
        
    }
    
    
    mutating func clear(){
        
    }
    
    private func getNumberString(forNumber number: Decimal?,
                                 withComas: Bool = false) -> String {
        return (withComas ? number?.formatted(.number) : number.map(String.init)) ?? "0"
    }
    
    private func canAddDigit(_ digit: Digits) -> Bool {
            return number != nil || digit != .zero
        }
    
    func operationIsHighlighted(_ operation: ArithmeticOperations) -> Bool {
        return expression?.operation == operation && newNumber == nil
    }
}
