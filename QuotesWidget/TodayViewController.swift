//
//  TodayViewController.swift
//  QuotesWidget
//
//  Created by Pranav Kasetti on 02/09/2016.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit
import NotificationCenter
import QuotesNetworking

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet weak var quoteLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBAction func modeChanged(sender: UISegmentedControl) {
        print("test")
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            networking.randomMoviesQuote { (quote, error) in
                if let quote = quote {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.quoteLabel.text = quote.text
                        self.authorLabel.text = quote.author
                    }
                }
            }
        case 1:
            networking.randomFamousQuote { (quote, error) in
                if let quote = quote {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.quoteLabel.text = quote.text
                        self.authorLabel.text = quote.author
                    }
                }
                
            }
        default:
            networking.randomMoviesQuote { (quote, error) in
                if let quote = quote {
                    dispatch_async(dispatch_get_main_queue()) {
                        self.quoteLabel.text = quote.text
                        self.authorLabel.text = quote.author
                    }
                }
            }
        }
        
    }
    
    
    let networking = Networking()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.quoteLabel.text = nil
        self.authorLabel.text = nil
        
        let userDefaults = NSUserDefaults(suiteName: "group.com.careerfoundry.widgetDemo.QuotesNetworking")
        let index = userDefaults?.integerForKey("segmentedControlIndex")
        if index != nil {
            segmentedControl.selectedSegmentIndex=index!
            if index==0 {
                self.quoteLabel.text = (userDefaults?.objectForKey("moviesQuoteString") as? String)!
                self.authorLabel.text = (userDefaults?.objectForKey("moviesQuoteAuthor") as? String)!
            } else if index==1 {
                self.quoteLabel.text = (userDefaults?.objectForKey("famousQuoteString") as? String)!
                self.authorLabel.text = (userDefaults?.objectForKey("famousQuoteAuthor") as? String)!
            }
        } else {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                networking.randomMoviesQuote { (quote, error) in
                    if let quote = quote {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.quoteLabel.text = quote.text
                            self.authorLabel.text = quote.author
                        }
                    }
                }
            case 1:
                networking.randomFamousQuote { (quote, error) in
                    if let quote = quote {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.quoteLabel.text = quote.text
                            self.authorLabel.text = quote.author
                        }
                    }
                }
            default:
                networking.randomMoviesQuote { (quote, error) in
                    if let quote = quote {
                        dispatch_async(dispatch_get_main_queue()) {
                            self.quoteLabel.text = quote.text
                            self.authorLabel.text = quote.author
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        let index=self.segmentedControl.selectedSegmentIndex
        let userDefaults = NSUserDefaults(suiteName: "group.com.careerfoundry.widgetDemo.QuotesNetworking")
        userDefaults!.setInteger(index, forKey:"segmentedControlIndex")
    }
    
    override func viewDidLoad() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(userDefaultsDidChange(_:)), name:NSUserDefaultsDidChangeNotification, object:nil)
    }
    
    func userDefaultsDidChange(notification: NSNotification) {
        // check updatedDate and update widget UI
        self.updateLabelsText()
    }
    
    func updateLabelsText() {
        let defaults = NSUserDefaults(suiteName: "group.com.careerfoundry.widgetDemo.QuotesNetworking")
        let moviesQuoteString = defaults?.objectForKey("moviesQuoteString") as? String
        let moviesQuoteAuthor = defaults?.objectForKey("moviesQuoteAuthor") as? String
        let famousQuoteString = defaults?.objectForKey("famousQuoteString") as? String
        let famousQuoteAuthor = defaults?.objectForKey("famousQuoteAuthor") as? String
        if ((moviesQuoteString != nil && moviesQuoteAuthor != nil && segmentedControl.selectedSegmentIndex==0) || (famousQuoteString != nil && famousQuoteAuthor != nil && segmentedControl.selectedSegmentIndex==1)) {
            switch segmentedControl.selectedSegmentIndex {
            case 0:
                dispatch_async(dispatch_get_main_queue()) {
                    self.quoteLabel.text=moviesQuoteString!
                    self.authorLabel.text=moviesQuoteAuthor!
                }
            case 1:
                dispatch_async(dispatch_get_main_queue()) {
                    self.quoteLabel.text=famousQuoteString!
                    self.authorLabel.text=famousQuoteAuthor!
                }
            default:
                dispatch_async(dispatch_get_main_queue()) {
                    self.quoteLabel.text=moviesQuoteString!
                    self.authorLabel.text=moviesQuoteAuthor!
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            networking.randomMoviesQuote { (quote, error) in
                guard let quote = quote where error == nil else {
                    completionHandler(.Failed)
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                self.quoteLabel.text = quote.text
                self.authorLabel.text = quote.author
                completionHandler(.NewData)
                }
            }
        case 1:
            networking.randomFamousQuote { (quote, error) in
                guard let quote = quote where error == nil else {
                    completionHandler(.Failed)
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                self.quoteLabel.text = quote.text
                self.authorLabel.text = quote.author
                completionHandler(.NewData)
                }
            }
        default:
            networking.randomMoviesQuote { (quote, error) in
                guard let quote = quote where error == nil else {
                    completionHandler(.Failed)
                    return
                }
                dispatch_async(dispatch_get_main_queue()) {
                self.quoteLabel.text = quote.text
                self.authorLabel.text = quote.author
                completionHandler(.NewData)
                }
            }
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}
