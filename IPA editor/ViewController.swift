//
//  ViewController.swift
//  IPA editor
//
//  Created by Vadim Maslov on 02.11.14.
//  Copyright (c) 2014 Vadim Maslov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    
    @IBOutlet weak var certificatSHA1: NSTextField!
    @IBOutlet weak var ipaFileBtn: NSButton!
    @IBOutlet weak var provisionFileBtn: NSButton!
    @IBOutlet weak var imageFileBtn: NSButton!
    @IBOutlet weak var ipaFileLabel: NSTextField!
    @IBOutlet weak var provisionFileLabel: NSTextField!
    @IBOutlet weak var imageFileLabel: NSTextField!
    var ipaFileLink : String? = ""
    var provisionFileLink : String? = ""
    var appFileName : String? = ""

    
    @IBAction func OpenIpaFile(sender: AnyObject) {
        if let stringArr = openFileWithTypesArray(["ipa"],allowsMultipleSelection: false) {
            for currStr in stringArr {
                let fileUrl : NSURL? = (currStr as NSURL)
                ipaFileLink = fileUrl!.path
            }
            
            
            ipaFileLabel.stringValue = stringArr[0].lastPathComponent
        } else {
            ipaFileLabel.stringValue = ""
        }
    }
    
    @IBAction func openProvisinFile(sender: AnyObject) {
        if let stringArr = openFileWithTypesArray(["mobileprovision"],allowsMultipleSelection: false) {
            for currStr in stringArr {
                let fileUrl : NSURL? = (currStr as NSURL)
                provisionFileLink = fileUrl!.path
            }
            provisionFileLabel.stringValue = stringArr[0].lastPathComponent
        } else {
            provisionFileLabel.stringValue = ""
        }
    }
    
    @IBAction func openImageFile(sender: AnyObject) {
        if let urlArr : Array  = openFileWithTypesArray(["png"],allowsMultipleSelection: true) {
            var url = ""
            for currUrl in urlArr {
                url = "\(url.stringByAppendingString(currUrl.lastPathComponent)) "
            }
            imageFileLabel.stringValue = url
        } else {
            imageFileLabel.stringValue = ""
        }
    }
    
    func openFileWithTypesArray(fileTypesArray:Array<String>,allowsMultipleSelection:Bool) -> Array<AnyObject>? {
        let openDlg : NSOpenPanel       = NSOpenPanel()
        openDlg.canChooseFiles          = true
        openDlg.allowedFileTypes        = fileTypesArray
        openDlg.allowsMultipleSelection = allowsMultipleSelection
        if openDlg.runModal() == NSOKButton {
            return openDlg.URLs
        }
        else {
            return nil
        }
    }
    @IBAction func Generate(sender: AnyObject) {
        uzipIpa()           // unzip the ipa
        removeSignature()   // remove the signature
        replaceProvision()  // replace the provision
        codesign()          // sign with the new certificate
        
    }
    
//    /usr/bin/codesign -f -s "$CERTIFICATE" --resource-rules $id/*.app/ResourceRules.plist $id/*.app

    func codesign(){
        let task : NSTask = NSTask()
        task.launchPath = "/usr/bin/codesign"
        let certificat : String = certificatSHA1.stringValue
        var url = ipaFileLink!.stringByDeletingLastPathComponent+"/Payload/"+appFileName!
        task.arguments = ["-f","-s",certificat,"--resource-rules",url+"/ResourceRules.plist",url]
        task.launch()
        task.waitUntilExit()
        nstaskStatus(task.terminationStatus,name: __FUNCTION__)
    }
    func replaceProvision(){
        let task : NSTask = NSTask()
        task.launchPath = "/bin/cp"
        let provisionUrl : String = provisionFileLink!
        var url = ipaFileLink!.stringByDeletingLastPathComponent+"/Payload/"+appFileName!+"/embedded.mobileprovision"
        task.arguments = [provisionUrl,url]
        task.launch()
        task.waitUntilExit()
        nstaskStatus(task.terminationStatus,name: __FUNCTION__)
    }
    func removeSignature(){
        let task : NSTask = NSTask()
        task.launchPath = "/bin/rm"
        var url : String = ""
        let (filenamesOpt, errorOpt) = contentsOfDirectoryAtPath(ipaFileLink!.stringByDeletingLastPathComponent+"/Payload")
        if let filenames = filenamesOpt{
            appFileName = filenames[0]
            url = ipaFileLink!.stringByDeletingLastPathComponent+"/Payload/"+appFileName!+"/_CodeSignature"

        }
        task.arguments = ["-rf",url]
        task.launch()
        task.waitUntilExit()
        nstaskStatus(task.terminationStatus,name: __FUNCTION__)
    }
    
    func contentsOfDirectoryAtPath(path: String) -> (filenames: [String]?, error: NSError?) {
        var error: NSError? = nil
        let fileManager = NSFileManager.defaultManager()
        let contents = fileManager.contentsOfDirectoryAtPath(path, error: &error)
        if contents == nil {
            return (nil, error)
        }
        else {
            let filenames = contents as [String]
            return (filenames, nil)
        }
    }
    
    func uzipIpa(){
        let task : NSTask = NSTask()
        task.launchPath = "/usr/bin/unzip"
        let url : String = ipaFileLink!
        task.arguments = ["-q","-d",url.stringByDeletingLastPathComponent,url]
        task.launch()
        task.waitUntilExit()
        nstaskStatus(task.terminationStatus,name: __FUNCTION__)
    }
    
    func nstaskStatus(status: Int32, name:String){
        if (status == 0){
            println(name+" Task succeeded.");
        }
        else{
            println(name+" Task failed.");
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
}

