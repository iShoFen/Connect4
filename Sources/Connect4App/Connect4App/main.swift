//
//  main.swift
//  Power4App
//
//  Created by Samuel on 17/01/2023.
//

import Foundation
import Connect4Lib

let rules = StandardRule()
let reader = ConsoleReader()
let writer = ConsoleWriter()
var players: [Player] = []
var game: Game? = nil

let playerScanner: () -> Int = {
    writer.write("Please enter the column you want to play in:")
    guard let column = reader.intReader() else {
        writer.write("Invalid column")
        return playerScanner()
    }

    return column - 1
}

writer.write("Welcome to Connect 4!")
while true {
    writer.write("Please enter the number of players (1 or 2):")
    guard let numberOfPlayers = reader.intReader(), numberOfPlayers == 1 || numberOfPlayers == 2 else {
        writer.write("Invalid number of players")
        continue
    }

    if (players.count == 2 && numberOfPlayers == 1) {
        writer.write("Who's players are you ? (1 or 2)")
        guard let playerNumber = reader.intReader(), playerNumber == 1 || playerNumber == 2 else {
            writer.write("Invalid player number")
            continue
        }
        players.remove(at: playerNumber == 1 ? 0 : 1)
    } else if (players.count < numberOfPlayers) {
        for i in (1 + players.count)...numberOfPlayers {
            writer.write("Please enter the name of player \(i):")
            let name = reader.stringReader()
            players.append(Human(withId: UInt64(i), andPseudo: name, andScanner: playerScanner)!)
        }
    }

    if numberOfPlayers == 1 {
        players.append(DumbAI())
    }
    do {
        game = try Game(withRule: rules, andPlayers: players, withDisplay: {writer.writeGameResponse($0)})
        
        game!.start()
        writer.write("Do you want to play again? (y/n)")
        let answer = reader.stringReader()
        guard answer == "y" else {
            break
        }
        players.removeAll(where: {$0 is DumbAI})
    } catch let error as GameResponse {
        writer.writeGameResponse(error)
    } catch {
        writer.write("Unknown error")
    }
}
