//
//  Currencies.swift
//  CurrencyCalculator
//
//  Created by Eram on 22/03/2018.
//  Copyright © 2018 Mateusz. All rights reserved.
//

import Foundation

class Currencies{
    var myCurrency:[String]=[]
    let url=URL(string: "http://api.fixer.io/latest")
    let semaphore = DispatchSemaphore(value: 0)
    
    init()
    {
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
                                self.myCurrency.append((key as? String)!)
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
