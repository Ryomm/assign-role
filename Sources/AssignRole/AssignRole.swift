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
        let libraryPath = fi
        let filePath = NSHomeDirectory() + "/Data/data.csv"
        let csv = "name,isDone,isBigginer\r\taro,true,true\r\n"
        let data = csv.data(using: .utf8)
        
        print("current directory is \(filePath)")
        
//        if !fileManager.fileExists(atPath: filePath) {
//            fileManager.createFile(atPath: filePath, contents: data, attributes: [:])
//        } else {
//            print("already exist")
//        }
        
        // ファイル書き込み
        do {
            if !fileManager.fileExists(atPath: filePath) {
                do {
                    try fileManager.createDirectory(
                        atPath: "/Data",
                        withIntermediateDirectories: false,
                        attributes: [
                            FileAttributeKey.posixPermissions: 0o777,
                        ]
                    )
                    if !fileManager.createFile(
                        atPath: filePath,
                        contents: data,
                        attributes: nil
                    ) {
                        print("Create file error")
                    }
                }
            }
            
//            try csv.write(toFile: filePath, atomically: true, encoding: String.Encoding.utf8)
            
        } catch let error {
            print("error! \(error)")
        }
        
        print(data)
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
