//
//  MonthCurrencyChartViewController.swift
//  CurrencyCalculator
//
//  Created by Eram on 19/03/2018.
//  Copyright © 2018 Mateusz. All rights reserved.
//

import UIKit
import MonthYearPicker

class MonthCurrencyChartViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    

    let currencies=Currencies()
    var activeCurrency="PLN"
    var targetCurrency="EUR"
    
    
    let separatedDate = Calendar.current.dateComponents([.year, .month, .day], from: Date())
    var year=2018
    var month=1
    
    @IBOutlet weak var firstPicker: UIPickerView!
    @IBOutlet weak var secondPicker: UIPickerView!
    @IBOutlet weak var errorLabel: UILabel!
    
    //Pickers
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies.myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0){
            activeCurrency=currencies.myCurrency[row]
        }
        else
        {
            targetCurrency=currencies.myCurrency[row]
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let d=CGPoint(x: 0, y: 90)
        let s=CGSize(width: view.bounds.width, height: 50)
        let c=CGRect.init(origin: d, size: s)
        let picker = MonthYearPickerView(frame: c)
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.view.addSubview(picker)
        
        year=separatedDate.year!
        month=separatedDate.month!
        
        activeCurrency=currencies.myCurrency[0]
        targetCurrency=currencies.myCurrency[0]
        
        // Do any additional setup after loading the view.
    }
    //let test=NTMonthYearPicker()
    //@IBOutlet weak var test: NTMonthYearPickerView!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    @objc func dateChanged(_ sender: MonthYearPickerView) {
        print(sender.date)
    /*
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: sender.date)
        if let day = componenets.day, let month = componenets.month, let year = componenets.year {
            print("\(day) \(month) \(year)")
        }
    */
    }
    */
    @objc func dateChanged(_ picker: MonthYearPickerView) {
        let componenets = Calendar.current.dateComponents([.year, .month, .day], from: picker.date)
        year=componenets.year!
        month=componenets.month!
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        var checker=false
        if(year<2010) || (year>separatedDate.year!)
        {
            errorLabel.text="Select year greater than 2010!"
        }
        else if(month>separatedDate.month!) && (year==separatedDate.year)
        {
            errorLabel.text="Select month from past!"
            
        }
        else if(activeCurrency==targetCurrency)
        {
            errorLabel.text="Select different target currency!"
        }
        else
        {
            errorLabel.text=""
            checker=true
        }
        return checker
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
