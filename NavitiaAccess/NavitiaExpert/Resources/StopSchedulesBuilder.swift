//
// Created by Chakkra CHAK on 23/02/2017.
// Copyright (c) 2017 Chakkra CHAK. All rights reserved.
//

import Foundation

public class StopSchedulesBuilder : BaseNavitiaResourceBuilder {
    public var distance:Int?
    public var count:Int?
    public var stopSchedules:[StopSchedulesResponse.StopSchedules]

    override public init(token:String, coverage: String) {
        self.stopSchedules = []
        self.distance = 1000
        self.count = 20

        super.init(token: token, coverage: coverage)
    }

    public func withDistance(_ distance: Int) -> StopSchedulesBuilder {
        self.distance = distance
        return self
    }

    public func withCount(_ count: Int) -> StopSchedulesBuilder {
        self.count = count
        return self
    }

    public func build(lon:String, lat:String, callback: @escaping ([StopSchedulesResponse.StopSchedules]) -> (Void)) {
        let url:String = "https://api.navitia.io/v1/coverage/\(self.coverage)/coords/\(lon);\(lat)/stop_schedules?distance=\(self.distance!)&count=\(self.count!)"
        print(url)
        let requestURL: NSURL = NSURL(string: url)!
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

                    let stopSchedulesObject = StopSchedulesResponse(json:json)
                    for stopSchedule in stopSchedulesObject!.stopSchedules {
                        self.stopSchedules.append(stopSchedule)
                    }
                } catch {
                    print("Error with Json: \(error)")
                }
            }
            else {
                print(statusCode)
            }
            DispatchQueue.main.async {
                callback(self.stopSchedules)
            }
        }
        
        task.resume()
    }
}
