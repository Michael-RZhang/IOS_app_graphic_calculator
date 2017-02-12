//
//  ViewController.swift
//  CS193P_assignment
//
//  Created by Ruilin Zhang on 1/16/17.
//  Copyright © 2017 Ruilin Zhang. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var sequenceOfOperations: UILabel!
    
    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var MValue: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    var justsetM = false

    @IBAction func touchDigit(_ sender: UIButton) {
        
        let digit = sender.currentTitle!
        
        if userIsInTheMiddleOfTyping {
            let textCurrentlyinDisplay = display.text!

            if (digit != "." || !textCurrentlyinDisplay.contains(".")){
                display.text = textCurrentlyinDisplay + digit
            }
        } else {
            if (digit == "." ) {
                display.text = "0."
            }
            else {
                display.text = digit
            }
            
            let results = brain.evaluate(using: ViewDictionary)
            sequence = results.description
            
            userIsInTheMiddleOfTyping = true
        }
    }
    
    var sequence: String {
        get {
            return sequenceOfOperations.text!
        }
        set {
            if (newValue == "") {
                sequenceOfOperations.text = "0"
            } else {
                let results = brain.evaluate(using: ViewDictionary)
                if results.isPending {
                    sequenceOfOperations.text = newValue + "..."
                } else {
                    sequenceOfOperations.text = newValue
                }
            }
        }
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    public var ViewDictionary : Dictionary<String, Double> = [:]
   
    @IBAction func Clear(_ sender: UIButton) {
        userIsInTheMiddleOfTyping = false
        brain.Clear()
        if let result = brain.result {
            displayValue = result
        }
        
        if let description = brain.sequnce {
            sequence = description
        }
    }

    @IBAction func M(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.Clear()
            brain.setOperand(variable: sender.currentTitle!)
            
        } else {
            brain.setOperand(variable: sender.currentTitle!)
        }
        
        // update display
        let results = brain.evaluate(using: ViewDictionary)
        if let result = results.result {
            displayValue = result
        }
        
        sequence = results.description
        // display M in the bottom
        if let val = ViewDictionary["M"] {
            MValue.text = String(val)
        } else {
            MValue.text = "0.0"
        }
    }
    
    @IBAction func SetM(_ sender: UIButton) {
        // set the dictionary value
        ViewDictionary["M"] = displayValue
        print(ViewDictionary)
        // update display
        let results = brain.evaluate(using: ViewDictionary)
        if let result = results.result {
            displayValue = result
        }
        justsetM = true
        sequence = results.description
        // display M in the bottom
        if let val = ViewDictionary["M"] {
            MValue.text = String(val)
        } else {
            MValue.text = "0.0"
        }
    }
    
    @IBAction func Undo(_ sender: UIButton) {
        brain.Undo()
        // update display
        let results = brain.evaluate(using: ViewDictionary)
        if let result = results.result {
            displayValue = result
        } else {
            displayValue = 0.0
        }
        
        sequence = results.description
    }
    
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            if !justsetM {
                brain.setOperand(displayValue)
            }
            justsetM = false
            userIsInTheMiddleOfTyping = false
        }
        
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        
        // update display
        let results = brain.evaluate(using: ViewDictionary)
        if let result = results.result {
            displayValue = result
        }
        
        sequence = results.description
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        
        let newbrain = brain
        if !newbrain.resultIsPending {
            if let graphViewController = destinationViewController as? GraphViewController{
                
                graphViewController.formula =   {
                    var dict = [String: Double]()
                    dict["M"] = $0
                    if newbrain.evaluate(using: dict).result != nil {
                        return newbrain.evaluate(using: dict).result!
                    }
                    else {
                        return nil
                    }
                }
                
                graphViewController.navigationItem.title = newbrain.evaluate(using: ViewDictionary).description
            }
        }
    }
    
}

