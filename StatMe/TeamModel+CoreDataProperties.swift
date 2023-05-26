//
//  TeamModel+CoreDataProperties.swift
//  StatMe
//
//  Created by spiiral no on 5/12/23.
//
//

import Foundation
import CoreData


extension TeamModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TeamModel> {
        return NSFetchRequest<TeamModel>(entityName: "TeamModel")
    }

    @NSManaged public var teamId: Int64
    @NSManaged public var teamName: String?
    @NSManaged public var teamCode: String?

}

extension TeamModel : Identifiable {

}
