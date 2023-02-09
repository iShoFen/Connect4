//
// Created by etudiant on 09/02/2023.
//

import XCTest
@testable import Connect4Lib

final class Game_UT: XCTestCase {
    public func testInitWithBoard() {
        func expected(withBoard board: Board,
                      andRule rule: IRule,
                      withPlayers players: [Player],
                      andDisplay display: @escaping (String) -> Void,
                      _ toBeNil: Bool) {
            if toBeNil {
                XCTAssertNil(Game(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display))
            } else {
                var game = Game(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display)
                XCTAssertNotNil(game)

                XCTAssertEqual(game!.board, board)
                XCTAssertTrue(type(of: rule) == type(of: game!.rule))
                XCTAssertEqual(game!.players, Dictionary(uniqueKeysWithValues: players.enumerated().map { ($1, $0 + 1) }))
            }
        }

        var board = Board(withNbRows: 6, andNbColumns: 7)!
        let rule = StandardRule()
        var players = [Player(withId: 1)!, Player(withId: 2)!]
        let display: (String) -> Void = { _ in }
        expected(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, false)

        board = Board(withNbRows: 1, andNbColumns: 7)!
        expected(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, true)

        board = Board(withNbRows: 6, andNbColumns: 1)!
        expected(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, true)

        players = []
        expected(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display, true)
    }

    public func testInitWithRule() {
        func expected(gameWithRule rule: IRule,
                      withPlayers players: [Player],
                      andDisplay display: @escaping (String) -> Void,
                      _ toBeNil: Bool,
                      andShouldInitBoardLike board: Board? = nil) {
            if toBeNil {
                XCTAssertNil(Game(withRule: rule, andPlayers: players, withDisplay: display))
            } else {
                var game = Game(withRule: rule, andPlayers: players, withDisplay: display)
                XCTAssertNotNil(game)

                XCTAssertTrue(type(of: rule) == type(of: game!.rule))
                XCTAssertEqual(game!.players, Dictionary(uniqueKeysWithValues: players.enumerated().map { ($1, $0 + 1) }))
                if let board = board {
                    XCTAssertEqual(game!.board, board)
                }
            }
        }

        let rule = StandardRule()
        var players = [Player(withId: 1)!, Player(withId: 2)!]
        let display: (String) -> Void = { _ in }
        expected(gameWithRule: rule, withPlayers: players, andDisplay: display, false, andShouldInitBoardLike: rule.createBoard())

        players = []
        expected(gameWithRule: rule, withPlayers: players, andDisplay: display, true)
    }

    public func testResetGame() {
        let rule = StandardRule()
        let players = [Player(withId: 1)!, Player(withId: 2)!]
        let display: (String) -> Void = { _ in }

        let grid = [[0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0],
                    [0, 0, 0, 0, 0, 0, 0]]
        let board = Board(withGrid: grid)!

        var game = Game(withBoard: board, andRule: rule, withPlayers: players, andDisplay: display)!
        XCTAssertEqual(board, game.board)

        game.resetGame()
        XCTAssertEqual(rule.createBoard(), game.board)
    }
}
