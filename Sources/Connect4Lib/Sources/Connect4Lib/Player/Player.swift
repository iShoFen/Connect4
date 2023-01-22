//
// Created by etudiant on 22/01/2023.
//

import Foundation

class Player {
    public let id: Int

    public init?(withId id: Int) {
        guard id > 0 else {
            return nil
        }

        self.id = id
    }

}
