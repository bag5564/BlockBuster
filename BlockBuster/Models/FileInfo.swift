//
//  FileInfo.swift
//  BlockBuster
//
//  Created by Ben Gutierrez on 11/18/21.
//

import Foundation

// Convenient struct for generating URL and exists property for a file in documents directory
struct FileInfo {
    let name : String
    let url : URL
    let exists : Bool
    
    init(for filename:String) {
        name = filename
        let fileManager = FileManager.default
        let documentURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        url = documentURL.appendingPathComponent(filename + ".json")
        exists = fileManager.fileExists(atPath: url.path)
    }
    
    private init(name:String, url:URL, exists:Bool){
        self.init(for: "")
    }
}

