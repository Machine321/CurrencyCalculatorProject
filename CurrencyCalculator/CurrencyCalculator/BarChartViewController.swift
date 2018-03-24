//
//  BarChartViewController.swift
//  CurrencyCalculator
//
//  Created by Eram on 23/03/2018.
//  Copyright © 2018 Mateusz. All rights reserved.
//

import UIKit
import Charts

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

class BarChartViewController: UIViewController {

    @IBOutlet weak var barChartView: BarChartView!
    var month:Int=1
    var year:Int=2010
    var base:String="USD"
    
    
    var rates:[Double]=[]
    var days:[Int]=[]
    var daysCount:Int=1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var ratesComponent=MonthRates(month: self.month, year: self.year, base: self.base)
        rates=ratesComponent.ratesMonth
        days=ratesComponent.days
        daysCount=ratesComponent.daysCount
        print(self.rates)
        
        setChart()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    func setChart() {
        barChartView.noDataText = "No data."
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<rates.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: rates[i])
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Currency rates")
        let chartData = BarChartData(dataSet: chartDataSet)

        barChartView.data = chartData
        barChartView.chartDescription?.text = "Number of Widgets by Type"
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
