import SQLite
import SwiftUI

struct Users {
  let db: SQLite.Connection
  
  var table: SQLite.Table {
    get {
      return Table("persons")
    }
  }
  
  var age: SQLite.Expression<Int> {
    get {
      return Expression<Int>("age")
    }
  }
  
  var id: SQLite.Expression<Int> {
    get {
      return Expression<Int>("id")
    }
  }
  var name: SQLite.Expression<String> {
    get {
      return Expression<String>("name")
    }
  }
  var addressId: SQLite.Expression<Int> {
    get {
      return Expression<Int>("address_id")
    }
  }
  
  func createTbl() {
    do {
      try db.run(
        table.create(ifNotExists: true) { table in
          table.column(id, primaryKey: .autoincrement)
          table.column(addressId)
          table.column(age)
          table.column(name)
        }
      )
    } catch {
      print("\(error)")
    }
  }
  
  func insert(person: Person) -> Int64 {
    do {
      return try db.run(table.insert(
        addressId <- person.address.id!,
        age <- person.age,
        name <- person.name
      ))
    } catch {
      print("\(error)")
    }
    return -1
  }
}

struct Addresses {
  let db: SQLite.Connection
  
  var table: SQLite.Table {
    get {
      return Table("addresses")
    }
  }
  
  var id: Expression<Int> {
    get {
      return Expression<Int>("id")
    }
  }
  
  var province: Expression<String> {
    get {
      return Expression<String>("province")
    }
  }
  
  var city: Expression<String> {
    get {
      return Expression<String>("city")
    }
  }
  
  var district: Expression<String> {
    get {
      return Expression<String>("district")
    }
  }
  
  var line: Expression<String> {
    get {
      return Expression<String>("line")
    }
  }
  
  func createTbl() {
    do {
      try db.run(
        table.create(ifNotExists: true) { table in
          table.column(id, primaryKey: .autoincrement)
          table.column(city)
          table.column(district)
          table.column(line)
          table.column(province)
        }
      )
    } catch {
      print("\(error)")
    }
  }
  
  func insert(address: Address) -> Int64 {
    do {
      return try db.run(table.insert(
        city <- address.city,
        district <- address.district,
        line <- address.line,
        province <- address.province
      ))
    } catch {
      print("\(error)")
    }
    return -1
  }
}


// 数据库管理类
class SQLiteManager {
  private var db: Connection!
  private var persons: Users!
  private var addresses: Addresses!
  
  init() {
    let documentsDirectory = getAppDocumentsURL()
    let path = documentsDirectory.appendingPathComponent("db.sqlite3")
    
    do {
      db = try Connection(path.absoluteString)
      persons = Users(db: db)
      addresses = Addresses(db: db)
      persons.createTbl()
      addresses.createTbl()
    } catch {
      fatalError("Error initializing database: \(error)")
    }
  }
  
  func insertPerson(person: Person) -> Person {
    let addressId = addresses.insert(address: person.address)
    person.address.id = Int(addressId)
    let personId = persons.insert(person: person)
    person.id = Int(personId)
    return person
  }
  
  // 查询所有用户数据
  func search(age: Int) -> [Person] {
    let query = persons.table
      .join(
        addresses.table,
        on: persons.table[persons.addressId] == addresses.table[addresses.id]
      )
      .filter(persons.table[persons.age] >= age)
      .order(persons.table[persons.name].asc)
    var result: [Person] = []
    do {
      for row in try db.prepare(query) {
        let address = Address(
          id: try row.get(addresses.table[addresses.id]),
          city: try row.get(addresses.table[addresses.city]),
          district:try row.get(addresses.table[addresses.district]),
          line: try row.get(addresses.table[addresses.line]),
          province: try row.get(addresses.table[addresses.province])
        )
        let person = Person(
          id: try row.get(persons.table[persons.id]),
          address: address,
          age: try row.get(persons.table[persons.age]),
          name: try row.get(persons.table[persons.name])
        )
        result.append(person)
      }
    } catch {
      print("\(error)")
    }
    return result
  }
}


struct SQLiteView: SwiftUI.View {
  @State var person: PersonInput = PersonInput()
  @State var loadedPersons: [Person] = []
  let db: SQLiteManager = SQLiteManager()
  
  var body: some SwiftUI.View {
    VStack {
      HStack {
        Button("Add") {
          let person = Person(data: person)
          let inserted = db.insertPerson(person:  person)
          print("\(inserted.content) \(inserted.id ?? -1)")
        }
        Button("Load") {
          loadedPersons = db.search(age: 0)
        }
        Spacer()
      }.padding(8)
      Divider()
      VStack {
        PersonEditorView(person: $person)
        Divider()
        Spacer()
        PersonListView(persons: $loadedPersons)
      }
    }
    .padding()
  }
}

#Preview {
  SQLiteView()
}
