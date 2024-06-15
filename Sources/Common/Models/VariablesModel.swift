//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import Foundation

// MARK: - Welcome

struct VariablesModel: Codable {
  let version: String
  let collections: [CollectionElement]
}

// MARK: - CollectionElement

struct CollectionElement: Codable {
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
  let value: ValueUnion

  enum ValueUnion: Codable {
    case integer(Int)
    case string(String)
    case value(Value)

    init(from decoder: Decoder) throws {
      let container = try decoder.singleValueContainer()
      if let value = try? container.decode(Int.self) {
        self = .integer(value)
        return
      }
      if let value = try? container.decode(String.self) {
        self = .string(value)
        return
      }
      if let value = try? container.decode(Value.self) {
        self = .value(value)
        return
      }
      throw DecodingError.typeMismatch(
        ValueUnion.self,
        DecodingError.Context(
          codingPath: decoder.codingPath,
          debugDescription: "Wrong type for ValueUnion"
        )
      )
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.singleValueContainer()
      switch self {
      case let .integer(value):
        try container.encode(value)
      case let .string(value):
        try container.encode(value)
      case let .value(value):
        try container.encode(value)
      }
    }
  }

  // MARK: - Value

  struct Value: Codable {
    let collection: CollectionEnum
    let name: String
  }

  enum CollectionEnum: String, Codable {
    case colorToken = "Color Token"
    case primitives = "Primitives"
  }
}
