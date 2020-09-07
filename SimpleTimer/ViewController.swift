//
//  ViewController.swift
//  SimpleTimer
//
//  Created by Thomas Schauer on 30.08.20.
//  Copyright © 2020 Thomas Schauer. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {

    var workoutTime = 50
    var restTime = 35
    var repeatWorkout = 3
    
    @IBOutlet weak var textWorkout_Outlet: UITextField!
    @IBOutlet weak var textRest_Outlet: UITextField!
    @IBOutlet weak var textRepeat_Outlet: UITextField!
    
    
    @IBAction func editChanged(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let workoutTimeViewController: SecondViewController =
            segue.destination as! SecondViewController
        
            workoutTimeViewController.receiveWorkoutTime = workoutTime
            //workoutTimeViewController.receiveRestTime = restTime
            workoutTimeViewController.receiveRepeatWorkout = repeatWorkout
    }
  
    override func viewDidLoad()
    {
        super.viewDidLoad()
        resetToDefaults()
    }
    
    func resetToDefaults()
    {
        // Reset to defaults
        workoutTime = 50
        textWorkout_Outlet.text = String(workoutTime)
        restTime = 35
        textRest_Outlet.text = String(restTime)
        repeatWorkout = 3
        textRepeat_Outlet.text = String(repeatWorkout)
    }
}

