//
//  ViewController.swift
//  CalcGraph_I
//
//  Created by Chris William Sehnert on 8/23/17.
//  Copyright © 2017 InSehnDesigns. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    

    @IBOutlet weak var graphView: GraphView! {
        didSet {
            let tapHandler = #selector(moveOrigin(byReactingTo:))
            let tapRecognizer = UITapGestureRecognizer(target: self, action: tapHandler)
            tapRecognizer.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tapRecognizer)
           
            let panHandler = #selector(panOrigin(byReactingTo:))
            let panRecognizer = UIPanGestureRecognizer(target: self, action: panHandler)
            graphView.addGestureRecognizer(panRecognizer)
            
            let pinchHandler = #selector(changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: pinchHandler)
            graphView.addGestureRecognizer(pinchRecognizer)
            
            updateUI()
            
        }
    }
    
    var path = UIBezierPath()
    
    
    var modelCalculatedYValue: CGFloat? {
        if graphView.xCoordinate != nil {
            graphView.calculateYValueRange()
           // let tempY: CGFloat = (graphView.xCoordinate!) * (graphView.xCoordinate!)
            let tempY: CGFloat = 10 * sin(graphView.xCoordinate!)
            if tempY > graphView.minYValue! && tempY < graphView.maxYValue! {
                return tempY
            }
        }
        return nil
    }
    
    func plotGraph () {
        if graphView != nil {
            graphView.pathStart = true
            graphView.equationPath?.removeAllPoints()
            graphView.numberOfGraphPoints()
            
            for x in 0...graphView.maxPoints! {
                
                graphView.convertGraphPointsToXCoordinate(graphPoint: x)
                if modelCalculatedYValue != nil {
                    graphView.createPointFromCoordinate(graphPointX: x, yValue: modelCalculatedYValue!)
                } else {
                    graphView.pathStart = true
                    continue
                }
                switch graphView.pathStart {
                case true:
                    if graphView.pathPoint != nil {
                        path.move(to: graphView.pathPoint!)
                        graphView.pathStart = false
                    }
                case false:
                    path.addLine(to: graphView.pathPoint!)
                }
            }
            
            path.lineWidth = graphView.pathWidth
            graphView.equationPath = path
        }
    }
    
    
    func moveOrigin (byReactingTo tapGesture: UITapGestureRecognizer) {
        if tapGesture.state == .ended {
            graphView.axesOrigin = tapGesture.location(in: graphView)
            plotGraph()
        }
    }
    
    func panOrigin (byReactingTo panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            panGesture.setTranslation(graphView.axesOrigin, in: graphView)
        case .changed, .ended:
            graphView.axesOrigin = panGesture.translation(in: graphView)
            plotGraph()
        default:
            break
        }
    }
    
    func changeScale (byReactingTo pinchGesture: UIPinchGestureRecognizer) {
        switch pinchGesture.state  {
        case .changed, .ended:
            graphView.scale *= pinchGesture.scale
            pinchGesture.scale = 1
            plotGraph()
        default:
            break
        }
    }
        
    
    func updateUI () {
        graphView.colorizeAxes()
        plotGraph()
    }
 

}



/*

@IBOutlet weak var graphView: GraphView! {
    didSet {
        let tapHandler = #selector(GraphView.moveOrigin(byReactingTo:))
        let tapRecognizer = UITapGestureRecognizer(target: graphView, action: tapHandler)
        tapRecognizer.numberOfTapsRequired = 2
        graphView.addGestureRecognizer(tapRecognizer)
        
        let panHandler = #selector(GraphView.panOrigin(byReactingTo:))
        let panRecognizer = UIPanGestureRecognizer(target: graphView, action: panHandler)
        graphView.addGestureRecognizer(panRecognizer)
        
        let pinchHandler = #selector(GraphView.changeScale(byReactingTo:))
        let pinchRecognizer = UIPinchGestureRecognizer(target: graphView, action: pinchHandler)
        graphView.addGestureRecognizer(pinchRecognizer)
        
        updateUI()
        
    }
}
*/










