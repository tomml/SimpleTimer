//
//  WorkoutSet.swift
//  SimpleTimer
//
//  Created by Thomas Schauer on 22.10.20.
//  Copyright © 2020 Thomas Schauer. All rights reserved.
//

import UIKit
import AVFoundation

class WorkoutSet {
    
    // The current workout step
    var currentWorkoutStep: Int = 1
    // The maximum workout steps
    var maximumWorkoutSteps: Int = 0
    
    // Timeout of one workout step or rest step
    var workoutStepTimeout: Int = 0
    
    // Indicates the workout/rest step active state
    var isWorkoutStepRunning: Bool = false
    
    // Defines the sound file path for a workout step
    var workoutStepSoundFilePath: String = ""
    
    // Defines the background color for the current workout step
    var workoutStepBackgroundColor: UIColor?
    
    // Sound object
    var workoutStepFinished: AVAudioPlayer? // Property declaration
    
    func soundFile (_ filePath: String) {
    
        let soundOut_Path = Bundle.main.path(forResource: filePath, ofType: nil)!
        let workoutStepFinished_URL = URL(fileURLWithPath: soundOut_Path)
        
        do {
            workoutStepFinished = try AVAudioPlayer(contentsOf: workoutStepFinished_URL)
        }
        catch {
            print("Could not find the sound file")
        }
    }
}

enum WorkoutSetState {
    case workout, rest
}
