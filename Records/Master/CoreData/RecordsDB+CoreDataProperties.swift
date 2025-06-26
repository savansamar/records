//
//  RecordsDB+CoreDataProperties.swift
//  Records
//
//  Created by MACM72 on 26/06/25.
//
//

import Foundation
import CoreData


extension RecordsDB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecordsDB> {
        return NSFetchRequest<RecordsDB>(entityName: "RecordsDB")
    }

    @NSManaged  var records: RecordListWrapper?

}

extension RecordsDB : Identifiable {

}
