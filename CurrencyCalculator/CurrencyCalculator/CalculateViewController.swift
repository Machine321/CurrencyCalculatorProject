//
//  CalculateViewController.swift
//  CurrencyCalculator
//
//  Created by Eram on 19/03/2018.
//  Copyright © 2018 Mateusz. All rights reserved.
//

import UIKit

class CalculateViewController: UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
   
    var myCurrency:[String]=[]
    
    
    var activeCurrency="EUR"
    var targetCurrency="GBP"
    
    //Objects
    @IBOutlet weak var valueTextField: UITextField!
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var resultTextField: UILabel!
    @IBOutlet weak var targetCurrencyPicker: UIPickerView!
    
    //Picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return myCurrency.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myCurrency[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 0){
            activeCurrency=myCurrency[row]
        }
        else
        {
            targetCurrency=myCurrency[row]
        }
    }
    //Button
    
    @IBAction func calculateAction(_ sender: Any) {
        
        /*
        print(activeCurrency)
        print(targetCurrency)
         http://api.fixer.io/latest?base=EUR&symbols=GBP
         */
        if let val = Double(valueTextField.text!) {
            if val<=0
            {
                resultTextField.text="Not a valid value: \(valueTextField.text!)"
            }
            else if activeCurrency==targetCurrency
            {
                resultTextField.text="Not a valid target currency: \(targetCurrency)"
            }
            else
            {
                var rate=0.0
                let urlString="http://api.fixer.io/latest?base="+activeCurrency+"&symbols="+targetCurrency
                
                rate=loadJsonData(address: urlString)

                let result=val*rate
                resultTextField.text="\(result)"
                print(result)
            }
        }
        else
        {
            resultTextField.text="Not a valid values: \(valueTextField.text!)"
        }
        
    }
    

    
    func loadJsonData(address: String) -> Double
    {
        var myValues:[Double]=[]
        let semaphore = DispatchSemaphore(value: 0)
        let url2=URL(string: address)
        print(address)
        URLSession.shared.dataTask(with: url2!) { (data, response, error) in
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
                        let myJson2=try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                        
                        
                        if let rates2=myJson2["rates"] as? NSDictionary
                        {
                            for (key,value) in rates2
                            {
                                myValues.append((value as? Double)!)
                            }
                            semaphore.signal()
                        }
                    }
                    catch
                    {
                        
                    }
                }
            }
        }.resume()
        semaphore.wait()
        return myValues[0]
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //http://api.fixer.io/latest
        let url=URL(string: "http://api.fixer.io/latest")
        
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
                        }
                    }
                    catch
                    {
                        
                    }
                }
            }
            self.currencyPicker.reloadAllComponents()
            self.targetCurrencyPicker.reloadAllComponents()
        }
        task.resume()
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
