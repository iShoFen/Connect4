//
// Created by Samuel on 22/01/2023.
//

import Foundation

/// A human player.
public class  Human : Player, Equatable {
    /// The player's pseudo.
    public var pseudo: String

    /// The scanner to use.
    private let scanner: () -> String

    /// Compares two human players.
    ///
    /// - Parameters:
    ///   - lhs: The first player.
    ///   - rhs: The second player.
    ///
    /// - Returns: `true` if the two players are equal, `false` otherwise.
    public static func ==(lhs: Human, rhs: Human) -> Bool {
        lhs.id == rhs.id
    }

    /// Creates a new human player.
    ///
    /// - Parameters:
    ///   - id: The player's id.
    ///   - playingId: The player's playing id.
    ///   - pseudo: The player's pseudo.
    ///   - scanner: The scanner to use.
    public init?(withId id: uint64,
                 andPseudo pseudo: String = "Player",
                 andScanner scanner: @escaping () -> String) {
        guard id > 0 else {
            return nil
        }

        guard !pseudo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return nil
        }

        self.pseudo = pseudo
        self.scanner = scanner
        super.init(withId: id)
    }

    /// Play on a board.
    ///
    /// - Parameters:
    ///   - board: The board to play on.
    ///   - column: The column to play on.
    ///   - lastMove: The last move played on the board.
    ///   - rule: The rule to apply.
    ///
    /// - Returns: The column to play on.
    ///
    /// - Note: Ask the player to enter a column.
    override public func playOnColumn(onBoard board: Board,
                              withLastMove lastMove: (row: Int, column: Int),
                              withThisRule rule: IRule) -> Int? {
        guard let column = Int(scanner()) else {
            return nil
        }

        return column
    }
}
