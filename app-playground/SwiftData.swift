import Foundation
import SwiftData
import SwiftUI


@Model
class PersonSD {
  var age: Int
  var name: String
  var address: AddressSD
  
  init(age: Int, name: String, address: AddressSD) {
    self.age = age
    self.name = name
    self.address = address
  }
}

@Model
class AddressSD {
  var city: String
  var district: String
  var line: String
  var province: String
  
  //  @Relationship(deleteRule: .cascade, inverse: \PersonSD.address)
  //  var person: PersonSD?
  
  init(data: AddressInput) {
    self.city = data.city
    self.district = data.district
    self.line = data.line
    self.province = data.province
  }
}


struct SwiftDataView: View {
  @Environment(\.modelContext) private var sdContext
  @Query() var persons: [PersonSD]
  @State var person: PersonInput = PersonInput()
  
  var personsDisplay: [Person] {
    get {
      persons.map({ person in
        let address = Address(
          city: person.address.city,
          district: person.address.district,
          line: person.address.line,
          province: person.address.province
        )
        let item = Person(
          address: address,
          age: Int(person.age),
          name: person.name
        )
        return item
      })
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        Button("Add") {
          addPerson()
        }
        Spacer()
      }.padding(8)
      Divider()
      VStack {
        PersonEditorView(person: $person)
        Divider()
        Spacer()
        PersonListPreview(persons: personsDisplay)
      }
    }.padding()
  }
  
  private func addPerson() {
    let address = AddressSD(data: person.address)
    sdContext.insert(address)
    let person = PersonSD(age: person.age, name: person.name, address: address)
    sdContext.insert(person)
    do {
      try sdContext.save()
    } catch {
      print("save error \(error)")
    }
  }
}

#Preview {
  SwiftDataView().modelContainer(for: [PersonSD.self, AddressSD.self])
}
