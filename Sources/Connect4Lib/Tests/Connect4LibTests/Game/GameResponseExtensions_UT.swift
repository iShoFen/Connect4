//
// Created by etudiant on 09/02/2023.
//

import XCTest
@testable import Connect4Lib

class GameResponseExtensions_UT: XCTestCase {

     public func testFailedReasonExtensions() throws {
         XCTAssertEqual(FailedReason.Unknown.toPlayingError(), PlayingError.Unknown)
         XCTAssertEqual(FailedReason.OutOfBounds.toPlayingError(), PlayingError.OutOfBounds)
         XCTAssertEqual(FailedReason.ColumnFull.toPlayingError(), PlayingError.ColumnFull)
         XCTAssertEqual(FailedReason.ColumnEmpty.toPlayingError(), PlayingError.ColumnEmpty)
     }

    public func testInvalidReasonExtensions() throws {
        XCTAssertEqual(try! InvalidReason.Unknown.toInitError(), InitialisationError.Unknown)
        XCTAssertEqual(try! InvalidReason.TooFewRows.toInitError(), InitialisationError.TooFewRows)
        XCTAssertEqual(try! InvalidReason.TooManyRows.toInitError(), InitialisationError.TooManyRows)
        XCTAssertEqual(try! InvalidReason.TooFewColumns.toInitError(), InitialisationError.TooFewColumns)
        XCTAssertEqual(try! InvalidReason.TooManyColumns.toInitError(), InitialisationError.TooManyColumns)
        XCTAssertEqual(try! InvalidReason.BoardFull.toInitError(), InitialisationError.BoardFull)
        XCTAssertThrowsError(try InvalidReason.NoWinner.toInitError()) { error in
            XCTAssertEqual(error as? InitialisationError, InitialisationError.Unknown)
        }
    }
}
