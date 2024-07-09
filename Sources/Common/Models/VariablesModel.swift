//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

// MARK: - Welcome

struct VariablesModel: Codable {
  let version: String
  let collections: [Collection]
}

// MARK: - Collection

struct Collection: Codable {
  let name: String
  let modes: [Mode]
}

// MARK: - Mode

struct Mode: Codable {
  let name: String
  let variables: [Variable]
}

// MARK: - Variable

struct Variable: Codable {
  let name: String
  let value: Value

  enum Value: Codable {
    case stringValue(String)
    case numberValue(Int)
    case objectValue(ValueObject)

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let stringValue = try? container.decode(String.self) {
        self = .stringValue(stringValue)
      } else if let numberValue = try? container.decode(Int.self) {
        self = .numberValue(numberValue)
      } else if let objectValue = try? container.decode(ValueObject.self) {
        self = .objectValue(objectValue)
      } else {
        throw DecodingError.typeMismatch(
          ValueObject.self,
          DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "Wrong type for VariableValue"
          )
        )
      }
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .stringValue(let stringValue):
        try container.encode(stringValue)
      case .numberValue(let numberValue):
        try container.encode(numberValue)
      case .objectValue(let objectValue):
        try container.encode(objectValue)
      }
    }
  }

  struct ColorTokenValue: Codable {
    let collection: CollectionEnum
    let name: String
  }

  struct ValueObject: Codable {
    let collection: CollectionEnum?
    let name: String?
    let fontSize: Int?
    let fontFamily: String?
    let fontWeight: String?
    let lineHeight: LineHeight?
    let lineHeightUnit: String?
    let letterSpacing: Int?
    let letterSpacingUnit: String?
    let textCase: String?
    let textDecoration: String?
    let effects: [Effect]?
    let layoutGrids: [LayoutGrid]?
    let color: RGBA?
    let offset: Offset?
    let radius: Int?
    let spread: Int?

    init(
      collection: CollectionEnum? = nil,
      name: String? = nil,
      fontSize: Int? = nil,
      fontFamily: String? = nil,
      fontWeight: String? = nil,
      lineHeight: LineHeight? = nil,
      lineHeightUnit: String? = nil,
      letterSpacing: Int? = nil,
      letterSpacingUnit: String? = nil,
      textCase: String? = nil,
      textDecoration: String? = nil,
      effects: [Effect]? = nil,
      layoutGrids: [LayoutGrid]? = nil,
      color: RGBA? = nil,
      offset: Offset? = nil,
      radius: Int? = nil,
      spread: Int? = nil
    ) {
      self.collection = collection
      self.name = name
      self.fontSize = fontSize
      self.fontFamily = fontFamily
      self.fontWeight = fontWeight
      self.lineHeight = lineHeight
      self.lineHeightUnit = lineHeightUnit
      self.letterSpacing = letterSpacing
      self.letterSpacingUnit = letterSpacingUnit
      self.textCase = textCase
      self.textDecoration = textDecoration
      self.effects = effects
      self.layoutGrids = layoutGrids
      self.color = color
      self.offset = offset
      self.radius = radius
      self.spread = spread
    }
  }

  // MARK: - EffectValue
  struct EffectValue: Codable {
    let effects: [Effect]
  }

  // MARK: - Effect
  struct Effect: Codable {
    let type: String
    let color: RGBA
    let offset: Offset
    let radius: Int
    let spread: Int
  }

  // MARK: - RGBA
  struct RGBA: Codable {
    let r: Int
    let g: Int
    let b: Int
    let a: Double
  }

  // MARK: - Offset
  struct Offset: Codable {
    let x: Int
    let y: Int
  }

  // MARK: - GridValue
  struct GridValue: Codable {
    let layoutGrids: [LayoutGrid]
  }

  // MARK: - LayoutGrid
  struct LayoutGrid: Codable {
    let pattern: String
    let color: RGBA
    let alignment: String
    let gutterSize: Int
    let offset: Int
    let count: Int
  }

  enum LineHeight: Codable {
    case double(Double)
    case string(String)

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let doubleValue = try? container.decode(Double.self) {
        self = .double(doubleValue)
      } else if let stringValue = try? container.decode(String.self) {
        self = .string(stringValue)
      } else {
        throw DecodingError.typeMismatch(
          LineHeight.self,
          DecodingError.Context(
            codingPath: decoder.codingPath,
            debugDescription: "LineHeight value cannot be decoded"
          )
        )
      }
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case .double(let doubleValue):
        try container.encode(doubleValue)
      case .string(let stringValue):
        try container.encode(stringValue)
      }
    }
  }

  enum CollectionEnum: String, Codable {
    case colorToken = "Color Token"
    case primitives = "Primitives"
  }
}
