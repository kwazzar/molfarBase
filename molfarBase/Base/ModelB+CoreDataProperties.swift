//
//  ModelB+CoreDataProperties.swift
//  molfarBase
//
//  Created by kwazzar on 17.11.2026.
//
//

public import Foundation
public import CoreData


public typealias ModelBCoreDataPropertiesSet = NSSet

extension ModelB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModelB> {
        return NSFetchRequest<ModelB>(entityName: "ModelB")
    }

    @NSManaged public var title: String?
    @NSManaged public var value: Int32
    @NSManaged public var id: UUID
    @NSManaged public var owner: ModelA?

}

extension ModelB : Identifiable {

}
