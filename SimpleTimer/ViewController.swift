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

    var tP = TimerPrimitives()
    
    @IBOutlet weak var textWorkout_Outlet: UITextField!
    @IBOutlet weak var textRest_Outlet: UITextField!
    @IBOutlet weak var textRepeat_Outlet: UITextField!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let workoutTimeViewController: SecondViewController =
            segue.destination as! SecondViewController
        
            workoutTimeViewController.receiveWorkoutTime = tP.workoutTime
            workoutTimeViewController.receiveRestTime = tP.restTime
            workoutTimeViewController.receiveRepeatWorkout = tP.repeatWorkout
    }
    
    func updateView(_ workoutTime: String, _ restTime: String, _ repeatWorkout: String)
    {
        textWorkout_Outlet.text = workoutTime
        textRest_Outlet.text = restTime
        textRepeat_Outlet.text = repeatWorkout
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        updateView(String(tP.workoutTime), String(tP.restTime), String(tP.repeatWorkout))
    }
            
    @IBAction func updateModel_WorkoutTime(_ sender: Any) {
        tP.workoutTime = Int(textWorkout_Outlet.text!) ?? 0
    }
    
    @IBAction func updateModel_RestTime(_ sender: Any) {
        tP.restTime = Int(textRest_Outlet.text!) ?? 0
    }
    
    @IBAction func updateModel_RepeatWorkout(_ sender: Any) {
        tP.repeatWorkout = Int(textRepeat_Outlet.text!) ?? 0
    }
}

