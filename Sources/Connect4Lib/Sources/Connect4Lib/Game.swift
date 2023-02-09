//
// Created by Samuel on 08/02/2023.
//

import Foundation

/// The game is the main class of the library. It is used to create a game and to start it.
struct Game {

    /// The board of the game
    public var board: Board

    /// The rule of the game
    public let rule: IRule

    /// The players of the game
    public let players: [Player: Int]

    /// The current player
    private var currentPlayer: Player

    /// The last move played
    private var lastMove: (row: Int, column: Int) = (-1, -1)

    /// The display function
    private let display: (String) -> Void

    /// Create a game with a board, a rule, players and a display function
    ///
    /// - Parameters:
    ///   - board: The board of the game
    ///   - rule: The rule of the game
    ///   - players: The players of the game
    ///   - display: The display function
    public init?(withBoard board: Board, andRule rule: IRule, withPlayers players: [Player], andDisplay display: @escaping (String) -> Void) {
        guard (rule.isValid(board: board) == .valid) else {
            return nil
        }

        guard (players.count > 1) else {
            return nil
        }

        self.players = Dictionary(uniqueKeysWithValues: players.enumerated().map { ($1, $0 + 1) })
        self.board = board
        self.rule = rule
        self.display = display

        currentPlayer = self.players.keys.randomElement()!
    }

    /// Create a game with a rule, players and a display function
    ///
    /// - Parameters:
    ///   - rule: The rule of the game
    ///   - players: The players of the game
    ///   - display: The display function
    public init?(withRule rule: IRule, andPlayers players: [Player], withDisplay display: @escaping (String) -> Void) {
        self.init(withBoard: rule.createBoard(), andRule: rule, withPlayers: players, andDisplay: display)
    }

    /// Reset the game
    public mutating func resetGame() {
        board = rule.createBoard()
        currentPlayer = players.keys.randomElement()!
    }

    /// Try to play a move
    /// If the move is valid, the game state is updated
    /// If the move is not valid, the player is asked to play again
    private mutating func play() {
        var validMove = false
        repeat {
            let column = currentPlayer.playOnColumn(onBoard: board, withLastMove: lastMove, withThisRule: rule)

            if let column {
                validMove = validateMove(onColumn: column)
            } else {
                display("No column selected")
            }

        } while !validMove
    }

    /// Play the game
    ///
    /// - Parameter column: The column to play on
    /// - Returns: True if the piece was added, false otherwise
    private mutating func validateMove(onColumn column: Int) -> Bool {
        let result = board.insertPiece(by: players[currentPlayer]!, atColumn: column)
        switch result {
            case let .added(id, row, column):
                lastMove = (row, column)
                display("Piece \(id) added at row \(row) and column \(column)")
                return true
            case let .failed(reason):
                display("Failed to add piece: \(reason)")
            default: break
        }

        return false
    }

    /// Validate the game state
    ///
    /// - Parameter result: The result of the game
    /// - Returns: True if the game is over, false otherwise
    private func validateGameState(withResult result: RuleResult) -> Bool {
        switch result {
            case let .won(player, winingIndexes):
                display("Player \(player + 1) won")
                display("Wining indexes: \(winingIndexes)")
                return true
            case let .notWon(reason):
                if reason == .BoardFull {
                    display("Board full, party is over")
                    return true
                }
            default: break
        }

        return false
    }

    /// Start the game
    /// Play the game until it's over
    /// Display the result of the game with the display function
    public mutating func start() {
        var isOver = false
        while !isOver {
            display(board.description)
            display("Player \(players[currentPlayer]!) turn")
            play()
            let result = rule.isGameOver(onBoard: board, withLastMove: lastMove)
            isOver = validateGameState(withResult: result)
        }
    }
}
