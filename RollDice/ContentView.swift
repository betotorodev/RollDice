//
//  ContentView.swift
//  RollDice
//
//  Created by Beto Toro on 1/11/22.
//

import SwiftUI

struct ContentView: View {
  let diceTypes = [4, 6, 8, 10, 12, 20, 100]
  
  @AppStorage("selectedDiceType") var selectedDiceType = 6
  @AppStorage("numberToRoll") var numberToRoll = 4
  
  func rollDice() {
    
  }
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Picker("Type of dice", selection: $selectedDiceType) {
            ForEach(diceTypes, id: \.self) { type in
              Text("D\(type)")
            }
          }
          .pickerStyle(.segmented)
          
          Stepper("Number To Roll", value: $numberToRoll, in: 1...20)
          
          Button("Roll Them!", action: rollDice)
        }
      }
      .navigationTitle("High Rollers")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
