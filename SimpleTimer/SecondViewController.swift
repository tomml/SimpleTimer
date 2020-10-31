//
//  SecondViewControlerViewController.swift
//  SimpleTimer
//
//  Created by Thomas Schauer on 06.09.20.
//  Copyright © 2020 Thomas Schauer. All rights reserved.
//

import UIKit


class SecondViewController: UIViewController {
    
    var timer = Timer()
    let workout = WorkoutSet()
    var workoutState = WorkoutSetState.workout
    
    var receiveWorkoutTime: Int = 0
    var receiveRestTime: Int = 0
    var receiveRepeatWorkout: Int = 0
    
    var countdownTime: Int = 10

    @IBOutlet weak var btnPauseWorkout: UIButton!
    @IBOutlet weak var lblWorkoutTime: UILabel!
    @IBOutlet weak var lblRepeat: UILabel!
    @IBOutlet weak var lblPrepare: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Set the initial timing values for the workout
        workout.workoutStepTimeout = receiveWorkoutTime
        workout.maximumWorkoutSteps = receiveRepeatWorkout
        
        // Setup the initial sound file path
        workout.soundFile("workoutSetFinished.wav")
    
        // Setup countdown
        startTimer(#selector(countdownAction))
        
        // Setup the initial view elements
        updateWorkoutView((String(countdownTime)), false, "", false)
    }
    
    @objc func countdownAction() {
        // Decrease countdown timer
        countdownTime -= 1
        // Update label
        lblWorkoutTime.text = String(countdownTime)
        
        if (countdownTime == 0) {
            // Stop countdown timer
            timer.invalidate()
            // Prepare workout phase
            setBackgroundColor(UIColor.systemBlue, UIColor.systemBlue)
            lblPrepare.text = ""
            // Start workout timer
            startTimer(#selector(workoutAction))
            workout.isWorkoutStepRunning = true
        }
        
    }
    
    @objc func workoutAction() {
    
        // Decrease counter value every seconds
        workout.workoutStepTimeout -= 1
    
        if (workout.workoutStepTimeout == 0) {
            stopTimer()
            workout.isWorkoutStepRunning = false
            
            if (workout.currentWorkoutStep < workout.maximumWorkoutSteps) {
                // Check the current phase state
                if (workoutState == .workout) {
                    // Setup counter for rest phase
                    workout.workoutStepTimeout = receiveRestTime
                    // Prepare background color for rest phase
                    setBackgroundColor(UIColor.systemRed, UIColor.systemRed)
                    // Play sound
                    handleWorkoutSetFinishedAlert(true)
                    // Switch phase
                    workoutState = .rest
                }
                else {
                    // Setup counter for workout phase
                    workout.workoutStepTimeout = receiveWorkoutTime
                    // Prepare background color for rest phase
                    setBackgroundColor(UIColor.systemBlue, UIColor.systemBlue)
                    // Increase workout set counter
                    workout.currentWorkoutStep += 1
                    // Switch phase
                    workoutState = .workout
                }
                startTimer(#selector(workoutAction))
                workout.isWorkoutStepRunning = true
            }
            else {
                // Whole workout set finished
                navigationController?.popViewController(animated: true)
                dismiss(animated: true, completion: nil)
            }
        }
    
        updateWorkoutView((String(workout.workoutStepTimeout)), true, "Workout "+String(workout.currentWorkoutStep)+"/"+String(workout.maximumWorkoutSteps), true)
    }
    
    func startTimer(_ selectorFunc: Selector) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (selectorFunc), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func updateWorkoutView(_ timerLabel: String, _ showWorkoutLabel: Bool, _ workoutLblText: String, _ showPauseBtn: Bool) {
        // Update timeout label
        lblWorkoutTime.text = timerLabel
        // Update workout step label
        if (showWorkoutLabel == true) {
            // Update content
            lblRepeat.text = workoutLblText
        } else {
            lblRepeat.text = ""
        }
        if (showPauseBtn == true) {
            btnPauseWorkout.isEnabled = true
            btnPauseWorkout.setTitle("Pause", for: .normal)
        } else {
            btnPauseWorkout.isEnabled = false
            btnPauseWorkout.setTitle("", for: .normal)
        }
    }
    
    func setBackgroundColor(_ colorOfView: UIColor, _ colorOfWorkoutLbl: UIColor) {
        // Prepare background color of View and Label
        view.backgroundColor = colorOfView
        lblWorkoutTime.backgroundColor = colorOfWorkoutLbl
    }
    
    @IBAction func btnPauseWorkout(_ sender: Any)
    {
        if (workout.isWorkoutStepRunning == true) {
            stopTimer()
            workout.isWorkoutStepRunning = false
        }
        else {
            startTimer(#selector(workoutAction))
            workout.isWorkoutStepRunning = true
        }
    }
    
    func handleWorkoutSetFinishedAlert (_ state: Bool)
    {
        if (state == true) {
            workout.workoutStepFinished?.play() // Play the sound
        }
        else {
            workout.workoutStepFinished?.stop() // Stop playing the sound
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
