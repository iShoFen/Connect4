//
// Created by etudiant on 25/01/2023.
//

import Foundation

public struct StandardRule : IRule {
    public let minRow: Int = 6

    public let maxRow: Int = 6

    public let minColumn: Int = 7

    public let maxColumn: Int = 7

    public let nbPiecesToWin: Int = 4

    public let isDiagonalWinAllowed: Bool = true

    public func isValid(board: Board) -> RuleResult {
        guard board.nbRows >= minRow || board.nbRows <= maxRow  else {
            return .invalid
        }

        guard board.nbColumns >= minColumn || board.nbColumns <= maxColumn else {
            return .invalid
        }

        return .valid
    }

    public func isGameOver(board: Board) -> RuleResult {
        return .unknown
    }


}
