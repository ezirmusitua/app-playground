//
//  BookmarkData.swift
//  app-playground
//
//  Created by 林介夫 on 2024/1/28.
//

import SwiftUI

struct BookmarkDataView: View {
  @State var target: URL?
  @State var selecting: Bool = false
  @State var files: [URL] = []
  
  var body: some View {
    VStack {
      HStack {
        Text("目标路径" + (target?.path ?? "N/A"))
          .padding()
        Button("选择文件夹") {
          selecting.toggle()
        }.padding()
      }
      List(files, id: \.self) {file in
        Text(file.path)
      }.padding()
    }
    .onAppear {
      if let url = loadBookmarkURL() {
        print("[DEBUG] \(url)")
        scanTarget(at: url)
        target = url
      }
    }
    .fileImporter(isPresented: $selecting, allowedContentTypes: [.folder], allowsMultipleSelection: false, onCompletion: {
      do {
        let result = try $0.get()
        if result.first != nil {
          target = result.first!
          saveBookmark(target: result.first!)
          scanTarget(at: result.first!)
        }
      } catch {
        print("\(error)")
      }
    })
    
  }
  
  // 保存 bookmarkData 到 UserDefaults
  func saveBookmark(target: URL) {
    do {
      let bookmarkData = try target.bookmarkData(
        options: [.withSecurityScope]
      )
      UserDefaults.standard.set(bookmarkData, forKey: "bookmark")
    } catch {
      print("书签数据保存失败：\(error)")
    }
  }
  
  // 从 UserDefaults 中加载保存的 bookmarkData 并还原为文件路径
  func loadBookmarkURL() -> URL? {
    if let bookmarkData = UserDefaults.standard.data(forKey: "bookmark") {
      print("[DEBUG] \(bookmarkData)")
      do {
        var isStale = false
        let url = try URL(
          resolvingBookmarkData: bookmarkData,
          options: [.withoutUI, .withSecurityScope],
          relativeTo: nil,
          bookmarkDataIsStale: &isStale
        )
        return url
      } catch {
        print("书签数据解析失败 \(error)")
        return nil
      }
    }
    print("[DEBUG] 1")
    return nil
  }
  
  func scanTarget(at url: URL) {
    let success = url.startAccessingSecurityScopedResource()
    if !success {
      print("加载失败")
      return
    }
    do {
      let fileManager = FileManager.default
      files = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: [])
    } catch {
      print("Error: \(error)")
    }
    url.stopAccessingSecurityScopedResource()
  }
}

#Preview {
  BookmarkDataView()
}
