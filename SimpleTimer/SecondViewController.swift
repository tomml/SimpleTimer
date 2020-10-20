//
//  SecondViewControlerViewController.swift
//  SimpleTimer
//
//  Created by Thomas Schauer on 06.09.20.
//  Copyright © 2020 Thomas Schauer. All rights reserved.
//

import UIKit
import AVFoundation

class SecondViewController: UIViewController {
    
    var workoutTime = 5
    var RestTime = 35
    var RepeatWorkout = 3
    
    var timer = Timer()
    var receiveWorkoutTime: Int = 0
    var receiveRestTime: Int = 0
    var receiveRepeatWorkout: Int = 0
    
    var startTimer = false
    
    var workoutStepFinished: AVAudioPlayer? // Property declaration

    @IBOutlet weak var btnPauseWorkout: UIButton!
    @IBOutlet weak var lblWorkoutTime: UILabel!
    @IBOutlet weak var lblRepeat: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SecondViewController.counter), userInfo: nil, repeats: true)
        startTimer = true
        
        let workoutStepFinished_Path = Bundle.main.path(forResource: "workoutSetFinished.wav", ofType: nil)! // Declare sound file path
        let workoutStepFinished_URL = URL(fileURLWithPath: workoutStepFinished_Path)
        
        do{
            workoutStepFinished = try AVAudioPlayer(contentsOf: workoutStepFinished_URL)
        }
        catch{
            print("Could not find the sound file")
        }
        
        lblWorkoutTime.text = String(receiveWorkoutTime)
        lblRepeat.text = "Workout 1/"+String(receiveRepeatWorkout)
        workoutTime = receiveWorkoutTime
    }
    
    @objc func counter()
    {
        workoutTime -= 1 // Decrease counter every seconds by one
        lblWorkoutTime.text = String(workoutTime)
        
        if (workoutTime == 0)
        {
            timer.invalidate()
            handleWorkoutSetFinishedAlert(true)
        }
    }

    @IBAction func btnPauseWorkout(_ sender: Any)
    {
        if (startTimer == true)
        {
            startTimer = false
            timer.invalidate()
        }
        else
        {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(SecondViewController.counter), userInfo: nil, repeats: true)
            startTimer = true
        }
    }
    func handleWorkoutSetFinishedAlert (_ state: Bool)
    {
        if (state == true) {
            workoutStepFinished?.play() // Play the sound
        }
        else {
            workoutStepFinished?.stop() // Stop playing the sound
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
