import Foundation
import SwiftUI

func archiveData<T: NSObject & NSSecureCoding>(data: [T], fileRelativeURL: String) {
  let documentsDirectory = getAppDocumentsURL()
  let destURL = documentsDirectory.appendingPathComponent(fileRelativeURL)
  do {
    let data = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: true)
    try data.write(to: destURL)
    print("归档成功：\(destURL)")
  } catch {
    print("归档失败：\(error)")
  }
}

func unarchiveData<T: NSObject & NSSecureCoding>(fileRelativeURL: String) -> [T]? {
  let documentsDirectory = getAppDocumentsURL()
  let dataURL = documentsDirectory.appendingPathComponent(fileRelativeURL)
  if let data = try? Data(contentsOf: dataURL) {
    do {
      if let unarchived = try NSKeyedUnarchiver.unarchivedArrayOfObjects(ofClass: T.self, from: data) {
        return unarchived
      } else {
        print("解档失败：未能还原对象")
      }
    } catch {
      print("解档失败：\(error)")
    }
  }
  return nil
}

struct ArchiverView: View {
  var plistDest: String = "example.plist"
  var archiveDest: String = "example.archive"
  @State var person = PersonInput()
  @State var loadedPersons: [Person] = []
  
  var body: some View {
    VStack {
      HStack {
        Button("Add") {
          let person = Person(data: person)
          loadedPersons.append(person)
          archiveData(data: loadedPersons, fileRelativeURL: archiveDest)
        }
        Button("Load") {
          if let persons: [Person] = unarchiveData(fileRelativeURL: archiveDest) {
            loadedPersons = persons
          }
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
    }.padding()
  }
}

#Preview {
  PropertyListView()
}
