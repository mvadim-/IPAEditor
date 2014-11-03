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
    
    @IBAction func OpenIpaFile(sender: AnyObject)
    {
        self.ipaFileLabel.stringValue = self.openFileWithTypesArray(["ipa"],allowsMultipleSelection: false)[0].lastPathComponent
    }
    
    @IBAction func openProvisinFile(sender: AnyObject)
    {
        self.provisionFileLabel.stringValue = self.openFileWithTypesArray(["mobileprovision"],allowsMultipleSelection: false)[0].lastPathComponent
    }
    
    @IBAction func openImageFile(sender: AnyObject)
    {
        let urlArr : Array = self.openFileWithTypesArray(["png"],allowsMultipleSelection: true)
        var url : String = ""
        for currUrl in urlArr
        {
            url = "\(url.stringByAppendingString(currUrl.lastPathComponent)) "
        }
        
        self.imageFileLabel.stringValue = url
    }
    
    func openFileWithTypesArray(fileTypesArray:Array<String>,allowsMultipleSelection:Bool) -> Array<AnyObject>
    {
        var openDlg : NSOpenPanel       = NSOpenPanel()
        openDlg.canChooseFiles          = true
        openDlg.allowedFileTypes        = fileTypesArray
        openDlg.allowsMultipleSelection = allowsMultipleSelection
        if openDlg.runModal() == NSOKButton
        {
            return openDlg.URLs
        } else if openDlg.runModal() == NSCancelButton {
            return [""]
        } else{
                        let myPopup:NSAlert = NSAlert()
                        myPopup.messageText = "Error!";
                        myPopup.informativeText = "Something go wrong."
                        myPopup.runModal()
            return [""]
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

