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
    
    @Option(name: .shortAndLong, help: "Add new member.")
    var newface: String?
    
    @Option(name: .shortAndLong, help: "Number of people you would like to assign to the role")
    var pick: Int?
    
    @Flag(help: "Pick up one of members")
    var roulette: Bool = false
    
    @Flag(help: "Show members list")
    var list: Bool = false
    
    mutating func run() async throws {
        let fileManager = FileManager.default
        let libraryPath = NSHomeDirectory() + "/Library"
        let filePath = "/AssignRole/data.json"
        
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
                        fatalError("Can not create directory: \(error)")
                    }
                }
                
                do {
                    try fileManager.createFile(
                        atPath: libraryPath + filePath,
                        contents: nil,
                        attributes: nil
                    )
                } catch {
                    fatalError("Can not create file: \(error)")
                }
            }
            
            var members = read(from: filePath)
            
            if let newface = newface {
                // 存在チェック
                if members.filter{ $0.name == newface }.count > 0 {
                    fatalError("Already exist member")
                }
                members.append(Member(name: newface, isDone: false))
            }
            
            if members.isEmpty {
                fatalError("Member is not exist. Please add member with --newface command.")
            }
            
            if let pick = pick {
                var assigners: Array<String>
                (assigners, members) = assignRole(pick, from: members)
                for (i, assigner) in assigners.enumerated() {
                    print("\(i). \(assigner)")
                }
            }
            
            if roulette {
                if let pick = members.randomElement() {
                    print(pick.name)
                }
            }
            
            if list {
                members.forEach{ member in
                    print(member.name, "hasFlag:", member.isDone)
                }
            }
            
            
            write(members, to: filePath)
            
            
            
        } catch {
            fatalError("Unexpected error: \(error)")
        }
    }
    
    func isDirectory(at path: String) -> Bool {
        var isDirectory: ObjCBool = false
        FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return isDirectory.boolValue
    }
    
    func write(_ members: Array<Member>, to path: String) {
        do {
            guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
                fatalError("Failed to get library URL")
            }
            let fileURL = libraryURL.appendingPathComponent(path)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            guard let json = try? encoder.encode(members) else {
                fatalError("Failed to encode data")
            }
            
            try json.write(to: fileURL)
        } catch {
            fatalError("Failed write data to local file: \(error)")
        }
    }
    
    func read(from path: String) -> Array<Member> {
        guard let libraryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first else {
            fatalError("Failed to get library URL")
        }
        let fileURL = libraryURL.appendingPathComponent(path)
        
        if !FileManager.default.fileExists(atPath: NSHomeDirectory() + "/Library" + path) {
            fatalError("JSON file is not exist")
        }
        
        guard let data = try? Data(contentsOf: fileURL) else {
            fatalError("Failed read data from the file")
        }
        
        let decoder = JSONDecoder()
        guard let members = try? decoder.decode([Member].self, from: data) else {
            fatalError("Failed to decode data")
        }
        
        return members
    }
    
    func setUpFlag(of name: String, members: Array<Member>) -> Array<Member> {
        var members = members
        // 名前で一意になる想定のため、一致した最初の要素を書き換える
        if let index = members.firstIndex(where: { $0.name == name }) {
            members[index].isDone = true
        }
        return members
    }
    
    func resetFlag(members: Array<Member>) -> Array<Member> {
        var members = members
        for index in members.indices {
            members[index].isDone = false
        }
        return members
    }
    
    func assignRole(_ pickNum: Int, from members: Array<Member>) -> (Array<String>, Array<Member>) {
        var havntAssignedMembers = members.filter{ $0.isDone == false }
        var assigners: Array<String> = []
        var members = members
        
        if havntAssignedMembers.count >= pickNum {
            for i in 0..<pickNum {
                if let pick = havntAssignedMembers.randomElement() {
                    assigners.append(pick.name)
                    members = setUpFlag(of: pick.name, members: members)
                    havntAssignedMembers = members.filter{ $0.isDone == false }
                }
            }
        } else {
            havntAssignedMembers.forEach{ m in
                assigners.append(m.name)
            }
            members = resetFlag(members: members)
            for i in 0..<pickNum-havntAssignedMembers.count {
                if let pick = havntAssignedMembers.randomElement() {
                    assigners.append(pick.name)
                    members = setUpFlag(of: pick.name, members: members)
                    havntAssignedMembers = members.filter{ $0.isDone == false }
                }
            }
        }
        
        return (assigners, members)
    }
}

struct Member: Codable {
    let name: String
    var isDone: Bool
}
