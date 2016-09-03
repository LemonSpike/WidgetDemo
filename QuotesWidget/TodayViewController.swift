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
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                }
            }
        case 1:
            networking.randomFamousQuote { (quote, error) in
                if let quote = quote {
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                }
                
            }
        default:
            networking.randomMoviesQuote { (quote, error) in
                if let quote = quote {
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                }
            }
        }
        
    }
    
    
    let networking = Networking()
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.quoteLabel.text = nil
        self.authorLabel.text = nil
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            networking.randomMoviesQuote { (quote, error) in
                if let quote = quote {
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                }
            }
        case 1:
            networking.randomFamousQuote { (quote, error) in
                if let quote = quote {
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                }
            }
        default:
            networking.randomMoviesQuote { (quote, error) in
                if let quote = quote {
                    self.quoteLabel.text = quote.text
                    self.authorLabel.text = quote.author
                }
            }
        }
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
            self.quoteLabel.text=moviesQuoteString!
            self.authorLabel.text=moviesQuoteAuthor!
        case 1:
            self.quoteLabel.text=famousQuoteString!
            self.authorLabel.text=famousQuoteAuthor!
        default:
            self.quoteLabel.text=moviesQuoteString!
            self.authorLabel.text=moviesQuoteAuthor!
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
                self.quoteLabel.text = quote.text
                self.authorLabel.text = quote.author
                completionHandler(.NewData)
            }
        case 1:
            networking.randomFamousQuote { (quote, error) in
                guard let quote = quote where error == nil else {
                    completionHandler(.Failed)
                    return
                }
                self.quoteLabel.text = quote.text
                self.authorLabel.text = quote.author
                completionHandler(.NewData)
            }
        default:
            networking.randomMoviesQuote { (quote, error) in
                guard let quote = quote where error == nil else {
                    completionHandler(.Failed)
                    return
                }
                
                self.quoteLabel.text = quote.text
                self.authorLabel.text = quote.author
                completionHandler(.NewData)
            }
        }
    }
    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
}
