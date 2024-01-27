//
//  Archive1.swift
//  playground-debug
//
//  Created by 林介夫 on 2024/1/22.
//

import Foundation

class PersonA1: NSObject, NSSecureCoding{
  static var supportsSecureCoding: Bool = true
  var name: String
  var address: AddressA1?
  
  init(name: String, address: AddressA1?) {
    self.name = name
    self.address = address
  }
  
  // MARK: - NSCoding
  
  required convenience init?(coder aDecoder: NSCoder) {
    guard let name = aDecoder.decodeObject(of: NSString.self, forKey: "name") as? String else { return nil }
    guard let address = aDecoder.decodeObject(of: AddressA1.self, forKey: "address") else { return nil }
    
    self.init(name: name, address: address)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encodeConditionalObject(address, forKey: "address")
  }
}

class AddressA1: NSObject, NSSecureCoding {
  static var supportsSecureCoding: Bool = true
  var street: String
  var person: PersonA1?
  
  init(street: String, person: PersonA1?) {
    self.street = street
    self.person = person
  }
  
  // MARK: - NSCoding
  
  required convenience init?(coder aDecoder: NSCoder) {
    guard let street = aDecoder.decodeObject(of: NSString.self, forKey: "street") as? String else { return nil }
    guard let person = aDecoder.decodeObject(of: PersonA1.self, forKey: "person") else { return nil }
    
    self.init(street: street, person: person)
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(street, forKey: "street")
    aCoder.encodeConditionalObject(person, forKey: "person")
  }
}

func archiveA1() {
  // 归档
  let documents = getAppDocumentsURL()
  let dest = documents.appendingPathComponent("example1.archive")
  let person = PersonA1(name: "John", address: nil)
  let address = AddressA1(street: "123 Main St", person: person)
  person.address = address
  
  if let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: person, requiringSecureCoding: true) {
    try? archivedData.write(to: dest)
  }
  
}

func unarchiveA1() {
  let documents = getAppDocumentsURL()
  let dest = documents.appendingPathComponent("example1.archive")
  // 解档
  do {
    let loadedData = try Data(contentsOf: dest)
    let loadedPerson = try NSKeyedUnarchiver.unarchivedObject(ofClass: PersonA1.self, from: loadedData)
    print("\(String(describing: loadedPerson))")
  } catch {
    print("\(error)")
  }
  
}
