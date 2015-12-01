//
//  InfoManager.swift
//  ToMorning-ximinz
//
//  Created by Carmen Zhuang on 2015-11-30.
//  Copyright (c) 2015 CMPT275-04. All rights reserved.
//

import Foundation

class InfoManager{
    var currlanguange = "English"
    var currbackgroundimg = "IMG_6774.PNG"
    init(){
        let homeDirectory = NSHomeDirectory()
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as! String
        var fileManager = NSFileManager()
        var error:NSError?
        let mydir4 = NSHomeDirectory() + "/Documents/myfolder/info"
        let onepath = mydir4 + "/info.txt"
        if(!fileManager.fileExistsAtPath(onepath)){
            print("file does not exist!")
            fileManager.createDirectoryAtPath(mydir4, withIntermediateDirectories: true, attributes: nil, error: &error)
            let infodict : NSMutableDictionary = ["Languange":"English","BackgroundImage":"IMG_6774.PNG"]
            infodict.writeToFile(onepath, atomically: true)
        }
        else{
            print("file exist!")
            let infodict = NSMutableDictionary(contentsOfFile: onepath)
            if let languange = infodict!["Languange"] as? String{
                self.currlanguange = languange
            }
            if let img = infodict!["BackgroundImage"] as? String{
                self.currbackgroundimg = img
            }
        }
    }
    
    func setbackgroundimg(name:String){
        currbackgroundimg = name
        let homeDirectory = NSHomeDirectory()
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as! String
        var fileManager = NSFileManager()
        var error:NSError?
        let mydir4 = NSHomeDirectory() + "/Documents/myfolder/info"
        let onepath = mydir4 + "/info.txt"
        let infodict : NSMutableDictionary = ["Languange":currlanguange,"BackgroundImage":currbackgroundimg]
        infodict.writeToFile(onepath, atomically: true)
    }
    func setlanguange(name:String){
        currlanguange = name
        currbackgroundimg = name
        let homeDirectory = NSHomeDirectory()
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as! String
        var fileManager = NSFileManager()
        var error:NSError?
        let mydir4 = NSHomeDirectory() + "/Documents/myfolder/info"
        let onepath = mydir4 + "/info.txt"
        let infodict : NSMutableDictionary = ["Languange":currlanguange,"BackgroundImage":currbackgroundimg]
        infodict.writeToFile(onepath, atomically: true)
    }
    
    func updateinfo(){
        let homeDirectory = NSHomeDirectory()
        let documentPaths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentPath = documentPaths[0] as! String
        var fileManager = NSFileManager()
        var error:NSError?
        let mydir4 = NSHomeDirectory() + "/Documents/myfolder/info"
        let onepath = mydir4 + "/info.txt"
        if(!fileManager.fileExistsAtPath(onepath)){
            print("file does not exist!")
            fileManager.createDirectoryAtPath(mydir4, withIntermediateDirectories: true, attributes: nil, error: &error)
            let infodict : NSMutableDictionary = ["Languange":"English","BackgroundImage":"IMG_6774.PNG"]
            infodict.writeToFile(onepath, atomically: true)
        }
        else{
            print("file exist!")
            let infodict = NSMutableDictionary(contentsOfFile: onepath)
            if let languange = infodict!["Languange"] as? String{
                self.currlanguange = languange
            }
            if let img = infodict!["BackgroundImage"] as? String{
                self.currbackgroundimg = img
            }
        }

    }
}