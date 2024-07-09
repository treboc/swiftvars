//  Created by Marvin Lee Kobert on 15.06.24.
//  
//

import Foundation
import PathKit

extension Path {
  static let templatesPath = Path(Bundle.module.path(forResource: "templates", ofType: nil) ?? "")
}
