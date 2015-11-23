//
//  FileManager.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-22.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import Foundation

class FileManager{
    func storedatasetusingcurrentdate(dataset:NSArray)->Bool{
        let homeDirectory = NSHomeDirectory()
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as! String
        var fileManager = NSFileManager()
        var error:NSError?
        let mydir4 = NSHomeDirectory() + "/Documents/myfolder/files"
        fileManager.createDirectoryAtPath(mydir4, withIntermediateDirectories: true, attributes: nil, error: &error)
        let formatter = NSDateFormatter()
        formatter.dateFormat="yyyy:MMM:dd"
        let date = formatter.stringFromDate(NSDate())
        var filePath = mydir4 + "/\(date)"
        var array :NSArray = dataset
        array.writeToFile(filePath, atomically: true)
        return true
    }
    
    func gettitlelist()->[String]{
        let homeDirectory = NSHomeDirectory()
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as! String
        var fileManager = NSFileManager()
        var error:NSError?
        let mydir4 = NSHomeDirectory() + "/Documents/myfolder/files"
        let filelist : NSArray = fileManager.contentsOfDirectoryAtPath(mydir4,error:nil)!
        var results:[String]=[]
        for filename in filelist{
            results.append(filename as! String)
        }
        return results
    }
    
    func getdata(filename:String) -> NSArray{
        let homeDirectory = NSHomeDirectory()
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as! String
        var fileManager = NSFileManager()
        var error:NSError?
        let mydir4 = NSHomeDirectory() + "/Documents/myfolder/files"
        let filelist : NSArray = fileManager.contentsOfDirectoryAtPath(mydir4,error:nil)!
        let onepath = mydir4 + "/\(filename)"
        let content = NSArray(contentsOfFile: onepath)!
        print("content is \(content)\n")
        return content
    }
    
}