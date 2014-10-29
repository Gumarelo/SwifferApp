//
//  ComposeViewController.swift
//  SwifferApp
//
//  Created by Jorge Casariego on 27/10/14.
//  Copyright (c) 2014 Jorge Casariego. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var sweetTextView: UITextView!
    @IBOutlet var charRemainingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        sweetTextView.layer.borderColor = UIColor.blackColor().CGColor
        sweetTextView.layer.borderWidth = 0.5
        sweetTextView.layer.cornerRadius = 5
        sweetTextView.delegate = self
        charRemainingLabel.text = "140"
        
        sweetTextView.becomeFirstResponder()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:  aDecoder)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendSweet(sender: AnyObject) {
        
        var sweet:PFObject = PFObject(className: "Sweets")
        sweet["content"] = sweetTextView.text
        sweet["sweeter"] = PFUser.currentUser()
        
        sweet.save()
        
        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    
    func textView(textView: UITextView,
        shouldChangeTextInRange range: NSRange,
        replacementText text: String) -> Bool{
            
            var newLenght:Int = (textView.text as NSString).length + (text as NSString).length - range.length
            var remainingCharacter:Int = 140 - newLenght
            
            charRemainingLabel.text = "\(remainingCharacter)"
            
            return (newLenght > 140) ? false : true
            
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
