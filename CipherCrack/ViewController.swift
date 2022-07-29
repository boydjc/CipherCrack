//
//  ViewController.swift
//  CipherCrack
//
//  Created by Joshua Boyd on 7/28/22.
//

import UIKit

class ViewController: UIViewController {

    var timer = Timer()
    
    static let MAX_TIME_IN_MILLISECONDS = 3600000
    
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
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    @objc func updateTimer() {
        if(timeInMilliSeconds >= 1) {
            timeInMilliSeconds -= 1
        }else {
            stopTimer()
        }
        
        if(timeInMilliSeconds <= 10000) {
            timerDisplay.textColor = UIColor.red
        }
        
        timerDisplay.text = formatTimeString(time: TimeInterval(timeInMilliSeconds))
    }

    func formatTimeString(time: TimeInterval) -> String {
        
        let milliseconds = Int(time) % 60
        let seconds = Int(time) / 1000 % 60
        let minutes = Int(time) / 60000 % 60
        let hours = Int(time) / 3600000 % 60
        
        return String(format: "%02i:%02i:%02i:%02i", hours, minutes, seconds, milliseconds)
    }


}

