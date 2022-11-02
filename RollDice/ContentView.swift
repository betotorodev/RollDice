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
  let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
  let savedPaths = FileManager.documentsDirectory.appendingPathComponent("SavedRolls.json")
  @State private var savedResults = [DiceResult]()
  
  @AppStorage("selectedDiceType") var selectedDiceType = 6
  @AppStorage("numberToRoll") var numberToRoll = 4
  
  @State private var currentResult = DiceResult(type: 0, number: 0)
  @State private var stoppedDice = 0
  @State private var feedback = UIImpactFeedbackGenerator(style: .rigid)
  
  func load() {
    if let data = try? Data(contentsOf: savedPaths) {
      if let results = try? JSONDecoder().decode([DiceResult].self, from: data) {
        savedResults = results
      }
    }
  }
  
  func save() {
    if let data = try? JSONEncoder().encode(savedResults) {
      try? data.write(to: savedPaths, options: [.atomic, .completeFileProtection])
    }
  }
  
  func rollDice() {
    currentResult = DiceResult(type: selectedDiceType, number: numberToRoll)
    stoppedDice = -8
  }
  
  func updateDice() {
    guard stoppedDice < currentResult.rolls.count else { return }
    
    for i in stoppedDice..<numberToRoll {
      if i < 0 { continue }
      currentResult.rolls[i] = Int.random(in: 1...selectedDiceType)
      feedback.impactOccurred()
    }
    
    stoppedDice += 1
    
    if stoppedDice == numberToRoll {
      savedResults.insert(currentResult, at: 0)
      save()
    }
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
        .disabled(stoppedDice < currentResult.rolls.count)
        
        if savedResults.isEmpty == false {
          Section("Previous results") {
            ForEach(savedResults) { result in
              VStack(alignment: .leading) {
                Text("\(result.number) x D\(result.type)")
                  .font(.headline)
                Text(result.rolls.map(String.init).joined(separator: ", "))
              }
            }
          }
        }
      }
      .navigationTitle("High Rollers")
      .onReceive(timer) { date in
        updateDice()
      }
      .onAppear(perform: load)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
