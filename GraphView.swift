//
//  GraphView.swift
//  CS193P_assignment
//
//  Created by Ruilin Zhang on 2/7/17.
//  Copyright © 2017 Ruilin Zhang. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {

    
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    
    var calc: ((Double)->Double?)? = nil { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var scale: Double = 50 { didSet { setNeedsDisplay() } }
    
    var neworigin: CGPoint?
    
    var origin: CGPoint {
        set {
            
            neworigin = newValue
            setNeedsDisplay()
        }
        get {
            return neworigin ?? graphCenter
        }
    }
    
    private var graphCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    private let axesDrawer = AxesDrawer()
    
    
    override func draw(_ rect: CGRect) {
        color.set()
        axesDrawer.drawAxes(in: bounds, origin: origin, pointsPerUnit: CGFloat(scale))
        drawCurve(bounds: bounds, origin: origin, scale: CGFloat(scale))
    }
    
    // draw curve
    private func drawCurve(bounds: CGRect, origin: CGPoint, scale: CGFloat) {
        if calc != nil {
            let path = UIBezierPath()
            let originx = Double(origin.x)
            let originy = Double(origin.y)
            var first: Bool = true
            for i in stride(from: 0, to: bounds.maxX, by: 0.5) {
                
                let pointx = (Double(i) - originx) / Double(scale)
                let pointy = calc!(pointx)
                let pixelx = CGFloat(i)
                if pointy != nil {
                    let pixely = CGFloat(originy - pointy! * Double(scale))
                    if first {
                        path.move(to: CGPoint(x: pixelx, y:pixely))
                        first = false
                    }
                    else {
                        path.addLine(to: CGPoint(x: pixelx, y:pixely))
                    }
                }
                
            }
            
            path.stroke()
        }
    }
    
    // gesture
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer)
    {
        switch pinchRecognizer.state {
        case .changed,.ended:
            scale *= Double(pinchRecognizer.scale)
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
    
    func doubleTap(byReactiongTo tapRecognizer: UITapGestureRecognizer)
    {
        if tapRecognizer.state == .ended {
            print("hello")
            origin = tapRecognizer.location(in: self)
            print(origin)
        }

    }
    
    func moveGraph(byReactingTo panRecognizer: UIPanGestureRecognizer)
    {
        switch panRecognizer.state {
        case .changed,.ended:
            let translation = panRecognizer.translation(in: self)
            origin = CGPoint(x: origin.x + translation.x, y: origin.y + translation.y)
        default:
            break
        }
    }
}
