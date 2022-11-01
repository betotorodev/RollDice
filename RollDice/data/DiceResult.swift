//
//  DiceResult.swift
//  RollDice
//
//  Created by Beto Toro on 1/11/22.
//

import Foundation

struct DiceResult: Identifiable, Codable {
  var id = UUID()
  var type: Int
  var number: Int
  var rolls = [Int]()
  
  init(type: Int, number: Int) {
    self.type = type
    self.number = number
    
    for _ in 0..<number {
      let roll = Int.random(in: 0...type)
      rolls.append(roll)
    }
  }
}