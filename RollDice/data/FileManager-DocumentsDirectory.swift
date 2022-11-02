//
//  FileManager-DocumentsDirectory.swift
//  RollDice
//
//  Created by Beto Toro on 2/11/22.
//

import Foundation

extension FileManager {
  static var documentsDirectory: URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
  }
}
