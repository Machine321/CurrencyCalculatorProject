//
//  CurrencyRates.swift
//  CurrencyCalculator
//
//  Created by Eram on 22/03/2018.
//  Copyright © 2018 Mateusz. All rights reserved.
//

import Foundation

class CurrencyRates{
    var myCurrences:[String]=[]
    var myRates:[Double]=[]
    //var baseRate:String=""
    var url="http://api.fixer.io/latest?base="
    
    let semaphore = DispatchSemaphore(value: 0)
    
    init(baseRate: String)
    {
        //self.baseRate=baseRate
        let url=URL(string: self.url+baseRate)
        let task=URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error != nil
            {
                print("ERROR")
            }
            else
            {
                if let content=data
                {
                    do
                    {
                        let myJson=try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        if let rates=myJson["rates"] as? NSDictionary
                        {
                            for (key,value) in rates
                            {
                                self.myCurrences.append((key as? String)!)
                                self.myRates.append((value as? Double)!)
                            }
                            self.semaphore.signal()
                        }
                    }
                    catch
                    {
                        
                    }
                }
            }
        }
        task.resume()
        semaphore.wait()
    }
}
