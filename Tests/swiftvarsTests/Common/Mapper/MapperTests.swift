//  Created by Marvin Lee Kobert on 15.06.24.
//  
//

import Testing
@testable import swiftvars

struct MapperTests {
  @Suite("Kotlin Mapper Tests")
  struct KotlinMapperTests {
    let sut = Mapper(validator: Validator(), platform: .kotlin)

    @Test
    func toColorTokenWithStringValue() throws {
      // Given
      let variable = Variable(name: "primaryColor", value: .stringValue("red"))
      let colorMode = ColorMode.light

      // When
      let colorToken = try sut.toColorToken(variable, colorMode: colorMode)

      // Then
      #expect(colorToken.varName == "PrimaryColor")
      #expect(colorToken.colorName == "Red")
      #expect(colorToken.colorMode == colorMode)
    }

    @Test
    func toColorTokenWithValuePrimitivesCollection() throws {
      // Given
      let value = Variable.ValueObject(collection: .primitives, name: "blue")
      let variable = Variable(name: "SecondaryColor", value: .objectValue(value))
      let colorMode = ColorMode.dark

      // When
      let colorToken = try sut.toColorToken(variable, colorMode: colorMode)

      // Then
      #expect(colorToken.varName == "SecondaryColor")
      #expect(colorToken.colorName == "Blue")
      #expect(colorToken.colorMode == colorMode)
    }

    @Test
    func toColorTokenWithIntegerValue() throws {
      // Given
      let variable = Variable(name: "invalidColor", value: .numberValue(123))
      let colorMode = ColorMode.light

      // When
      #expect(throws: MappingError.invalidValue(String(describing: Variable.Value.numberValue(123)))) {
        try sut.toColorToken(variable, colorMode: colorMode)
      }
    }

    @Test
    func toColorTokenWithNonPrimitivesCollection() throws {
      // Given
      let value = Variable.ValueObject(collection: .colorToken, name: "blue")
      let variable = Variable(name: "secondaryColor", value: .objectValue(value))
      let colorMode = ColorMode.dark

      // When
      #expect(throws: MappingError.invalidCollection(value.collection?.rawValue)) {
        try sut.toColorToken(variable, colorMode: colorMode)
      }
    }

    @Test
    func toColorTokenWithEmptyString() throws {
      // Given
      let variable = Variable(name: "emptyColor", value: .stringValue(""))
      let colorMode = ColorMode.light

      // When
      #expect(throws: MappingError.noColorName) {
        try sut.toColorToken(variable, colorMode: colorMode)
      }
    }

    @Test
    func toColorTokenVariableNameIsUpperCameplCase() throws {
      // Given
      let input = "button/secondary+text/button-background-secondary-disabled"

      // When
      let result = sut.colorTokenVariableName(from: input)

      // Then
      #expect(result == "ButtonBackgroundSecondaryDisabled")
    }

    @Test
    func toColorTokenColorNameIsUpperCase() throws {
      // Given
      let input = "color/brand-primary/purple/050"

      // When
      let result = sut.colorTokenColorName(from: input)

      // Then
      #expect(result == "ColorBrandPrimaryPurple050")
    }

    @Test
    func radiusVariableNameIsUpperCamelCase() throws {
      // Given
      let input = "radius-32"

      // When
      let result = sut.radiusVariableName(from: input)

      // Then
      #expect(result == "Radius32")
    }

    func spacingVariableNameIsUpperCamelCase() throws {
      // Given
      let input = "spacing-32"

      // When
      let result = sut.spacingVariableName(from: input)

      // Then
      #expect(result == "Spacing32")
    }
  }

  @Suite("Swift Mapper Tests")
  struct SwiftMapperTests {
    let sut = Mapper(validator: Validator(), platform: .swift)

    @Test
    func toColorTokenWithStringValue() throws {
      // Given
      let variable = Variable(name: "primaryColor", value: .stringValue("red"))
      let colorMode = ColorMode.light

      // When
      let colorToken = try sut.toColorToken(variable, colorMode: colorMode)

      // Then
      #expect(colorToken.varName == "primaryColor")
      #expect(colorToken.colorName == "red")
      #expect(colorToken.colorMode == colorMode)
    }

    @Test
    func toColorTokenWithValuePrimitivesCollection() throws {
      // Given
      let value = Variable.ValueObject(collection: .primitives, name: "blue")
      let variable = Variable(name: "SecondaryColor", value: .objectValue(value))
      let colorMode = ColorMode.dark

      // When
      let colorToken = try sut.toColorToken(variable, colorMode: colorMode)

      // Then
      #expect(colorToken.varName == "secondaryColor")
      #expect(colorToken.colorName == "blue")
      #expect(colorToken.colorMode == colorMode)
    }

    @Test
    func toColorTokenWithIntegerValue() throws {
      // Given
      let variable = Variable(name: "invalidColor", value: .numberValue(123))
      let colorMode = ColorMode.light

      // When
      #expect(throws: MappingError.invalidValue(String(describing: Variable.Value.numberValue(123)))) {
        try sut.toColorToken(variable, colorMode: colorMode)
      }
    }

    @Test
    func toColorTokenWithNonPrimitivesCollection() throws {
      // Given
      let value = Variable.ValueObject(collection: .colorToken, name: "blue")
      let variable = Variable(name: "secondaryColor", value: .objectValue(value))
      let colorMode = ColorMode.dark

      // When
      #expect(throws: MappingError.invalidCollection(value.collection?.rawValue)) {
        try sut.toColorToken(variable, colorMode: colorMode)
      }
    }

    @Test
    func toColorTokenWithEmptyString() throws {
      // Given
      let variable = Variable(name: "emptyColor", value: .stringValue(""))
      let colorMode = ColorMode.light

      // When
      #expect(throws: MappingError.noColorName) {
        try sut.toColorToken(variable, colorMode: colorMode)
      }
    }

    @Test
    func toColorTokenVariableNameIsLowerCamelCase() throws {
      // Given
      let input = "button/secondary+text/button-background-secondary-disabled"

      // When
      let result = sut.colorTokenVariableName(from: input)

      // Then
      #expect(result == "buttonBackgroundSecondaryDisabled")
    }

    @Test
    func toColorTokenColorNameIsLowerCamelCase() throws {
      // Given
      let input = "color/brand-primary/purple/050"

      // When
      let result = sut.colorTokenColorName(from: input)

      // Then
      #expect(result == "colorBrandPrimaryPurple050")
    }

    @Test
    func radiusVariableNameIsLowerCamelCase() throws {
      // Given
      let input = "radius-32"

      // When
      let result = sut.radiusVariableName(from: input)

      // Then
      #expect(result == "radius32")
    }

    func spacingVariableNameIsLowerCamelCase() throws {
      // Given
      let input = "spacing-32"

      // When
      let result = sut.spacingVariableName(from: input)

      // Then
      #expect(result == "spacing32")
    }
  }

  @Suite("Mapping Error Tests")
  struct MappingErrorTests {
    static let equalArguments: [(MappingError, MappingError)] = [
      (MappingError.invalidValue("123"), MappingError.invalidValue("123")),
      (MappingError.invalidCollection("Collection1"), MappingError.invalidCollection("Collection1")),
      (MappingError.noColorName, MappingError.noColorName),
      (MappingError.noColorModeName("unexpected"), MappingError.noColorModeName("unexpected")),
      (MappingError.noRadiusValue, MappingError.noRadiusValue),
      (MappingError.noSpacings, MappingError.noSpacings)
    ]

    static let descriptionArguments: [(MappingError, String)] = [
      (MappingError.invalidValue(123.description), "Invalid value: 123"),
      (MappingError.invalidCollection("nonPrimitiveCollection"), "Invalid collection: nonPrimitiveCollection"),
      (MappingError.noColorName, "Unable to get colorName from value"),
      (MappingError.noColorModeName("unexpected"), "Unable to get colorModeName from value, found: unexpected, expected: light/dark"),
      (MappingError.noRadiusValue, "Unable to get radiusValue from value"),
      (MappingError.noSpacings, "No spacings found")
      ]

    @Test("Equality Test", arguments: equalArguments)
    func equality(lhs: MappingError, rhs: MappingError) {
      #expect(lhs == rhs)
    }

    @Test("Description Test", arguments: descriptionArguments)
    func description(error: MappingError, description: String) {
      #expect(error.description == description)
    }
  }
}
