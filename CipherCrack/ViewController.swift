//
//  ViewController.swift
//  CipherCrack
//
//  Created by Joshua Boyd on 7/28/22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let numberBank = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    let letterBank = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
                          "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
                          "u", "v", "w", "x", "y", "z"]
    
    let correctKey = "abcdefgh"
    
    var timer = Timer()
    
    static let MAX_TIME_IN_MILLISECONDS = 60000
    
    var timeInMilliSeconds = MAX_TIME_IN_MILLISECONDS
    
    var timerIsRunning = false
    var checkingAnswer = false
    
    @IBOutlet weak var timerDisplay: UILabel!
    
    @IBOutlet weak var cipherPicker: UIPickerView!
    
    @IBOutlet weak var backPauseButton: UIButton!
    
    
    @IBAction func timerStop(_ sender: Any) {
        timer.invalidate()
        timerIsRunning = false
        self.navigationController?.popViewController(animated: true)
    }
    
    // picker data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        8
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        letterBank.count
    }
    
    // picker delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        let randRow = Int.random(in: 0...letterBank.count-1)
        
        return letterBank[randRow]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        if(checkingAnswer) {
            if(row == cipherPicker.selectedRow(inComponent: component)){
                if(component == 0) {
                    checkingAnswer = false
                }
                
                // if letter we have in the picker doesn't equal the correct letter in our key then turn that letter red
                if(letterBank[cipherPicker.selectedRow(inComponent: component)] != String(correctKey[correctKey.index(correctKey.startIndex, offsetBy: component)])) {
                    return NSAttributedString(string: letterBank[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.red])
                }
                // if it is correct turn green
                return NSAttributedString(string: letterBank[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.green])
            }
        }

        return NSAttributedString(string: letterBank[row], attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        
    }
    
    
    @IBAction func checkForWin(_ sender: Any) {
        if(timerIsRunning) {
            checkingAnswer = true
            var pickerWord = ""
            
            for index in 0...cipherPicker.numberOfComponents-1 {
                pickerWord.append(letterBank[cipherPicker.selectedRow(inComponent: index)])
            }
            
            if(pickerWord == correctKey) {
                let msg = "You got the correct key!"
                let alertController = UIAlertController(title: "Correct!", message: msg, preferredStyle: .alert)
                let alertCancel = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(alertCancel)
                self.present(alertController, animated: true)
                self.timer.invalidate()
            }else {
                cipherPicker.reloadAllComponents()
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerDisplay.text = formatTimeString(time: TimeInterval(timeInMilliSeconds))
        
        for count in 0...cipherPicker.numberOfComponents-1 {
            let randRow = Int.random(in: 0...letterBank.count-1)
            cipherPicker.selectRow(randRow, inComponent: count, animated: true)
        }
        
        runTimer()
        timerIsRunning = true
    }
    
    func runTimer() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: .common)
            RunLoop.current.run()
        }
    }
    
    @objc func updateTimer() {
        DispatchQueue.main.async {
            if(self.timeInMilliSeconds >= 1) {
                self.timeInMilliSeconds -= 1
            }else {
                self.timer.invalidate()
                let failMsg = "You failed to solve the code!"
                let alertController = UIAlertController(title: "Fail", message: failMsg, preferredStyle: .alert)
                let alertCancel = UIAlertAction(title: "Ok", style: .cancel)
                alertController.addAction(alertCancel)
                self.present(alertController, animated: true)
            }
            
            if(self.timeInMilliSeconds <= 10000) {
                self.timerDisplay.textColor = UIColor.red
            }
            
            self.timerDisplay.text = self.formatTimeString(time: TimeInterval(self.timeInMilliSeconds))
        }
    }

    func formatTimeString(time: TimeInterval) -> String {
        
        let milliseconds = Int(time) % 60
        let seconds = Int(time) / 1000 % 60
        let minutes = Int(time) / 60000 % 60
        let hours = Int(time) / 3600000 % 60
        
        return String(format: "%02i:%02i:%02i:%02i", hours, minutes, seconds, milliseconds)
    }


}

