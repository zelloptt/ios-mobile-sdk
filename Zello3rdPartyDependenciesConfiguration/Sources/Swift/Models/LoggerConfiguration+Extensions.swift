import Utility
import CocoaLumberjack

extension DDLogMessage {
  var asZLogMessage: ZLogMessage {
    ZLogMessage(
      flag: flag.asZLogFlag,
      timestamp: timestamp,
      message: message,
      messageFormat: messageFormat,
      level: level.asZLogLevel,
      context: context,
      file: file,
      fileName: fileName,
      function: function,
      line: line,
      representedObject: representedObject,
      options: options.asZLogMessageOptions,
      threadID: threadID,
      threadName: threadName,
      queueLabel: queueLabel,
      qos: qos
    )
  }
}

extension DDLogFlag {
  var asZLogFlag: ZLogFlag {
    switch self {
    case .error:
        .error
    case .warning:
        .warning
    case .info:
        .info
    case .debug:
        .debug
    case .verbose:
        .verbose
    default:
        .verbose
    }
  }
}

extension DDLogLevel {
  var asZLogLevel: ZLogLevel {
    switch self {
    case .off:
        .off
    case .error:
        .error
    case .warning:
        .warning
    case .info:
        .info
    case .debug:
        .debug
    case .verbose:
        .verbose
    case .all:
        .all
    @unknown default:
        .all
    }
  }
}

extension DDLogMessageOptions {
  var asZLogMessageOptions: ZLogMessageOptions {
    switch self {
    case .copyFile:
        .copyFile
    case .copyFunction:
        .copyFunction
    case .dontCopyMessage:
        .dontCopyMessage
    default:
        .copyFile
    }
  }
}

extension ZLogMessage {
  /// We need to use this init as we need to manually fill all values of the DDLogMessage
  /// with data from our ZLogMessage. The non deprecated init assumes we will not use
  /// DDLogMessage outside CLJ non public code. This is safe to use.
  var asDDLogMessage: DDLogMessage {
    DDLogMessage(
      message: message,
      level: level.asLogLevel,
      flag: flag.asLogFlag,
      context: context,
      file: file,
      function: function,
      line: line,
      tag: nil,
      options: options.asDDLogMessageOptions,
      timestamp: timestamp
    )
  }
}

extension ZLogLevel {
  var asLogLevel: DDLogLevel {
    switch self {
    case .off:
        .off
    case .error:
        .error
    case .warning:
        .warning
    case .info:
        .info
    case .debug:
        .debug
    case .verbose:
        .verbose
    case .all:
        .all
    @unknown default:
        .all
    }
  }
}

extension ZLogFlag {
  var asLogFlag: DDLogFlag {
    switch self {
    case .error:
        .error
    case .warning:
        .warning
    case .info:
        .info
    case .debug:
        .debug
    case .verbose:
        .verbose
    @unknown default:
      fatalError("We need to handle all ZLogFlag cases")
    }
  }
}

extension ZLogMessageOptions {
  var asDDLogMessageOptions: DDLogMessageOptions {
    switch self {
    case .copyFile:
        .copyFile
    case .copyFunction:
        .copyFunction
    case .dontCopyMessage:
        .dontCopyMessage
    @unknown default:
      fatalError("We need to handle all ZLogMessageOptions cases")
    }
  }
}
