//
//  File.swift
//

import ArgumentParser
import Foundation

@main
struct AssignRole: AsyncParsableCommand {
    static var configration = CommandConfiguration(
        commandName: "assign",
        abstract: "assign role",
        version: "0.1.0"
    )
    
    mutating func run() async throws {
        let fileManager = FileManager.default
        let libraryPath = NSHomeDirectory() + "/Library"
        let filePath = "/AssignRole/data.json"
                
        var user = User(name: "fuga", isDone: true)
        
        print("current directory is \(libraryPath + filePath)")
        
        // ファイル書き込み
        do {
            if !fileManager.fileExists(atPath: libraryPath + filePath) {
                if !isDirectory(at: libraryPath + "/AssignRole") {
                    do {
                        try fileManager.createDirectory(
                            atPath: libraryPath + "/AssignRole",
                            withIntermediateDirectories: false,
                            attributes: nil
                        )
                    } catch {
                        print("error! \(error)")
                    }
                }
                
                do {
                    try fileManager.createFile(
                        atPath: libraryPath + filePath,
                        contents: nil,
                        attributes: nil
                    )
                } catch {
                    print("error! \(error)")
                }
            }
            
            write(user, to: filePath)
            
        } catch {
            print("error! \(error)")
        }
    }
    
    func isDirectory(at path: String) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    func write(_ user: User, to path: String) {
        do {
            guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
                fatalError("ライブラリURL取得エラー")
            }
            let fileURL = libraryURL.appendingPathComponent(path)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            guard let json = try? encoder.encode(user) else {
                fatalError("JSONエンコードエラー")
            }
            
            try json.write(to: fileURL)
        } catch {
            print("error! \(error)")
        }
    }
}

struct User: Codable {
    let name: String
    let isDone: Bool
}
