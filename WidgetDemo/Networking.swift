//
//  Networking.swift
//  WidgetDemo
//
//  Created by Hesham Abd-Elmegid on 6/27/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import Foundation

public class Networking: NSObject {
    
    public typealias CompletionHandler = (quote: Quote?, error: NSError?) -> ()
    
    public func randomMoviesQuote(completion: CompletionHandler) {
        let apiURL = NSURL(string: "https://andruxnet-random-famous-quotes.p.mashape.com/?cat=movies")
        let request = NSMutableURLRequest(URL: apiURL!)
        request.HTTPMethod = "POST"
        request.addValue("70kHu82V9Jmshv3cD2gNkUF915jsp1K0HlYjsnVcns7jvOI4O1", forHTTPHeaderField: "X-Mashape-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let data = data where error == nil else {
                print(error)
                return
            }
            
            do {
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:String]
                let quote = Quote(quoteDictionary: jsonResponse)
                let userDefaults = NSUserDefaults(suiteName: "com.careerfoundry.widgetDemo.QuotesNetworking")
                userDefaults!.setObject(quote, forKey:"moviesQuote")
                userDefaults?.synchronize()
                completion(quote: quote, error: nil)
            } catch {
                print("JSON error: \(error)")
            }
        }
        
        task.resume()
        
        
    }
    
    public func randomFamousQuote(completion: CompletionHandler) {
        let apiURL = NSURL(string: "https://andruxnet-random-famous-quotes.p.mashape.com/?cat=famous")
        let request = NSMutableURLRequest(URL: apiURL!)
        request.HTTPMethod = "POST"
        request.addValue("70kHu82V9Jmshv3cD2gNkUF915jsp1K0HlYjsnVcns7jvOI4O1", forHTTPHeaderField: "X-Mashape-Key")
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            guard let data = data where error == nil else {
                print(error)
                return
            }
            
            do {
                let jsonResponse = try NSJSONSerialization.JSONObjectWithData(data, options: []) as! [String:String]
                let quote = Quote(quoteDictionary: jsonResponse)
                let userDefaults = NSUserDefaults(suiteName: "com.careerfoundry.widgetDemo.QuotesNetworking")
                userDefaults!.setObject(quote, forKey:"famousQuote")
                userDefaults?.synchronize()
                completion(quote: quote, error: nil)
            } catch {
                print("JSON error: \(error)")
            }
        }
        
        task.resume()
        
        
    }
}
