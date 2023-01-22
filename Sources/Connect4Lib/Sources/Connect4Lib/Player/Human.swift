//
// Created by etudiant on 22/01/2023.
//

import Foundation

class Human : Player {
    public let pseudo: String

    public init?(withId id: Int, andPseudo pseudo: String) {
        guard !pseudo.isEmpty else {
            return nil
        }
        self.pseudo = pseudo
        super.init(withId: id)
    }
}
