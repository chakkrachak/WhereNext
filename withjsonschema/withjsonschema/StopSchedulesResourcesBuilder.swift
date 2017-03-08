//
// Created by Chakkra CHAK on 08/03/2017.
// Copyright (c) 2017 Kisio Digital. All rights reserved.
//

import Foundation

public class StopSchedulesResourcesBuilder {
    public var coverage: String
    public var token: String
    public var distance: Int?
    public var count: Int?

    public init(token: String, coverage: String) {
        self.token = token
        self.coverage = coverage

        self.distance = 1000
        self.count = 20
    }

    public func build() {
        let url: String = "https://api.navitia.io/v1/coverage/\(self.coverage)/coords/2.377310;48.847002/stop_schedules?distance=\(self.distance!)&count=\(self.count!)"
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
                do {
                    let json: [String: AnyObject] = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]

                    let jsonStopSchedules: [[String: AnyObject]] = json["stop_schedules"] as! [[String: AnyObject]]
                    for stopSchedule in jsonStopSchedules {
                        let currentStopSchedule:String = self.parseJsonResponse(stopSchedule)
                        print(currentStopSchedule)
                    }
                } catch {
                    print("Error with Json: \(error)")
                }
            } else {
                print(statusCode)
            }
        }

        task.resume()
    }

    func parseJsonResponse(_ stopSchedulesJsonResponse: [String: AnyObject]) -> String {
        let stopPoint = stopSchedulesJsonResponse["stop_point"] as! [String: AnyObject]
        let dateTimes = stopSchedulesJsonResponse["date_times"] as! [[String: AnyObject]]
        // let displayInformations = stopSchedulesJsonResponse["display_informations"] as! [String: AnyObject]

        if dateTimes.count > 0 {
            return stopPoint["label"] as! String
        }

        return ""
    }
}
