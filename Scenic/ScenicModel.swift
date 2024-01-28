//
//  ScenicModel.swift
//  Scenic
//
//  Created by Nick Twyman on 1/25/24.
//

import Foundation

typealias GridPoint = (z: Double, vel: Double)

@Observable class ScenicModel {
    private let rangeX: ClosedRange<Int>
    private let rangeY: ClosedRange<Int>
    private let strideY: Int
    private let defaultValue: GridPoint
    private var values: [GridPoint]
    
    init(rangeX: ClosedRange<Int>, rangeY: ClosedRange<Int>) {
        self.rangeX = rangeX
        self.rangeY = rangeY
        self.strideY = 1 + rangeY.upperBound - rangeY.lowerBound
        self.defaultValue = (0.0, 0.0)
        self.values = Array(repeating: defaultValue, count: strideY * (1 + rangeX.upperBound - rangeX.lowerBound))
        
        
        let originIdx = index(x: 0, y:0)
        self.values[originIdx] = (5.0, 0)
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            self.iterate(timer: timer)
        }
    }
    
    private func index(x:Int, y: Int) -> Int {
        x - rangeX.lowerBound + (y - rangeY.lowerBound) * strideY
    }
    
    private func getValue(x: Int, y: Int) -> GridPoint {
        if rangeX ~= x && rangeY ~= y {
            return values[index(x: x, y: y)]
        }
        return defaultValue
    }
    
    func getZ(x: Int, y: Int) -> Double {
        getValue(x: x, y: y).z
    }
    
    
    func iterate(timer: Timer) {
        var newValues = Array(repeating: defaultValue, count: self.values.count)
        for x in rangeX {
            for y in rangeY {
                let old = getValue(x: x, y: y)
                let oldZ = old.z
                let around = [getZ(x: x-1 , y: y), getZ(x: x, y: y-1), getZ(x: x, y: y+1), getZ(x: x+1, y: y)]
                let acc = around.map({ $0 - oldZ}).reduce(0, +)/10
                let v = old.vel + acc
                newValues[index(x: x, y:y)] = GridPoint(z: oldZ+v, vel: v)
            }
        }
        self.values = newValues
    }
}
