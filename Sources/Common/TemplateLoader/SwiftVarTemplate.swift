//  Created by Marvin Lee Kobert on 16.06.24.
//
//

import Foundation

private let kKotlinFileExtension = ".kt"
private let kSwiftFileExtension = ".swift"

enum SwiftVarTemplate {
  case kotlinThemeFile
  case swiftBaseFile
  case swiftColorsFile
  case swiftColorValuesFile
  case swiftRadiusFile
  case swiftSpacingFile

  var templateFileName: String {
    filename
  }

  var outputFileName: String {
    switch self {
    case .kotlinThemeFile:
      filename + kKotlinFileExtension
    case .swiftBaseFile, .swiftColorValuesFile, .swiftColorsFile, .swiftRadiusFile, .swiftSpacingFile:
      filename + kSwiftFileExtension
    }
  }

  var templateString: String {
    switch self {
    case .kotlinThemeFile:
      Self.kotlinThemeFileTemplate
    case .swiftBaseFile:
      Self.swiftBaseFileTemplate
    case .swiftColorsFile:
      Self.swiftColorsFileTemplate
    case .swiftColorValuesFile:
      Self.swiftColorValuesFileTemplate
    case .swiftRadiusFile:
      Self.swiftRadiusFileTemplate
    case .swiftSpacingFile:
      Self.swiftSpacingFileTemplate
    }
  }

  private var filename: String {
    switch self {
    case .kotlinThemeFile, .swiftBaseFile:
      "UITheme"
    case .swiftColorsFile:
      "UITheme+Colors"
    case .swiftColorValuesFile:
      "UITheme+ColorValues"
    case .swiftRadiusFile:
      "UITheme+Radius"
    case .swiftSpacingFile:
      "UITheme+Spacing"
    }
  }
}

private extension SwiftVarTemplate {
  static var kotlinThemeFileTemplate: String {
    """
    //
    // Generated by SwiftVars
    // Variables Version {{ version }}
    //

    package {{ packageName }}

    object UITheme {
        object Color {
            object Colors {
                {%- if darkColorToken.count > 0 %}
                object DarkMode {
                    {% for colorToken in darkColorToken -%}
                    val {{ colorToken.varName }} = RawColors.{{ colorToken.colorName }}
                    {% endfor %}
                }
                {% endif %}

                {%- if lightColorToken.count > 0 %}
                object LightMode {
                    {% for colorToken in lightColorToken -%}
                    val {{ colorToken.varName }} = RawColors.{{ colorToken.colorName }}
                    {% endfor %}
                }
                {% endif %}
            }

            object RawColors {
                {% for rawColor in rawColors -%}
                val {{ rawColor.varName }} = Color({{ rawColor.hexValue }})
                {% endfor %}
            }
        }

        object Dimension {
            // Spacings
            {% for spacing in spacings -%}
            val {{ spacing.varName }}: Dp = {{ spacing.spacing }}.dp
            {% endfor %}

            // Radii
            {% for radius in radii -%}
            val {{ radius.varName }}: Dp = {{ radius.radius }}.dp
            {% endfor %}
        }
    }
    """
  }

  static var swiftBaseFileTemplate: String {
    """
    //
    // Generated by SwiftVars
    // Variables Version {{ version }}
    //

    import Foundation

    public enum UITheme {}
    """
  }

  static var swiftColorsFileTemplate: String {
    """
    //
    // Generated by SwiftVars
    // Variables Version {{ version }}
    //

    import SwiftUI

    public extension Color {
    {% for color in colors %}
    static let {{ color.varName }} = Color(hex: UITheme.{{ color.colorName }})
    {% endfor %}
    }

    public extension Color {
        init(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

            var rgb: UInt64 = 0

            var red = 0.0
            var green = 0.0
            var blue = 0.0
            var opacity = 1.0

            let length = hexSanitized.count

            guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
                fatalError()
            }

            if length == 6 {
                red = Double((rgb & 0xFF0000) >> 16) / 255.0
                green = Double((rgb & 0x00FF00) >> 8) / 255.0
                blue = Double(rgb & 0x0000FF) / 255.0

            } else if length == 8 {
                red = Double((rgb & 0xFF00_0000) >> 24) / 255.0
                green = Double((rgb & 0x00FF_0000) >> 16) / 255.0
                blue = Double((rgb & 0x0000_FF00) >> 8) / 255.0
                opacity = Double(rgb & 0x0000_00FF) / 255.0

            } else {
                fatalError()
            }

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
        }
    }
    """
  }

  static var swiftColorValuesFileTemplate: String {
    """
    //
    // Generated by SwiftVars
    // Variables Version {{ version }}
    //

    import Foundation

    public extension UITheme {
        {% for color in colors %}
        static let {{ color.varName }}: String = "{{ color.hexValue }}"
        {% endfor %}
    }
    """
  }

  static var swiftRadiusFileTemplate: String {
    """
    //
    // Generated by SwiftVars
    // Variables Version {{ version }}
    //

    import SwiftUI

    public extension UITheme {
        {% for radius in radii %}
        static let {{ radius.varName }}: Double = {{ radius.radius }}
        {% endfor %}
    }
    """
  }

  static var swiftSpacingFileTemplate: String {
    """
    //
    // Generated by SwiftVars
    // Variables Version {{ version }}
    //

    import SwiftUI

    public extension UITheme {
        {% for spacing in spacings %}
        static let {{ spacing.varName }}: Double = {{ spacing.spacing }}
        {% endfor %}
    }
    """
  }
}
