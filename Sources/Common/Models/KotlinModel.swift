//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

struct KotlinModel {
  let version: String
  let colorTokens: [ColorToken]
  let colorValues: [ColorValue]
  let radii: [Radius]
  let spacings: [Spacing]
  
  struct Radius {
    let varName: String
    let radius: Int
  }

  struct Spacing {
    let varName: String
    let spacing: Int
  }
}

struct ColorToken {
  let varName: String
  let colorName: String
}

struct ColorValue {
  let varName: String
  let hexValue: String
}
