//
//  ViewController.swift
//  CipherCrack
//
//  Created by Joshua Boyd on 7/28/22.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let numberToGuess = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    let lettersToGuess = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j",
                          "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
                          "u", "v", "w", "x", "y", "z"]
    
    // picker data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        8
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        lettersToGuess.count
    }
    
    // picker delegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return lettersToGuess[row]
    }

    var timer = Timer()
    
    static let MAX_TIME_IN_MILLISECONDS = 30000
    
    var timeInMilliSeconds = MAX_TIME_IN_MILLISECONDS
    
    var timerIsRunning = false
    
    @IBOutlet weak var timerDisplay: UILabel!
    
    
    @IBAction func timerStart(_ sender: Any) {
        if(!timerIsRunning) {
            runTimer()
            timerIsRunning = true
        }
    }
    
    @IBAction func timerStop(_ sender: Any) {
        if(timerIsRunning) {
            stopTimer()
            timerIsRunning = false
        }
    }
    
    @IBAction func timerReset(_ sender: Any) {
        if(timerIsRunning) {
            timer.invalidate()
        }
        timeInMilliSeconds = ViewController.MAX_TIME_IN_MILLISECONDS
        timerDisplay.text = formatTimeString(time: TimeInterval(timeInMilliSeconds))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        timerDisplay.text = formatTimeString(time: TimeInterval(timeInMilliSeconds))
    }
    
    func runTimer() {
        DispatchQueue.global(qos: .userInitiated).async {
            print("Running")
            self.timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
            RunLoop.current.add(self.timer, forMode: .common)
            RunLoop.current.run()
        }
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func updateTimer() {
        DispatchQueue.main.async {
            print("Main")
            if(self.timeInMilliSeconds >= 1) {
                self.timeInMilliSeconds -= 1
            }else {
                self.stopTimer()
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

