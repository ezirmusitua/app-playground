import Foundation
import SwiftUI

/// 将实现了 Codable 协议的对象数组保存到特定路径
func saveToPropertyList<T: Codable>(data: [T], fileRelativePath: String) -> URL {
  let documentDirectory = getAppDocumentsURL()
  let fp = documentDirectory.appendingPathComponent(fileRelativePath)
  
  do {
    let data = try PropertyListEncoder().encode(data)
    try data.write(to: fp)
    print("Array/Dictionary successfully written to: \(fp.path)")
  } catch {
    print("Error writing array/dictionary to file: \(error.localizedDescription)")
  }
  
  return fp
}

/// 从特定路径解析实现了 Codable 协议的对象数组
func loadPropertyList<T: Codable>(fileRelativePath: String) -> [T]? {
  let documentDirectory = getAppDocumentsURL()
  let fp = documentDirectory.appendingPathComponent(fileRelativePath)
  
  do {
    let data = try Data(contentsOf: fp)
    let decodedStruct = try PropertyListDecoder().decode([T].self, from: data)
    print("Array/Dictionary read from file: \(decodedStruct)")
    return decodedStruct
  } catch {
    print("Error reading array/dictionary from file: \(error.localizedDescription)")
    return nil
  }
}

struct PropertyListView: View {
  var plistDest: String = "example.plist"
  var archiveDest: String = "example.archive"
  @State var person = PersonInput()
  @State var loadedPersons: [Person] = []
  
  var body: some View {
    VStack {
      HStack {
        Button("Save") {
          let person = Person(data: person);
          loadedPersons.append(person)
          let _ = saveToPropertyList(data: loadedPersons, fileRelativePath: plistDest)
        }
        Button("Load") {
          if let persons: [Person] = loadPropertyList(fileRelativePath: plistDest) {
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
