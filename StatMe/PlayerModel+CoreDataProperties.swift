//
//  PlayerModel+CoreDataProperties.swift
//  StatMe
//
//  Created by spiiral no on 5/12/23.
//
//

import Foundation
import CoreData


extension PlayerModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlayerModel> {
        return NSFetchRequest<PlayerModel>(entityName: "PlayerModel")
    }

    @NSManaged public var playerId: Int64
    @NSManaged public var playerName: String?
    @NSManaged public var teamCode: String?
    @NSManaged public var playerPos: String?

}

extension PlayerModel : Identifiable {

}
