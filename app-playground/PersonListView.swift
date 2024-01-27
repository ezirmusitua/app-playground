//
//  ListView.swift
//  playground-debug
//
//  Created by 林介夫 on 2024/1/25.
//

import Foundation
import SwiftUI

struct PersonListView<T: PersonDisplay>: View {
  @Binding var persons: [T]

  var body: some View {
    List(persons, id: \.self) { person in
      HStack {
        Text(person.content)
      }
    }
  }
}

struct PersonListPreview: View {
  @State var persons = [
    Person(
      address: Address(city: "SH", district: "JA", line: "1", province: "SH"),
      age: 1,
      name: "j"
    ),
    Person(
      address: Address(city: "SH", district: "JA", line: "2", province: "SH"),
      age: 2,
      name: "j"
    ),
    Person(
      address: Address(city: "SH", district: "JA", line: "3", province: "SH"),
      age: 3,
      name: "j"
    ),
  ]
  var body: some View {
    PersonListView(persons: $persons)
  }
}

#Preview {
  PersonListPreview()
}
