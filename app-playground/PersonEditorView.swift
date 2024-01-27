//
//  PersonEditorView.swift
//  playground-debug
//
//  Created by 林介夫 on 2024/1/24.
//

import Foundation
import SwiftUI

class AddressInput: ObservableObject {
  var province: String = ""
  var city: String = ""
  var district: String = ""
  var line: String = ""
}

class PersonInput: ObservableObject {
  var name: String = ""
  var age: Int = 0
  var address: AddressInput = AddressInput()
}

struct PersonEditorView: View {
  @Binding var person: PersonInput
  @State var age: String = ""
  
  var body: some View {
    VStack {
      HStack {
        Text("Person Editor").font(.system(size: 16))
        Spacer()
      }.padding([.bottom], 12)
      HStack(spacing: 10) {
        Label("Person", systemImage: "person.and.background.striped.horizontal")
        TextField("Name", text: $person.name)
        TextField("Age", text: $age, onCommit: {
          if let ageInt = Int(age) {
            person.age = ageInt
          }
        })
        Spacer()
      }.textFieldStyle(RoundedBorderTextFieldStyle())
      HStack(spacing: 10) {
        Label("Address", systemImage: "location.circle")
        TextField("Province", text: $person.address.province)
        TextField("City", text: $person.address.city)
        TextField("District", text: $person.address.district)
        TextField("Line", text: $person.address.line)
      }.textFieldStyle(RoundedBorderTextFieldStyle())
    }.padding()
    
  }
}

struct PersonEditorPreview: View {
  @State var person = PersonInput()
  
  var body: some View {
    PersonEditorView(person: $person)
  }
}

#Preview {
  PersonEditorPreview()
}
