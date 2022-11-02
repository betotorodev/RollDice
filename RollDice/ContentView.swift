//
//  ContentView.swift
//  RollDice
//
//  Created by Beto Toro on 1/11/22.
//

import SwiftUI

struct ContentView: View {
  let diceTypes = [4, 6, 8, 10, 12, 20, 100]
  let columns: [GridItem] = [
    .init(.adaptive(minimum: 60))
  ]
  
  @AppStorage("selectedDiceType") var selectedDiceType = 6
  @AppStorage("numberToRoll") var numberToRoll = 4
  
  @State private var currentResult = DiceResult(type: 0, number: 0)
  
  func rollDice() {
    currentResult = DiceResult(type: selectedDiceType, number: numberToRoll)
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
          
          Stepper("Number of dice: \(numberToRoll)", value: $numberToRoll, in: 1...20)
          
          Button("Roll Them!", action: rollDice)
        } footer: {
          LazyVGrid(columns: columns) {
            ForEach(0..<currentResult.rolls.count, id: \.self) { rollNumer in
              Text("\(currentResult.rolls[rollNumer])")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1, contentMode: .fit)
                .foregroundColor(.black)
                .background(.white)
                .cornerRadius(10)
                .shadow(radius: 3)
                .font(.title)
                .padding(5)
            }
          }
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
