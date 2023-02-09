//
// Created by Samuel on 25/01/2023.
//

import Foundation

/// A rule is a set of rules that define the game.
/// It defines the number of rows, columns, the number of pieces to win, and if diagonal wins are allowed.
public protocol IRule {

    /// The minimum number of rows.
    var row: Int { get }

    /// The minimum number of columns.
    var column: Int { get }

    /// The number of pieces to win.
    var nbPiecesToWin: Int { get }

    /// If diagonal wins are allowed.
    var isDiagonalWinAllowed: Bool { get }

    /// Create a board.
    ///
    /// - Returns: A new board with the correct number of rows and columns.
    func createBoard() -> Board

    /// Check if the board is valid.
    ///
    /// - Parameter board: The board to check.
    /// - Returns: A `RuleResult` indicating if the board is valid.
    ///
    /// - Note: A board is valid if it has the correct number of rows and columns.
    func isValid(board: Board) -> RuleResult

    /// Check if the game is over.
    ///
    /// - Parameters:
    ///   - board: The board to check.
    ///   - lastMove: The last move made on the board.
    ///
    /// - Returns: A `RuleResult` indicating if the game is over.
    ///
    /// - Note: A game is over if there is a winner or if the board is full.
    func isGameOver(onBoard board: Board, withLastMove lastMove: (row: Int, column: Int)) -> RuleResult
}
