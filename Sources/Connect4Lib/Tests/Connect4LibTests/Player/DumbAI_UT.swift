//
// Created by etudiant on 01/02/2023.
//

import XCTest
@testable import Connect4Lib

class DumbAI_UT: XCTestCase {
    func testInit() throws {
        func expect(initDumbAIWithId id: UInt64?, andShouldNotBeNull notNull: Bool) {
            let dumbAI: DumbAI?
            if let id = id {
                dumbAI = DumbAI(withId: id)
            } else {
                dumbAI = DumbAI()
            }

            if !notNull {
                XCTAssertNil(dumbAI)
                return
            }

            XCTAssertNotNil(dumbAI)
            XCTAssertEqual(id ?? 0, dumbAI!.id)
        }

        expect(initDumbAIWithId: 0, andShouldNotBeNull: true)
        expect(initDumbAIWithId: 1, andShouldNotBeNull: false)
        expect(initDumbAIWithId: UInt64.min, andShouldNotBeNull: true)
        expect(initDumbAIWithId: UInt64.max, andShouldNotBeNull: false)
        expect(initDumbAIWithId: nil, andShouldNotBeNull: true)
    }

    func testConvenienceInit() throws {
        let dumbAI = DumbAI()
        XCTAssertEqual(0, dumbAI.id)
    }

    func testEquals() throws {
        let ai1 = DumbAI(withId: 0)!
        let ai2 = DumbAI(withId: 0)!
        XCTAssertEqual(ai1, ai2)
    }

    func testHash() throws {
        let ai1 = DumbAI(withId: 0)!
        let ai2 = DumbAI(withId: 0)!
        XCTAssertEqual(ai1.hashValue, ai2.hashValue)
    }

    func testPlay() throws {
        func expect(playOnBoard board: Board,
                    withLastMove lastMove: (Int, Int),
                    andThisRule rule: IRule,
                    andShouldReturn columns: [Int]?) {
            let dumbAI = DumbAI()
            let result = dumbAI.playOnColumn(onBoard: board, withLastMove: lastMove, withThisRule: rule)

            if let columns = columns {
                XCTAssertTrue(columns.contains(result!))
            } else {
                XCTAssertNil(result)
            }
        }

        var grid = [[nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [1, nil, nil, nil, nil, nil, nil]]
        var board = Board(withGrid: grid)!
        let rule = StandardRule()
        expect(playOnBoard: board, withLastMove: (5, 0), andThisRule: rule, andShouldReturn: [0, 1])

        grid = [[nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, nil, nil, nil, nil],
                [nil, nil, nil, 1, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(playOnBoard: board, withLastMove: (5, 3), andThisRule: rule, andShouldReturn: [2, 3, 4])

        grid = [[1, 2, nil, nil, nil, nil, nil],
                [1, 1, nil, nil, nil, nil, nil],
                [1, 1, nil, nil, nil, nil, nil],
                [2, 1, nil, nil, nil, nil, nil],
                [2, 2, nil, nil, nil, nil, nil],
                [1, 1, nil, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(playOnBoard: board, withLastMove: (0, 0), andThisRule: rule, andShouldReturn: [2])

        grid = [[1, 2, 2, nil, nil, nil, nil],
                [1, 1, 2, nil, nil, nil, nil],
                [1, 1, 2, nil, nil, nil, nil],
                [2, 1, 1, nil, nil, nil, nil],
                [2, 2, 1, nil, nil, nil, nil],
                [1, 1, 1, nil, nil, nil, nil]]
        board = Board(withGrid: grid)!
        expect(playOnBoard: board, withLastMove: (0, 0), andThisRule: rule, andShouldReturn: [3])

        grid = [[1, 2, 2, 1, 1, 2, 2],
                [1, 1, 2, 2, 2, 1, 1],
                [1, 1, 2, 1, 1, 2, 2],
                [2, 1, 1, 2, 2, 1, 1],
                [2, 2, 1, 1, 1, 2, 2],
                [1, 1, 1, 2, 2, 1, 1]]
        board = Board(withGrid: grid)!
        expect(playOnBoard: board, withLastMove: (0, 0), andThisRule: rule, andShouldReturn: nil)
    }
}
