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
        let filePath = NSHomeDirectory() + "/Library/AssignRole/data.csv"
        let csv = "name,isDone,isBigginer\r\taro,true,true\r\n"
        let data = csv.data(using: .utf8)
        
        print("current directory is \(filePath)")
        
        // ファイル書き込み
        do {
            if !fileManager.fileExists(atPath: filePath) {
                if !isDirectory(at: NSHomeDirectory() + "/Library/AssignRole") {
                    do {
                        try fileManager.createDirectory(
                            atPath: NSHomeDirectory() + "/Library/AssignRole",
                            withIntermediateDirectories: false,
                            attributes: nil
                        )
                    } catch let error {
                        print("error! \(error)")
                    }
                }
                
                
                do {
                    try fileManager.createFile(
                        atPath: filePath,
                        contents: data,
                        attributes: nil
                    )
                } catch let error {
                    print("error! \(error)")
                }
            }
            
            try csv.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            
        } catch let error {
            print("error! \(error)")
        }
        
        print(data)
    }
    
    func isDirectory(at path: String) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
}

struct User {
    let name: String
    let isDone: Bool
    let isBigginer: Bool
    
    init(_ name: String, _ isDone: Bool, _ isBigginer: Bool) {
        self.name = name
        self.isDone = isDone
        self.isBigginer = isBigginer
    }
}
