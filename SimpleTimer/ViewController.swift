//
//  ViewController.swift
//  SimpleTimer
//
//  Created by Thomas Schauer on 30.08.20.
//  Copyright © 2020 Thomas Schauer. All rights reserved.
//

import UIKit
import AVFoundation


class ViewController: UIViewController, UITextFieldDelegate {

    var tP = TimerPrimitives()
    let appLocalData = UserDefaults.standard
    
    @IBOutlet weak var textWorkout_Outlet: UITextField!
    @IBOutlet weak var textRest_Outlet: UITextField!
    @IBOutlet weak var textRepeat_Outlet: UITextField!
    @IBOutlet weak var lblWorkoutCounter: UILabel!
    
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
        
        let wC = appLocalData.integer(forKey: "wC")
        // Update workout counter label
        lblWorkoutCounter.text = String(wC)
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Declare delgates for text fields
        textWorkout_Outlet.delegate = self
        textRepeat_Outlet.delegate = self
        textRest_Outlet.delegate = self

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
    
    //Calls this function when the tap is recognized.
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    // shouldChangeCharactersIn
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else {
            return false
        }
        let updateText = currentText.replacingCharacters(in: stringRange, with: string)
        
        // Define valid characters for text field input
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        
        // Allow up to 999s timers and numbers only
        return (updateText.count < 4) && (string.rangeOfCharacter(from: invalidCharacters) == nil)
    }
    
    func setWorkoutCnt(_ workoutFinished: Bool) {
        var wC = appLocalData.integer(forKey: "wC")
        if (workoutFinished == true) {
            wC += 1
        }
        appLocalData.set(wC, forKey: "wC")
        lblWorkoutCounter.text = String(wC)
    }

}
