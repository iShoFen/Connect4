//
//  Board_UT.swift
//
//
//  Created by Samuel on 18/01/2023.
//

import XCTest
import Power4Lib

final class Board_UT: XCTestCase {

    func testInit() throws {
        
        func expect(initBoardWithNbRows nbRows: Int, andNbColumns nbColumns: Int, shouldBeNotNil notNil: Bool) {
            let board = Board(withNbRows: nbRows, andNbColumns: nbColumns)
            
            if !notNil {
                XCTAssertNil(board)
                return
            }
            XCTAssertNotNil(board)
            XCTAssertEqual(nbRows, board?.nbRows)
            XCTAssertEqual(nbColumns, board?.nbColumns)
            XCTAssertEqual(nbRows, board?.grid.count)
            XCTAssertEqual(nbColumns, board?.grid[0].count)
        }
        
        expect(initBoardWithNbRows: 6, andNbColumns: 7, shouldBeNotNil: true)
        expect(initBoardWithNbRows: 0, andNbColumns: 7, shouldBeNotNil: false)
        expect(initBoardWithNbRows: 6, andNbColumns: 0, shouldBeNotNil: false)
        expect(initBoardWithNbRows: -6, andNbColumns: 7, shouldBeNotNil: false)
        expect(initBoardWithNbRows: 6, andNbColumns: -7, shouldBeNotNil: false)
        expect(initBoardWithNbRows: 0, andNbColumns: 0, shouldBeNotNil: false)
    }

    func testInitWithGrid() throws {
        func expect(initBoardWithGrid grid: [[Int?]], shouldBeNotNil notNil: Bool) {
            let board = Board(withGrid: grid)

            if !notNil {
                XCTAssertNil(board)
                return
            }

            XCTAssertNotNil(board)
            XCTAssertEqual(grid.count, board!.nbRows)
            XCTAssertEqual(grid[0].count, board!.nbColumns)
            XCTAssertEqual(grid, board!.grid)
        }
        expect(initBoardWithGrid: [[1,2,1,2,1,2,1], [1,2,1,2,1,2,1]], shouldBeNotNil: true)
        expect(initBoardWithGrid: [[1,2,nil,2,1,nil,1], [1,nil,nil,nil,1,2,1]], shouldBeNotNil: true)
        expect(initBoardWithGrid: [], shouldBeNotNil: false)
        expect(initBoardWithGrid: [[], []], shouldBeNotNil: false)
        expect(initBoardWithGrid: [[1,2,1,2,1,2,1], [1,2,1,2,1,2]], shouldBeNotNil: false)
    }

    func testDescription() throws {
        let loadBoard = [[1,2,nil,nil], [1,2,3,nil], [3,2,3,2]]
        let board = Board(withGrid: loadBoard)!
        let expectedDescription = "- O - O \nX O - - \nX O - - \n"
        XCTAssertEqual(expectedDescription, board.description)
    }

    func testInsert() throws {
        func expect(insertPieceBy id: Int, atRow row: Int, andAtColumn column: Int, inBoard board: Board, shouldFail fail: FailedReason?) {
            var board = board
            let result = board.insertPiece(by: id, atColumn: column)

            if fail != nil {
                XCTAssertEqual(.failed(reason: fail!), result)
                return
            }

            XCTAssertEqual(.added(id: id, row: row, column: column), result)
        }

        expect(insertPieceBy: 1, atRow: 1, andAtColumn: 1, inBoard: Board(withNbRows: 3, andNbColumns: 2)!, shouldFail: nil)
        expect(insertPieceBy: 1, atRow: 1, andAtColumn: -1, inBoard: Board(withNbRows: 3, andNbColumns: 2)!, shouldFail: .outOfBounds)
        expect(insertPieceBy: 1, atRow: 1, andAtColumn: 0, inBoard: Board(withNbRows: 3, andNbColumns: 2)!, shouldFail: .outOfBounds)
    }
    
}
