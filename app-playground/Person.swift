//
//  Person.swift
//  playground-debug
//
//  Created by 林介夫 on 2024/1/25.
//

import Foundation

protocol PersonDisplay: Identifiable, Hashable {
  var content: String { get }
}

class Address: NSObject, NSSecureCoding, Codable {
  static var supportsSecureCoding: Bool = true
  
  var city: String
  var district: String
  var id: Int?
  var line: String
  var province: String
  
  var content: String {
    get {
      return "\(province), \(city), \(district), \(line)"
    }
  }
  
  init(data: AddressInput) {
    self.city = data.city
    self.district = data.district
    self.line = data.line
    self.province = data.province
  }
  
  init(id: Int, city: String, district: String, line: String, province: String) {
    self.id = id
    self.city = city
    self.district = district
    self.line = line
    self.province = province
  }
  
  init(city: String, district: String, line: String, province: String) {
    self.city = city
    self.district = district
    self.line = line
    self.province = province
  }
  
  // MARK: - NSSecureCoding
  
  required convenience init?(coder decoder: NSCoder) {
    guard let city = decoder.decodeObject(of: NSString.self, forKey: "city") as String? else { return nil }
    guard let district = decoder.decodeObject(of: NSString.self, forKey: "district") as String? else { return nil }
    guard let id = decoder.decodeInteger(forKey: "id")  as Int? else { return nil }
    guard let line = decoder.decodeObject(of: NSString.self, forKey: "line") as String? else { return nil }
    guard let province = decoder.decodeObject(of: NSString.self, forKey: "province") as String? else { return nil }
    
    self.init(city: city, district: district, line: line, province: province)
    if id != nil {
      self.id = id
    }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(province, forKey: "province")
    aCoder.encode(city, forKey: "city")
    aCoder.encode(district, forKey: "district")
    aCoder.encode(line, forKey: "line")
  }
}

class Person: NSObject, NSSecureCoding, Codable, PersonDisplay {
  static var supportsSecureCoding: Bool = true
  
  var id: Int?
  var name: String
  var age: Int
  var address: Address
  
  var content: String {
    get {
      return "name: \(name), age: \(age), address: \(address.content)"
    }
  }
  
  init(data: PersonInput) {
    address = Address(data: data.address)
    age = data.age
    name = data.name
  }
  
  init(address: Address, age: Int, name: String) {
    self.address = address
    self.age = age
    self.name = name
  }
  
  init(id: Int, address: Address, age: Int, name: String) {
    self.id = id
    self.address = address
    self.age = age
    self.name = name
  }
  
  // MARK: - NSSecureCoding
  
  required convenience init?(coder decoder: NSCoder) {
    guard let address = decoder.decodeObject(of: Address.self, forKey: "address") as Address? else { return nil }
    guard let age = decoder.decodeInteger(forKey: "age") as Int? else { return nil }
    guard let id = decoder.decodeInteger(forKey: "id") as Int? else { return nil }
    guard let name = decoder.decodeObject(of: NSString.self, forKey: "name") as String? else { return nil }
    
    self.init(address: address, age: age, name: name)
    if id != nil {
      self.id = id
    }
  }
  
  func encode(with aCoder: NSCoder) {
    aCoder.encode(name, forKey: "name")
    aCoder.encode(age, forKey: "age")
    aCoder.encode(address, forKey: "address")
  }
}
