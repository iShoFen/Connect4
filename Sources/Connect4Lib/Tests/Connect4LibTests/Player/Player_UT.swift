//
// Created by etudiant on 31/01/2023.
//

import XCTest
@testable import Connect4Lib

class Player_UT: XCTestCase {
    func testInit() throws {
        func expect(initPlayerWithId id: Int, andPlayingId playingId: Int, shouldBeNotNil notNil: Bool) {
            let player = Player(withId: id, andPlayingId: playingId)

            if !notNil {
                XCTAssertNil(player)
                return
            }

            XCTAssertNotNil(player)
            XCTAssertEqual(id, player?.id)
            XCTAssertEqual(playingId, player?.playingId)
        }

        expect(initPlayerWithId: 1, andPlayingId: 1, shouldBeNotNil: true)
        expect(initPlayerWithId: Int.max, andPlayingId: 1, shouldBeNotNil: true)
        expect(initPlayerWithId: 0, andPlayingId: 1, shouldBeNotNil: false)
        expect(initPlayerWithId: -1, andPlayingId: 1, shouldBeNotNil: false)
        expect(initPlayerWithId: Int.min, andPlayingId: 1, shouldBeNotNil: false)
        expect(initPlayerWithId: 1, andPlayingId: 0, shouldBeNotNil: false)
        expect(initPlayerWithId: 1, andPlayingId: -1, shouldBeNotNil: false)
        expect(initPlayerWithId: 1, andPlayingId: Int.min, shouldBeNotNil: false)
        expect(initPlayerWithId: 1, andPlayingId: Int.max, shouldBeNotNil: true)
    }

    func testPlay() throws {
        func expect(playOnBoard board: Board, onColumn col: Int, withLastMove lastMove: (Int, Int), andShouldReturn result: BoardResult) {
            let player = Player(withId: 1, andPlayingId: 1)!
            var myBoard = board
            let boardResult = player.play(onBoard: &myBoard, onColumn: col, withLastMove: lastMove)

            XCTAssertEqual(result, boardResult)
            XCTAssertEqual(board, myBoard)
        }
    }
}
