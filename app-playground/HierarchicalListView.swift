import SwiftUI

struct HierarchicalListsView: View {
  struct FileItem: Hashable, Identifiable, CustomStringConvertible {
    var id: Self { self }
    var name: String
    var children: [FileItem]? = nil
    var description: String {
      switch children {
        case nil:
          return "📄 \(name)"
        case .some(let children):
          return children.isEmpty ? "📂 \(name)" : "📁 \(name)"
      }
    }
  }
  let fileHierarchyData: [FileItem] = [
    FileItem(
      name: "users",
      children: [
        FileItem(
          name: "user1234",
          children: [
            FileItem(
              name: "Photos",
              children: Array(repeating: FileItem(name: "photo001.jpg"), count: 20000)
            ),
            FileItem(name: "Movies", children: Array(repeating: FileItem(name: "movie001.mp4"), count: 5000)),
            FileItem(name: "Documents", children: [])
          ]),
        FileItem(name: "newuser", children: [FileItem(name: "Documents", children: [])])
      ]),
    FileItem(name: "private", children: nil)
  ]
  var body: some View {
    List(fileHierarchyData, children: \.children) { item in
      Text(item.description)
    }
  }
}
