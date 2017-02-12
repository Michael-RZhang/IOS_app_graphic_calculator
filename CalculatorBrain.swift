//
//  CalculatorBrain.swift
//  CS193P_assignment
//
//  Created by Ruilin Zhang on 1/16/17.
//  Copyright © 2017 Ruilin Zhang. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    
    
    
    private var actOnSingleDigit: Bool = false
    private var lastDigit: String = ""
    
    private var description: String = ""
    private var descriptionWithoutLastDigit: String = ""
    
    private var accumulator: Double?
    
    internal var ViewDictionary: Dictionary<String, Double>?
    
    
    private var variableM: String?
    private var descriptionWithoutTrueValue: String?
    
    internal var resultIsPending: Bool = false
    
    private var memory = [Element]()
    
    private var MvalueSet: Bool = false
    
    private var output: Double?
    
    private enum Operation {
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double, Double) -> Double)
        case equals
    }
    
    private var operations: Dictionary<String, Operation> =
        ["π": Operation.constant(Double.pi),
         "e": Operation.constant(M_E),
         "√":  Operation.unaryOperation(sqrt),
         "cos": Operation.unaryOperation(cos),
         "sin": Operation.unaryOperation(sin),
         "In()": Operation.unaryOperation(log),
         "±": Operation.unaryOperation({-$0}),
         "^2": Operation.unaryOperation({$0 * $0}),
         "×": Operation.binaryOperation({$0 * $1}),
         "÷": Operation.binaryOperation({$0 / $1}),
         "+": Operation.binaryOperation({$0 + $1}),
         "-": Operation.binaryOperation({$0 - $1}),
         "=": Operation.equals,
    ]
    
    private enum Element {
        case number(Double)
        case variable(String)
        case operation(String)
    }
    
    func evaluate(using variables: Dictionary<String,Double>? = nil)
        -> (result: Double?, isPending: Bool, description: String){
            // main work in here
            
//            print(memory)
            
            var pendingBinaryOperation: PendingBinaryOperation?
            
            struct PendingBinaryOperation {
                let function: (Double, Double) -> Double
                let firstOperand: Double
                
                func perform(with secondOperand: Double) -> Double {
                    return function(firstOperand, secondOperand)
                }
            }
            
            // initalize the return values
            var Newdescription = ""
            var Newresult: Double?
            var NewresultIsPending: Bool = false
            
            // iterate the memory
            for item in memory{
                switch item {
                case .number(let value):
                    Newresult = Double(value)
                    Newdescription = Newdescription + String(value)
                case .variable(let value):
                    // if enter this case, must have "M"
                    Newdescription = Newdescription + value
                    if variables != nil {
                        // M in the varibles
                        if let val = variables?[value] {
                            Newresult = val
                        } else {
                            Newresult = 0.0
                        }
                    }
                case .operation(let op):
                    Newdescription = Newdescription + op
                    if let operation = operations[op] {
                        switch operation {
                        case .constant(let value):
                            Newresult = value
                            
                        case .unaryOperation(let function):
                            if Newresult != nil {
                                Newresult = function(Newresult!)
                                
                            }
                        case .binaryOperation(let function):
                            if Newresult != nil {
                                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: Newresult!)
                                Newresult = nil
                                NewresultIsPending = true
                                
                            }
                        case .equals:
                            if pendingBinaryOperation != nil && Newresult != nil {
                                Newresult = pendingBinaryOperation!.perform(with: Newresult!)
                                pendingBinaryOperation = nil
                                NewresultIsPending = false
                            }
                        }
                    }
                }
            }
            print(memory)
            print(Newresult, NewresultIsPending, Newdescription)
            return (Newresult, NewresultIsPending, Newdescription)
    }

    mutating func Clear() {
        memory = [Element]()
        MvalueSet = false
    }
    
    mutating func Undo() {
        if !memory.isEmpty {
            memory.removeLast()
        }
    }

    mutating func performOperation(_ symbol: String){
        memory.append(Element.operation(symbol))
    
    }
    

    mutating func setOperand(_ operand: Double) {
        memory.append(Element.number(operand))
    }

    mutating func setOperand(variable named: String) {
        memory.append(Element.variable(named))
        MvalueSet = true
    }

    var sequnce: String? {
        get {
            return description
        }
    }

    var result: Double? {
        get {
            if output == nil {
                return 0.0
            } else {
                return output
            }
            
        }
        set {
            result = newValue
        }
    }

}
