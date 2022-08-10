//
//  GameViewController.swift
//  CipherCrack
//
//  Created by Joshua Boyd on 7/28/22.
//

import UIKit

class GameViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let numberBank = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    let letterBank = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
                          "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
                          "u", "v", "w", "x", "y", "z"]
    
    let correctLetterTestKey = "abcdefgh"
    let correctNumberTestKey = "12345678"
    
    var timer = Timer()
    
    static let MAX_TIME_IN_MILLISECONDS = 60000
    
    var timeInMilliSeconds = MAX_TIME_IN_MILLISECONDS
    
    var timerIsRunning = false
    var checkingAnswer = false
    
    @IBOutlet weak var timerDisplay: UILabel!
    
    @IBOutlet weak var cipherPicker: UIPickerView!
    
    @IBOutlet weak var backPauseButton: UIButton!
    
    // the button that got us here, which corresponds to which game mode we are in
    var sourceButtonTag = 0
    
    
    @IBAction func timerStop(_ sender: Any) {
        timer.invalidate()
        timerIsRunning = false
        self.navigationController?.popViewController(animated: false)
    }
    
    // picker data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        8
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 40.0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(sourceButtonTag == 1) {
            return letterBank.count
        } else {
            return numberBank.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Times New Roman", size: 35.0)
            pickerLabel?.textAlignment = .center
        }
        
        if(sourceButtonTag == 1) {
            pickerLabel?.text = letterBank[row]
        } else {
            pickerLabel?.text = String(numberBank[row])
        }
        
        if(checkingAnswer) {
            if(row == cipherPicker.selectedRow(inComponent: component)){
                if(component == 0) {
                    checkingAnswer = false
                }
                if(sourceButtonTag == 1) {
                    // this is just needless redundancy until the correct key
                    // randomizer is created. CHANGE THIS ONCE IT IS!!
                    if(letterBank[cipherPicker.selectedRow(inComponent: component)] ==
                       String(correctLetterTestKey[correctLetterTestKey.index(correctLetterTestKey.startIndex, offsetBy: component)])) {
                        pickerLabel?.textColor = UIColor.green
                        return pickerLabel!
                    } else {
                        pickerLabel?.textColor = UIColor.red
                        return pickerLabel!
                    }
                } else {
                    if(String(numberBank[cipherPicker.selectedRow(inComponent: component)]) ==
                       String(correctNumberTestKey[correctNumberTestKey.index(correctNumberTestKey.startIndex, offsetBy: component)])) {
                        pickerLabel?.textColor = UIColor.green
                        return pickerLabel!
                    } else {
                        pickerLabel?.textColor = UIColor.red
                        return pickerLabel!
                    }
                }
            }
        }
        
        pickerLabel?.textColor = UIColor.white
        
        return pickerLabel!
    }
    
    
    @IBAction func checkForWin(_ sender: Any) {
        if(timerIsRunning) {
            checkingAnswer = true
            var pickerWord = ""
            
            for index in 0...cipherPicker.numberOfComponents-1 {
                if(sourceButtonTag == 1) {
                    pickerWord.append(letterBank[cipherPicker.selectedRow(inComponent: index)])
                } else {
                    pickerWord.append(String(numberBank[cipherPicker.selectedRow(inComponent: index)]))
                }
            }
            
            if(pickerWord == correctLetterTestKey || pickerWord == correctNumberTestKey) {
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
            var randRow = 0
            if(sourceButtonTag == 1) {
                randRow = Int.random(in: 0...letterBank.count-1)
            } else {
                randRow = Int.random(in: 0...letterBank.count-1)
            }
            cipherPicker.selectRow(randRow, inComponent: count, animated: true)
        }
        
        runTimer()
        timerIsRunning = true
        
        print("Game Mode: \(sourceButtonTag)")
    }
    
    func runTimer() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(GameViewController.updateTimer)), userInfo: nil, repeats: true)
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
