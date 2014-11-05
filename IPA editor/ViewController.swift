//
//  ViewController.swift
//  IPA editor
//
//  Created by Vadim Maslov on 02.11.14.
//  Copyright (c) 2014 Vadim Maslov. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var ipaFileBtn: NSButton!
    @IBOutlet weak var provisionFileBtn: NSButton!
    @IBOutlet weak var imageFileBtn: NSButton!
    @IBOutlet weak var ipaFileLabel: NSTextField!
    @IBOutlet weak var provisionFileLabel: NSTextField!
    @IBOutlet weak var imageFileLabel: NSTextField!
    
    @IBAction func OpenIpaFile(sender: AnyObject) {
        if let string = openFileWithTypesArray(["ipa"],allowsMultipleSelection: false)? {
            ipaFileLabel.stringValue = string[0].lastPathComponent
        } else {
            ipaFileLabel.stringValue = ""
        }
    }
    
    @IBAction func openProvisinFile(sender: AnyObject) {
        if let string = openFileWithTypesArray(["mobileprovision"],allowsMultipleSelection: false) {
            provisionFileLabel.stringValue = string[0].lastPathComponent
        } else {
            provisionFileLabel.stringValue = ""
        }
    }
    
    @IBAction func openImageFile(sender: AnyObject) {
        if let urlArr : Array  = openFileWithTypesArray(["png"],allowsMultipleSelection: true) {
            var url : String?
            for currUrl in urlArr {
                url = "\(url!.stringByAppendingString(currUrl.lastPathComponent)) "
            }
            imageFileLabel.stringValue = url!
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

