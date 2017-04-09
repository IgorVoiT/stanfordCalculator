//
//  CalculatorBrain.swift
//  StanfordCalculator
//
//  Created by Игорь on 15.10.16.
//  Copyright © 2016 Игорь. All rights reserved.
//


import Foundation

private func factorial(of number: Double) -> Double {
    if number > 170 { return Double.infinity }
    if number != Double(Int(number)) || number < 1 { return 0 }
    if number == 1 { return 1 }
    return number * factorial(of: number - 1)
}


class CalculatorBrain {
    
    // MARK: Private properties
    private var accumulator = 0.0
    private var isPartialResult  = false
    private var description = " "
    private var pending : PendingBinaryOperationInfo?
    private var previous : PreviousBinaryOperationInfo?
    
    private var symbolList: Dictionary<String, Operation> = [
        "π" : Operation.Constant(M_PI),
        "e" : Operation.Constant(M_E),
        "ln": Operation.Constant(M_LN2),
        "√" : Operation.UnariOperation(sqrt),
        "×" : Operation.BinaryOperation({$0 * $1}),
        "+" : Operation.BinaryOperation({$0 + $1}),
        "−" : Operation.BinaryOperation({$0 - $1}),
        "÷" : Operation.BinaryOperation({$0 / $1}),
        "=" : Operation.Equals,
        "±" : Operation.UnariOperation({-$0}),
        "%" : Operation.UnariOperation({$0/100}),
        "x²": Operation.UnariOperation({$0*$0}),
        "x!": Operation.UnariOperation(factorial)
    ]
    
    
    // MARK: Private types
    private enum Operation {
        case Constant(Double)
        case UnariOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    private struct PendingBinaryOperationInfo {
        var function: (Double, Double) -> Double
        var firstOpetand: Double
    }
    
    private struct PreviousBinaryOperationInfo {
        var function: (Double, Double) -> Double
        var operand: Double
    }
    
    // MARK: Private functions
    private func executePendingBinaryOperation()
    {
        if pending != nil{
            accumulator = pending!.function(pending!.firstOpetand, accumulator)
            pending = nil
            isPartialResult = false
        }
    }
    
    private func executePreviousBinaryOperation() {
        if previous != nil {
            accumulator = previous!.function(accumulator, previous!.operand)
        }
    }
    
    private func configureDescriprion(with symbol: String) {
        let binaryOperations = "−+÷×"
        switch symbol {
        case "−", "+", "÷", "×":
            if binaryOperations.characters.contains(description.characters.last!) {
                description.characters.removeLast()
                description += symbol
            } else {
                description += symbol
            }
        case "x²", "x!":
            let newSymbol = symbol.characters.dropFirst()
            for character in binaryOperations.characters {
                if description.characters.contains(character) && pending == nil {
                    description.remove(at: description.startIndex)
                    description = "(" + description + ")"
                    break
                }
            }
            description += String(newSymbol)
        default:
            break
        }
        // func not finished
    }
    
    
    // MARK: Public API
    
    /// This var allows to set pending only to nil (no matter true of false), because we don't need to set pending to anything else in view controller
    var pendingOperation: Bool {
        get {
            if pending != nil {
                return true
            }
            return false
        }
        set {
            pending = nil
        }
    }
    var previousOperation: Bool {
        get {
            if previous != nil {
                return true
            }
            return false
        }
        set {
            previous = nil
        }
    }
    
    
    var partialResult : Bool {
        get{
            return isPartialResult
        }
    }
    
    var result : Double {
        get{
            return accumulator
        }
    }
    
    var getDescription : String {
        get{
            return description
        }
    }
    
    func performOperation(symbol: String) {
        if let operation = symbolList[symbol] {
            configureDescriprion(with: symbol)
            switch operation {
            case .Constant (let value): accumulator = value
            case .UnariOperation(let unariOperation): accumulator = unariOperation(accumulator)
            case .BinaryOperation (let binaryOperation):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(function: binaryOperation, firstOpetand: accumulator)
                previous = PreviousBinaryOperationInfo(function: binaryOperation, operand: accumulator)
                isPartialResult = true
            case .Equals:
                if pending != nil {
                    previous?.operand = accumulator
                    executePendingBinaryOperation()
                } else {
                    executePreviousBinaryOperation()
                }
            }
        }
    }
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    func setDescription(description: String) {
        self.description = description
    }
    
    
}


