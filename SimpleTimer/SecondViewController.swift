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
    
    var lblText: String = "Workout"

    @IBOutlet weak var btnPauseWorkout: UIButton!
    @IBOutlet weak var lblWorkoutTime: UILabel!
    @IBOutlet weak var lblRepeat: UILabel!
    @IBOutlet weak var lblPrepare: UILabel!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //appLocalData.set(workoutCounter, forKey: "workoutCounter")
        
        // Set the initial timing values for the workout
        workout.workoutStepTimeout = receiveWorkoutTime
        workout.maximumWorkoutSteps = receiveRepeatWorkout
        
        // Setup the initial sound file path
        workout.soundFile("workoutSetFinished.wav")
    
        // Setup the initial view elements
        setupWorkoutView((String(countdownTime)), true,
                                 "", false,
                                 "Prepare!", true,
                                 false)
    }
    
    func workoutFinished() -> Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // (Re-)start counters
        if (workout.isWorkoutStepRunning == false) {
            // Setup countdown timer
            startTimer(#selector(countdownAction))
        }
        else {
            // Setup workout timer
            startTimer(#selector(workoutAction))
        }
    }
    
    @objc func countdownAction() {
        // Decrease countdown timer
        countdownTime -= 1
        // Update label
        lblWorkoutTime.text = String(countdownTime)
        
        if (countdownTime == 0) {
            // Stop countdown timer
            timer.invalidate()
            // Start workout timer
            startTimer(#selector(workoutAction))
            workout.isWorkoutStepRunning = true
            // Setup background
            setBackgroundColor(UIColor.systemBlue, UIColor.systemBlue)
            // Setup view elements
            setupWorkoutView((String(workout.workoutStepTimeout)), true,
                         lblText+" "+String(workout.currentWorkoutStep)+"/"+String(workout.maximumWorkoutSteps), true,
                         "", false,
                         true)
        }
        
    }
    
    @objc func workoutAction() {
    
        // Decrease counter value every seconds
        workout.workoutStepTimeout -= 1
    
        // Preload the buffers once the workout timer reaches 2s
        if (workout.workoutStepTimeout == 2) {
            workout.workoutStepFinished?.prepareToPlay() // Prepare to play the sound
        }
    
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
                    // Set Label text
                    lblText = "Rest"
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
                    // Set Label text
                    lblText = "Workout"
                }
                startTimer(#selector(workoutAction))
                workout.isWorkoutStepRunning = true
            }
            else {
                // Whole workout set finished
                navigationController?.popViewController(animated: true)
                if let vc = presentingViewController as? ViewController {
                    dismiss(animated: true, completion: { vc.setWorkoutCnt(true) } ) }
            }
        }
    
        setupWorkoutView((String(workout.workoutStepTimeout)), true,
                         lblText+" "+String(workout.currentWorkoutStep)+"/"+String(workout.maximumWorkoutSteps), true,
                         "", false,
                         true)
    }
    
    func startTimer(_ selectorFunc: Selector) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (selectorFunc), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func setupWorkoutView(_ timerLabelText: String, _ isTimerLabelActive: Bool,
                          _ workoutStepLabelText: String, _ showWorkoutStepLabel: Bool,
                          _ prepareLabelText: String, _ showPrepareLabel: Bool,
                          _ showPauseBtn: Bool) {
           
        // Update timer label
        if (isTimerLabelActive == true) {
            lblWorkoutTime.text = timerLabelText
        } else {
            lblWorkoutTime.text = ""
        }
        
        // Update workout step label
        if (showWorkoutStepLabel == true) {
            lblRepeat.text = workoutStepLabelText
        } else {
            lblRepeat.text = ""
        }
        
        // Update prepare label
        if (showPrepareLabel == true) {
            lblPrepare.text = prepareLabelText
        } else {
            lblPrepare.text = ""
        }
        
        // Update button visibility
        if (showPauseBtn == true) {
            btnPauseWorkout.isHidden = false
        } else {
            btnPauseWorkout.isHidden = true
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
