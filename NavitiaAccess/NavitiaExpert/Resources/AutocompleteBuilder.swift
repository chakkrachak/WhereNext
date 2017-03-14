//
//  AutocompleteBuilder.swift
//  NavitiaAccess
//
//  Created by Chakkra CHAK on 13/03/2017.
//  Copyright © 2017 Chakkra CHAK. All rights reserved.
//

import Foundation

public class AutocompleteBuilder : BaseNavitiaResourceBuilder {
    public var distance:Int?
    public var count:Int?
    public var autocompleteResults:[String]
    
    override public init(token:String, coverage: String) {
        self.autocompleteResults = []
        self.distance = 1000
        self.count = 20
        
        super.init(token: token, coverage: coverage)
    }
    
    public func withDistance(_ distance: Int) -> AutocompleteBuilder {
        self.distance = distance
        return self
    }
    
    public func withCount(_ count: Int) -> AutocompleteBuilder {
        self.count = count
        return self
    }
    
    public func build(query:String, callback: @escaping ([String]) -> (Void)) {
        let url:String = "https://api.navitia.io/v1/coverage/\(self.coverage)/places?q=\(query)&type[]=stop_area&distance=\(self.distance!)&count=\(self.count!)"
        print(url)
        let requestURL: NSURL = NSURL(string: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: requestURL as URL)
        urlRequest.addValue(self.token, forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest as URLRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let json:[String:AnyObject] = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String:AnyObject]
                    
                    let autocompleteResultsObject = AutoCompleteResponse(json:json)
                    if (autocompleteResultsObject != nil) {
                        for autocompleteResult in autocompleteResultsObject!.places {
                            self.autocompleteResults.append(autocompleteResult.name)
                        }
                    }
                } catch {
                    print("Error with Json: \(error)")
                }
            }
            else {
                print(statusCode)
            }
            DispatchQueue.main.async {
                callback(self.autocompleteResults)
            }
        }
        
        task.resume()
    }
}
