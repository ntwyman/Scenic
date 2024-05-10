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
        self.randomDrop()
        
        Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
            self.iterate(timer: timer)
        }
        
        Timer.scheduledTimer(withTimeInterval: 17.0, repeats: true) { timer in
            self.randomDrop()
        }
        
        Timer.scheduledTimer(withTimeInterval: 91, repeats: true) { timer in
            self.values = Array(repeating: self.defaultValue, count: self.strideY * (1 + rangeX.upperBound - rangeX.lowerBound))
            self.randomDrop()
        }
    }
    private func randomDrop() {
        let xRand = Int.random(in: rangeX)
        let yRand = Int.random(in: rangeY)
        let idx = self.index(x: xRand, y: yRand)
        self.values[idx] = (5.0, 0)
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
