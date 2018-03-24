//
//  MonthRates.swift
//  CurrencyCalculator
//
//  Created by Eram on 23/03/2018.
//  Copyright © 2018 Mateusz. All rights reserved.
//

import Foundation
import JSONMagic

class MonthRates {
    //http://api.nbp.pl/api/exchangerates/rates/a/gbp/2012-01-01/2012-01-31/?format=json
    
    var month:Int=1
    var year:Int=2010
    var day:Int=1
    var base:String="EUR"
    //var target:String="PLN"
    var url:String="http://api.nbp.pl/api/exchangerates/rates/a/"
    let semaphore = DispatchSemaphore(value: 0)
    
    var daysCount=1
    
    //let semaphore = DispatchSemaphore(value: 0)
    
    
    let separatedDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    
    var days:[Int]=[]
    var ratesMonth:[Double]=[]
    
    
    
    init(month: Int, year: Int, base: String)
    {
        self.month=month
        self.year=year
        self.base=base
        //addDays()
        //self.target=target
        self.url+=base+"/"
        getDays()
        var startDate="\(year)-"
        var endDate="\(year)-"
        if(month>9)
        {
            endDate+="\(month)-"
            startDate+="\(month)-"
        }
        else
        {
            endDate+="0\(month)-"
            startDate+="0\(month)-"
        }
        if(daysCount>9)
        {
            endDate+="\(daysCount)"
        }
        else
        {
            endDate+="0\(daysCount)"
        }
        startDate+="01"
        self.url+="\(startDate)/\(endDate)/?format=json"
        //addDays()
        getRates()
    }
    
    /*func addDays()->Void
    {
        if(month==separatedDate.month!) && (year==separatedDate.year!)
        {
            for i in 1...separatedDate.day!
            {
                days.append(i)
            }
        }
        else
        {
            let daysCount=daysInMonth()
            for i in 1...daysCount
            {
                days.append(i)
            }
        }
    }*/
    
    func getDays()->Void
    {
        if(month==separatedDate.month!) && (year==separatedDate.year!)
        {
            daysCount=separatedDate.day!
        }
        else
        {
            daysCount=daysInMonth()
        }
    }
    
    func daysInMonth()->Int
    {
        let dateComponents = DateComponents(year: year, month: month)
        let calendar = Calendar.current
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)!
        let numDays = range.count
        return numDays
    }
    
    func getRates()->Void
    {
        print(self.url)
        let url=URL(string: self.url)
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
                        

                        //print(ratesJSON[0])
                        if let ratesD = myJson["rates"] as? [[String:AnyObject]] {
                            for rate in ratesD {
                                let valRate = (rate["mid"] as? Double)!
                                let valDay=(rate["effectiveDate"] as? String)!
                                let dayString=String(valDay.suffix(2))
                                print("\(dayString) : \(valRate)")
                                self.ratesMonth.append(valRate)
                                self.days.append(Int(dayString)!)
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
        //semaphore.wait()
    }
   /*
    func getRate(handler: @escaping ([Double])->())->Void
    {
        //for i in 1...days.count
        //{
            var url2="\(self.url)-\(year)-\(month)-1"
            var ratesTemp:[Double]=[]
            let url=URL(string: url2)
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
                                    self.rates.append((value as? Double)!)
                                }
                                handler(self.rates)
                            }
                        }
                        catch
                        {
                            
                        }
                    }
                }
            }
            task.resume()
        }
    //}
 */
}
