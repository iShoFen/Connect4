//
// Created by Samuel on 09/02/2023.
//

import Foundation

/// Extension of the GameResponse enum
extension FailedReason {
    /// Convert a failed reason to a board error
    ///
    /// - Returns: The board error.
    internal func toPlayingError() -> PlayingError {
        switch self {
        case .Unknown:
            return .Unknown
        case .OutOfBounds:
            return .OutOfBounds
        case .ColumnFull:
            return .ColumnFull
        case .ColumnEmpty:
            return .ColumnEmpty
        }
    }
}

/// Extension of the GameResponse enum
extension InvalidReason {
    /// Convert an invalid reason to a rule error
    ///
    /// - Returns: The rule error.
    ///
    /// - Note: This function will crash if the invalid reason is not a rule error.
    internal func toInitError() -> InitialisationError {
        switch self {
        case .Unknown:
            return .Unknown
        case .TooFewRows:
            return .TooFewRows
        case .TooManyRows:
            return .TooManyRows
        case .TooFewColumns:
            return .TooFewColumns
        case .TooManyColumns:
            return .TooManyColumns
        case .BoardFull:
            return .BoardFull
        default: preconditionFailure("Invalid reason \(self) is not a rule error")
        }
    }
}

