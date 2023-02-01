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

        // file the grid by 6 and 7 of nil
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
