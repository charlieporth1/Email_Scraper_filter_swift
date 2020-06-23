//
//  main.swift
//  filter
//
//  Created by Charlie  Porth on 5/19/20.
//  Copyright © 2020 Charlie  Porth. All rights reserved.
//

import Foundation
print("Hello, World!")
var emailListObjectArray: [EmailListObject] = [EmailListObject]()
var emailList: [String] = [String]()
var bizList: [String] = [String]()
let rootURL = URL(fileURLWithPath: "/home/charlieporth/emails")
func listFiles() -> [URL] {
    var files = [URL]()
    if let enumerator = FileManager.default.enumerator(at: rootURL, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
        for case let fileURL as URL in enumerator {
            do {
                let fileAttributes = try fileURL.resourceValues(forKeys: [.isRegularFileKey])
                if fileAttributes.isRegularFile! {
                    files.append(fileURL)
                }
            } catch { print(error, fileURL) }
        }
        print("files ", files)
        print("files.count ", files.count)
    }
    return files
}

// print("listFiles()", )
func clear() {
    emailListObjectArray = []
    emailList = []
    bizList = []
}

// = text.joined(separator: ", ")
let fileList = listFiles()
for file in fileList {
    print("file ", file.path)
    let text = getTextFromFile(fileURL: file)
    let lineArray: [String] = text.components(separatedBy: .newlines)
    let emailBizObject: EmailListObject = EmailListObject()
    var count: Int = 0
    for line in lineArray {
        print("line ", line)
        if line.contains("BUSINESS:") {
//            let biz: String = line.components(separatedBy: "BUSINESS: ")[1]
//            if bizList.filter({ $0 == biz }).count == 0 {
            ////                bizList = bizList.unique()
//                bizList.append(biz)
//                emailBizObject.biz = biz
//            }
        }
        if line.contains("EMAIL:") {
            let email: String = line.components(separatedBy: "EMAIL: ")[1]

            if emailList.filter({ $0 == email }).count == 0 {
                emailList = emailList.unique()
                emailList.append(email)
                emailBizObject.email = email
            }
        }
//        if emailBizObject.isComplete ?? false {
//            emailListObjectArray = emailListObjectArray.unique()
//            emailListObjectArray.append(emailBizObject)
//        }
        print("bizList.count", bizList.count)
        print("emailList.count", emailList.count)
//        if line == lineArray[lineArray.count - 1] {
        if count >= lineArray.count - 1 {
            print("finished file line count ", lineArray.count)
//            createCSV(emailList: emailList, fileURL: file)
//            createCSV(emailListObjectArray: emailListObjectArray, fileURL: file)
        }
        count += 1
    }
    if file == fileList[fileList.count - 1] {
        createCSV(emailList: emailList, fileURL: file)
        print("last file fileList.count ", fileList.count)
        exit(0)
    }
}

func getTextFromFile(fileURL: URL) -> String {
//    if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
//
//    let fileURL = dir.appendingPathComponent(file)

    // writing
//    do {
//        try text.write(to: fileURL, atomically: false, encoding: .utf8)
//    }
//    catch {/* error handling here */}

    // reading
    do {
        return try String(contentsOf: fileURL, encoding: .utf8)
    } catch {
        return ""
    }
}

func createCSV(emailListObjectArray: [EmailListObject], fileURL: URL) {
    var csvString = "\("email"),\("biz"),\("uuid")\n\n"
    for document in emailListObjectArray {
        let uuid = UUID().uuidString
        csvString = csvString.appending("\(document.email ?? ""),\(document.biz ?? ""),\(uuid)\n")
    }
    createFile(csvString: csvString, fileURL: fileURL)
}

func createCSV(emailList: [String], fileURL: URL) {
    var csvString = "\("email"),\("uuid"),\n\n"
    for email in emailList {
//        let hex = UUID().uuidString.components(separatedBy: "-").suffix(2).joined()
//         let hex2 = UUID().uuidString.components(separatedBy: "-").suffix(2).joined()
//        let rand = UInt32(hex, radix: 0x10)
//          let rand2 = UInt32(hex2, radix: 0x10)
        let uuid = "\(UInt32.random(in:UInt32.min...UInt32.max)).\(UInt32.random(in:UInt32.min...UInt32.max))" //generateRandomDigits(16)// UUID().uuidString
        print("uuid uuid  uuid uuid uuid uuid uuid uuid uuid  ", uuid)
//        let index = uuid.index(uuid.startIndex, offsetBy: 16)
//        let uuidString = uuid[..<index] // Hello
        csvString = csvString.appending("\(email),\(uuid),\n")
    }
    createFile(csvString: csvString, fileURL: fileURL)
}

func createFile(csvString: String, fileURL: URL) {
    let fileString = "/home/charlieporth/output\(fileURL.path)" // .replacingOccurrences(of: "+", with: "_")
    let newFileURL = URL(fileURLWithPath: fileString)
    createDir(filePath: newFileURL)
    print("createFile: fileURL ", newFileURL)
    // in: .userDomainMask, appropriateFor: nil, create: true)
    let newestFileURL = newFileURL.appendingPathExtension("csv")
    do {
        shell("mkdir -p \(newFileURL.path)")
        shell("touch \(newestFileURL.path)")
        try csvString.write(to: newestFileURL, atomically: true, encoding: .utf8)
        clear()
    } catch {
        print("Failed writing to URL: \(newestFileURL), Error: " + error.localizedDescription)
        exit(1)
    }
}

func createDir(filePath: URL) {
    if !FileManager.default.fileExists(atPath: filePath.path) {
        do {
            try FileManager.default.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
        } catch {
            NSLog("Couldn't create document directory")
        }
    }
}

// @discardableResult
// func shell(_ args: String...) -> Int32 {
//    let task = Process()
//    task.launchPath = "/usr/bin/env"
//    task.arguments = args
//    task.launch()
//    task.waitUntilExit()
//    return task.terminationStatus
// }
@discardableResult
func shell(_ command: String) -> String {
    let task = Process()
    let pipe = Pipe()

    task.standardOutput = pipe
    task.arguments = ["-c", command]
    task.launchPath = "/bin/bash"
    task.launch()

    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!

    return output
}
extension URL {
    static func createFolder(folderName: String) -> URL? {
        let fileManager = FileManager.default
        // Get document directory for device, this should succeed
        if let documentDirectory = fileManager.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first {
            // Construct a URL with desired folder name
            let folderURL = documentDirectory.appendingPathComponent(folderName)
            // If folder URL does not exist, create it
            if !fileManager.fileExists(atPath: folderURL.path) {
                do {
                    // Attempt to create folder
                    try fileManager.createDirectory(atPath: folderURL.path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
                } catch {
                    // Creation failed. Print error & return nil
                    print(error.localizedDescription)
                    return nil
                }
            }
            // Folder either exists, or was created. Return URL
            return folderURL
        }
        // Will only be called if document directory not found
        return nil
    }
}

extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
extension UUID {
    
    var base64String: String {
        return self.data.base64EncodedString()
    }

    var data: Data {
        var result = Data()
        let uuidTuple = self.uuid
        // NOTE: There are clever ways to iterate over a tuple in Swift,
        // but I actually want this to not compile if the implementation of uuid_t
        // changes in the future
        result.append(uuidTuple.0)
        result.append(uuidTuple.1)
        result.append(uuidTuple.2)
        result.append(uuidTuple.3)
        result.append(uuidTuple.4)
        result.append(uuidTuple.5)
        result.append(uuidTuple.6)
        result.append(uuidTuple.7)
        result.append(uuidTuple.8)
        result.append(uuidTuple.9)
        result.append(uuidTuple.10)
        result.append(uuidTuple.11)
        result.append(uuidTuple.12)
        result.append(uuidTuple.13)
        result.append(uuidTuple.14)
        result.append(uuidTuple.15)
        return result
    }
}
extension UInt64 {

    static var random: UInt64 {

        let hex = UUID().uuidString
            .components(separatedBy: "-")
            .suffix(2)
            .joined()

        return UInt64(hex, radix: 0x10)!
    }
}
extension UInt32 {

    static var random: UInt32 {

        let hex = UUID().uuidString
            .components(separatedBy: "-")
            .suffix(2)
            .joined()
        print("hex ", hex)
        return UInt32(hex, radix: 0x10)!
    }

}
