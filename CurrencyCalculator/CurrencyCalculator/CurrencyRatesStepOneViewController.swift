//
//  CurrencyRatesStepOneViewController.swift
//  CurrencyCalculator
//
//  Created by Eram on 22/03/2018.
//  Copyright © 2018 Mateusz. All rights reserved.
//

import UIKit

class CurrencyRatesStepOneViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
    
    let currences=Currencies()
    var activeCurrency="EUR"
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currences.myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currences.myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activeCurrency=currences.myCurrency[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as! RatesTableViewController
        secondViewController.rates=CurrencyRates(baseRate: activeCurrency)
    }
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
