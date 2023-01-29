//
// Created by etudiant on 25/01/2023.
//

import Foundation

/// A rule is a set of rules that define the game.
/// It defines the number of rows, columns, the number of pieces to win, and if diagonal wins are allowed.
public protocol IRule {

    /// The minimum number of rows.
    var minRow: Int { get }

    /// The maximum number of rows.
    var maxRow: Int { get }

    /// The minimum number of columns.
    var minColumn: Int { get }

    /// The maximum number of columns.
    var maxColumn: Int { get }

    /// The number of pieces to win.
    var nbPiecesToWin: Int { get }

    /// If diagonal wins are allowed.
    var isDiagonalWinAllowed: Bool { get }

    /// Check if the board is valid.
    ///
    /// - Parameter board: The board to check.
    /// - Returns: A `RuleResult` indicating if the board is valid.
    ///
    /// - Note: A board is valid if it has the correct number of rows and columns.
    func isValid(board: Board) -> RuleResult
    func isGameOver(board: Board) -> RuleResult
}
