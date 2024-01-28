import CoreData
import Foundation
import SwiftUI

func addAPerson(ctx: NSManagedObjectContext, data: PersonInput) {
  let address = AddressCD(context: ctx)
  address.city = data.address.city
  address.district = data.address.district
  address.line = data.address.line
  address.province = data.address.province
  address.city = data.address.city
  let person = PersonCD(context: ctx)
  person.name = data.name
  person.age = Int64(data.age)
  person.address = address
  try? ctx.save()
}

struct CoreDataView: View {
  @Environment(\.managedObjectContext) private var dataController
  @FetchRequest(sortDescriptors: []) private var persons: FetchedResults<PersonCD>
  @State var person = PersonInput()
  
  var personsDisplay: [Person] {
    get {
      persons.map({ person in
        let address = Address(
          city: person.address?.city ?? "N/A",
          district: person.address?.district ?? "N/A",
          line: person.address?.line ?? "N/A",
          province: person.address?.province ?? "N/A"
        )
        let item = Person(
          address: address,
          age: Int(person.age),
          name: person.name ?? "N/A"
        )
        return item
      })
    }
  }
  
  var body: some View {
    VStack {
      HStack {
        Button("Add") {
          addAPerson(ctx: dataController, data: person)
        }
        Button("Load") {}
        Spacer()
      }.padding(8)
      Divider()
      VStack {
        PersonEditorView(person: $person)
        Spacer()
        Divider()
        PersonListPreview(persons: personsDisplay)
      }
    }
    .padding()
  }
}

class DataController: ObservableObject {
  let container = NSPersistentContainer(name: "CoreDataExample")
  init() {
    container.loadPersistentStores { description, error in
      if let error = error {
        print("Core Data failed to load: \(error.localizedDescription)")
      }
    }
  }
}

struct CoreDataPreview: View {
  @StateObject private var dataController = DataController()
  
  var body: some View {
    VStack {
      CoreDataView()
    }.environment(\.managedObjectContext, dataController.container.viewContext)
  }
}

#Preview {
  CoreDataPreview()
}
