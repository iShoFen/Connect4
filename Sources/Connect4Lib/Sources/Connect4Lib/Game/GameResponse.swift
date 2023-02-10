//
// Created by Samuel on 09/02/2023.
//

import Foundation

/// Initialisation errors
public enum InitialisationError: Error, Equatable {
    /// Unknown error
    case Unknown
    /// Too few rows
    case TooFewRows
    /// Too many rows
    case TooManyRows
    /// Too few columns
    case TooFewColumns
    /// Too many columns
    case TooManyColumns
    /// Board full
    case BoardFull
    /// Invalid player
    case NotEnoughPlayers(expected: Int, actual: Int)
}

/// Playing errors
public enum PlayingError: Error, Equatable {
    /// Unknown error
    case Unknown
    /// Out of bounds
    case OutOfBounds
    /// Column full
    case ColumnFull
    /// Column empty
    case ColumnEmpty
}

/// The game response
public enum GameResponse: Error, Equatable {
    /// Equatable implementation
    public static func ==(lhs: GameResponse, rhs: GameResponse) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }

    /// Unknown response
    case Unknown
    /// Failed response for the rules (initialization)
    case FailedInit(reason: InitialisationError)
    /// Failed response when playing
    case FailedPlays(reason: PlayingError)
    /// Invalid response
    case Added(id: Int, row: Int, column: Int)
    /// Show response
    case Show(board: [[Int?]])
    /// Player turn response
    case PlayerTurn(id: Int)
    /// No winner response
    case NoWinner
    /// Winner response
    case Win(id: Int, at: [(Int, Int)])
}
