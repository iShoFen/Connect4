//
// Created by etudiant on 31/01/2023.
//

import XCTest
@testable import Connect4Lib

class Player_UT: XCTestCase {
    func testInit() throws {
        func expect(initPlayerWithId id: uint64, shouldBeNotNil notNil: Bool) {
            let player = Player(withId: id)

            if !notNil {
                XCTAssertNil(player)
                return
            }

            XCTAssertNotNil(player)
            XCTAssertEqual(id, player?.id)
        }

        expect(initPlayerWithId: 1, shouldBeNotNil: true)
        expect(initPlayerWithId: uint64.max, shouldBeNotNil: true)
        expect(initPlayerWithId: 0, shouldBeNotNil: true)
        expect(initPlayerWithId: uint64.min, shouldBeNotNil: true)
    }

    func testEquals() throws {
        func expect(equalsPlayer player1: Player,
                    andPlayer player2: Player,
                    thatShouldBe equals: Bool) {
            XCTAssertEqual(equals, player1 == player2)
        }

        let player1 = Player(withId: 1)!
        let player2 = Player(withId: 1)!
        expect(equalsPlayer: player1, andPlayer: player2, thatShouldBe: true)

        let player3 = Player(withId: 2)!
        let player4 = Player(withId: 1)!
        expect(equalsPlayer: player3, andPlayer: player4, thatShouldBe: false)
    }

    func testPlayOnColumn() throws {
        func expect(playOnBoard board: Board,
                    withLastMove lastMove: (Int, Int),
                    andThisRule rule: IRule,
                    andShouldReturn column: Int?) {
            let player = Player(withId: 1)!
            let result = player.playOnColumn(onBoard: board, withLastMove: lastMove, withThisRule: rule)

            XCTAssertEqual(column, result)
        }

        var board = Board(withNbRows: 6, andNbColumns: 7)!
        let rule = StandardRule()
        expect(playOnBoard: board, withLastMove: (0, 0), andThisRule: rule, andShouldReturn: nil)
        expect(playOnBoard: board, withLastMove: (5, 4), andThisRule: rule, andShouldReturn: nil)

        let grid = [[nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [2, nil, nil, nil, nil, nil, nil],
                    [2, nil, nil, nil, nil, nil, nil],
                    [1, nil, nil, 1, nil, nil, nil],
                    [1, 1, nil, 2, 2, nil, nil]]
        board = Board(withGrid: grid)!
        expect(playOnBoard: board, withLastMove: (5, 0), andThisRule: rule, andShouldReturn: nil)
    }
}
