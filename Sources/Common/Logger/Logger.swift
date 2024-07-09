//
//  Logger.swift
//  

import ColorizeSwift
import Foundation

enum LogType {
  case info
  case warning
  case error
  case fatal
}

enum Logger {
  static func info(_ message: String) {
    log(message, type: .info)
  }

  static func warning(_ message: String) {
    log(message, type: .warning)
  }

  static func error(_ error: LocalizedError) {
    log(error.localizedDescription, type: .error)
  }

  static func fatal(_ errorMessage: String, file: String = #file, line: Int = #line) -> Never {
    log("\(errorMessage),\n\(file):\(line)", type: .fatal)
    exit(1)
  }
}

private func log(_ message: String, type: LogType) {
  let prefix: String
  switch type {
  case .info:
    prefix = "INFO".foregroundColor(.aqua)
  case .warning:
    prefix = "INFO".foregroundColor(.orange1)
  case .error:
    prefix = "ERROR".foregroundColor(.red)
  case .fatal:
    prefix = "FATAL".foregroundColor(.red)
  }

  print("\(prefix) :: \(message)")
}
