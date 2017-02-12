//
//  GraphViewController.swift
//  CS193P_assignment
//
//  Created by Ruilin Zhang on 2/7/17.
//  Copyright © 2017 Ruilin Zhang. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    @IBOutlet weak var graphView: GraphView!  {
        didSet {
            if formula != nil {
                graphView.calc = formula
            }
            
            let handler1 = #selector(GraphView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: handler1)
            graphView.addGestureRecognizer(pinchRecognizer)
            
            let handler2 = #selector(GraphView.doubleTap(byReactiongTo:))
            let doubleTapGestureRecognizer = UITapGestureRecognizer(target: graphView, action: handler2)
            doubleTapGestureRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(doubleTapGestureRecognizer)
            
            let handler3 = #selector(GraphView.moveGraph(byReactingTo: ))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: handler3))
        }
    }
    
    
    
    var formula: (( _ x: Double) -> Double?)? 

}
