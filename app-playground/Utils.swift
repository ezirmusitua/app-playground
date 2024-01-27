import Foundation

func getAppDocumentsURL() -> URL {
  return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
}
