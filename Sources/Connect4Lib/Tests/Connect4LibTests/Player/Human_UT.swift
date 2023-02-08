//
// Created by etudiant on 01/02/2023.
//

import XCTest
@testable import Connect4Lib

class Human_UT: XCTestCase {
    func testInit() throws {
        func expect(initHumanWithId id:uint64,
                    andName name: String?,
                    andScanner scanner: @escaping () -> String,
                    thatShouldBeNotNil notNil: Bool) {
            let human: Human?
            if name == nil {
                human = Human(withId: id, andScanner: scanner)
            } else {
                human = Human(withId: id, andPseudo: name!, andScanner: scanner)
            }

            if !notNil {
                XCTAssertNil(human)
                return
            }

            XCTAssertNotNil(human)
            XCTAssertEqual(id, human!.id)
            XCTAssertEqual(name ?? "Player", human!.pseudo)
            XCTAssertEqual(0, human!.score)
        }

        expect(initHumanWithId: 1, andName: nil, andScanner: { "" }, thatShouldBeNotNil: true)
        expect(initHumanWithId: 1, andName: "name", andScanner: { "" }, thatShouldBeNotNil: true)
        expect(initHumanWithId: 1, andName: "", andScanner: { "" }, thatShouldBeNotNil: false)
        expect(initHumanWithId: 1, andName: " ", andScanner: { "" }, thatShouldBeNotNil: false)
        expect(initHumanWithId: 0, andName: nil, andScanner: { "" }, thatShouldBeNotNil: false)
        expect(initHumanWithId: uint64.min, andName: nil, andScanner: { "" }, thatShouldBeNotNil: false)
        expect(initHumanWithId: uint64.max, andName: nil, andScanner: { "" }, thatShouldBeNotNil: true)
    }

    func testGetSetName() throws {
        func expect(setNameOnHuman human: Human,
                    withName name: String,
                    andName name2: String,
                    thatShouldBeChange change: Bool) {
            let oldName = human.pseudo
            human.pseudo = name
            XCTAssertEqual(change ? name : oldName, human.pseudo)

            human.pseudo = name2
            XCTAssertEqual(change ? name2 : oldName, human.pseudo)
        }

        let human = Human(withId: 1, andPseudo: "name", andScanner: { "" })!
        expect(setNameOnHuman: human, withName: "hi", andName: "ya", thatShouldBeChange: true)

        let  human2 = Human(withId: 1, andPseudo: "hello", andScanner: { "" })!
        expect(setNameOnHuman: human2, withName: "", andName: " ", thatShouldBeChange: false)

        let human3 = Human(withId: 1, andPseudo: "chose", andScanner: { "" })!
        expect(setNameOnHuman: human3, withName: "  ", andName: "    ", thatShouldBeChange: false)
    }

    func testGetSetScore() throws {
        func expect(setScoreOnHuman human: Human,
                    withScore score: UInt,
                    andScore score2: UInt,
                    thatShouldBeChange change: Bool) {
            let oldScore = human.score
            human.score = score
            XCTAssertEqual(change ? score : oldScore, human.score)

            human.score = score2
            XCTAssertEqual(change ? score2 : oldScore, human.score)
        }

        let human = Human(withId: 1, andScanner: { "" })!
        expect(setScoreOnHuman: human, withScore: 1, andScore: 2, thatShouldBeChange: true)

        let  human2 = Human(withId: 1, andScanner: { "" })!
        expect(setScoreOnHuman: human2, withScore: 4, andScore: 26, thatShouldBeChange: true)

        let human3 = Human(withId: 1, andScanner: { "" })!
        expect(setScoreOnHuman: human3, withScore: UInt.max, andScore: UInt.max, thatShouldBeChange: true)
    }

    func testEquals() throws {
        func expect(equalsHuman human1: Human,
                    andHuman human2: Human,
                    thatShouldBe equals: Bool) {
            XCTAssertEqual(equals, human1 == human2)
        }

        let human1 = Human(withId: 1, andPseudo: "name", andScanner: { "" })!
        let human2 = Human(withId: 1, andPseudo: "name", andScanner: { "" })!
        expect(equalsHuman: human1, andHuman: human2, thatShouldBe: true)

        let human3 = Human(withId: 1, andPseudo: "name2", andScanner: { "" })!
        let human4 = Human(withId: 1, andPseudo: "name", andScanner: { "" })!
        expect(equalsHuman: human3, andHuman: human4, thatShouldBe: true)

        let human5 = Human(withId: 1, andPseudo: "name", andScanner: { "" })!
        let human6 = Human(withId: 1, andPseudo: "name", andScanner: { " " })!
        expect(equalsHuman: human5, andHuman: human6, thatShouldBe: true)

        let human9 = Human(withId: 2, andPseudo: "name", andScanner: { "" })!
        let human10 = Human(withId: 1, andPseudo: "name", andScanner: { "" })!
        expect(equalsHuman: human9, andHuman: human10, thatShouldBe: false)

    }

    func testPlayOnColumn() throws {
        func expect(playOnColumnOnBoard board: Board,
                    withLastMove lastMove: (row: Int, column: Int),
                    withThisRule rule: IRule,
                    withScanner scanner: @escaping () -> String,
                    thatShouldBe column: Int?) {
            let human = Human(withId: 1, andScanner: scanner)
            XCTAssertEqual(column, human?.playOnColumn(onBoard: board, withLastMove: lastMove, withThisRule: rule))
        }

        var board = Board(withNbRows: 6, andNbColumns: 7)!
        let rule = StandardRule()

        expect(playOnColumnOnBoard: board, withLastMove: (0, 0), withThisRule: rule, withScanner: { "1" }, thatShouldBe: 1)
        expect(playOnColumnOnBoard: board, withLastMove: (0, 0), withThisRule: rule, withScanner: { "" }, thatShouldBe: nil)
        expect(playOnColumnOnBoard: board, withLastMove: (0, 0), withThisRule: rule, withScanner: { " " }, thatShouldBe: nil)
        expect(playOnColumnOnBoard: board, withLastMove: (0, 0), withThisRule: rule, withScanner: { "a" }, thatShouldBe: nil)
        expect(playOnColumnOnBoard: board, withLastMove: (6, 5), withThisRule: rule, withScanner: { "1" }, thatShouldBe: 1)

        let grid = [[nil, nil, nil, nil, nil, nil, nil],
                    [nil, nil, nil, nil, nil, nil, nil],
                    [2, nil, nil, nil, nil, nil, nil],
                    [2, nil, nil, nil, nil, nil, nil],
                    [1, nil, nil, 1, nil, nil, nil],
                    [1, 1, nil, 2, 2, nil, nil]]
        board = Board(withGrid: grid)!
        expect(playOnColumnOnBoard: board, withLastMove: (5, 0), withThisRule: rule, withScanner: { "1" }, thatShouldBe: 1)
    }
}
