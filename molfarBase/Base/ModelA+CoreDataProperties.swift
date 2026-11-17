//
//  ModelA+CoreDataProperties.swift
//  molfarBase
//
//  Created by kwazzar on 17.11.2026.
//
//

public import Foundation
public import CoreData


public typealias ModelACoreDataPropertiesSet = NSSet

extension ModelA {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ModelA> {
        return NSFetchRequest<ModelA>(entityName: "ModelA")
    }

    @NSManaged public var title: String?
    @NSManaged public var id: UUID
    @NSManaged public var items: NSSet?

}

// MARK: Generated accessors for items
extension ModelA {

    @objc(addItemsObject:)
    @NSManaged public func addToItems(_ value: ModelB)

    @objc(removeItemsObject:)
    @NSManaged public func removeFromItems(_ value: ModelB)

    @objc(addItems:)
    @NSManaged public func addToItems(_ values: NSSet)

    @objc(removeItems:)
    @NSManaged public func removeFromItems(_ values: NSSet)

}

extension ModelA : Identifiable {

}
