//
// Created by Samuel on 25/01/2023.
//

import Foundation

/// The reason why a board is invalid.
public enum InvalidReason {
    /// The board has too many rows.
    case TooManyRows
    /// The board has too few rows.
    case TooFewRows
    /// The board has too many columns.
    case TooManyColumns
    /// The board has too few columns.
    case TooFewColumns
    /// The last move is invalid.
    case EmptyLastMove
    /// The board is full.
    case BoardFull
    /// The last move did not win the game.
    case NoWinner
}

/// The result of a rule.
public enum RuleResult : Equatable {
    /// Unknown result.
    case unknown
    /// The rule is not applicable.
    case invalid(reason: InvalidReason)
    /// The rule is applicable
    case valid
    /// The rule is applicable and the game is not over.
    case notWon(reason: InvalidReason)
    /// The rule is applicable and the game is over (the player won).
    case won(id: Int, at: [[Int?]])
}
