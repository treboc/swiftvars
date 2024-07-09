//  Created by Marvin Lee Kobert on 15.06.24.
//  Copyright © 2024 Marvin Lee Kobert. All rights reserved.
//

import ArgumentParser

enum PlatformArgument: String, EnumerableFlag {
  case swift
  case kotlin

  var displayName: String {
    self.rawValue.capitalized
  }
}

extension PlatformArgument {
  static var help: ArgumentHelp {
    ArgumentHelp(
      "The platform to generate code for"
    )
  }

  static var defaultCompletionKind: CompletionKind {
    .list(PlatformArgument.allCases.map(\.displayName))
  }
}
