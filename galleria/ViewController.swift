//
//  ViewController.swift
//  galleria
//
//  Created by Giorgio Sertori on 20/09/18.
//  Copyright © 2018 Giorgio Sertori. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var buttonTouchID: UIButton!
    @IBOutlet weak var textFieldUsername: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /**
     This method will present an UIAlertViewController to inform the user that the device has not a TouchID sensor.
     */
    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    /**
     This method will present an UIAlertViewController to inform the user that there was a problem with the TouchID sensor.
     
     - parameter error: the error message
     
     */
    func showAlertViewAfterEvaluatingPolicyWithMessage( message:String ){
        
        showAlertWithTitle(title: "Error", message: message)
        
    }
    
    /**
     This method presents an UIAlertViewController to the user.
     
     - parameter title:  The title for the UIAlertViewController.
     - parameter message:The message for the UIAlertViewController.
     
     */
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        DispatchQueue.main.async() { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        }
        
    }
    
    /**
     This method will return an error message string for the provided error code.
     The method check the error code against all cases described in the `LAError` enum.
     If the error code can't be found, a default message is returned.
     
     - parameter errorCode: the error code
     - returns: the error message
     */
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    
    /**
     This method will push the authenticated view controller onto the UINavigationController stack
     */
    func navigateToAuthenticatedViewController(){
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "viewHome")
        self.present(controller, animated: true, completion: nil)
        /*if let loggedInVC = storyboard?.instantiateViewController(withIdentifier: "viewHome") {
            
            DispatchQueue.main.async() { () -> Void in
                
                self.navigationController?.pushViewController(loggedInVC, animated: true)
                
            }
            
        }*/
        
    }
    
    //MARK: Actions
    
    @IBAction func doLogin(_ sender: UIButton) {
            if(textFieldUsername?.text == "giorgio" && textFieldPassword?.text == "password"){
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "viewHome")
                self.present(controller, animated: true, completion: nil)
            }
            else{
                showAlertUsername()
            }
        
        
    }
    
    @IBAction func doLoginTouchID(_ sender: UIButton) {
        if(textFieldUsername?.text == "giorgio"){
            // 1. Create a authentication context
            let authenticationContext = LAContext()
            var error:NSError?
        
            // 2. Check if the device has a fingerprint sensor
            // If not, show the user an alert view and bail out!
            guard authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            
                showAlertViewIfNoBiometricSensorHasBeenDetected()
                return
            
            }
        
            // 3. Check the fingerprint
            authenticationContext.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: "Accedi con un dito",
                reply: { [unowned self] (success, error) -> Void in
                
                    if( success ) {
                        
                        // Fingerprint recognized
                        // Go to view controller
                        self.navigateToAuthenticatedViewController()
                    
                    }else {
                    
                        // Check if there is an error
                        if let error = error {
                        
                            let message = self.errorMessageForLAErrorCode(errorCode: error._code)
                            self.showAlertViewAfterEvaluatingPolicyWithMessage(message: message)
                        
                        }
                    
                    }
                
            })
    
        }
        else{
           showAlertUsername()
        }
    }
    
    func showAlertUsername(){
        let alert = UIAlertController(title: "Errore", message: "Devi inserire uno username esistente prima di proseguire", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true)
    }
}

