//
//  PasswordChecker.swift
//  LetsGo
//
//  Created by Li-Yi Lin on 12/2/15.
//  Copyright © 2015 LetsGo.jhu.oose2015. All rights reserved.
//

import Foundation

/**
 A password complexity checker. It includes the following rules:
 1. The length must be longer than 8.
 2. The password must contains at least one lowercase character
 3. The password must contains at least one uppercase character
 4. The password must contains at least one number
 5. the password must contains at least one special character, e.g. #, @, %, ...
 */
class PasswordChecker {
    
    func checkTextSufficientComplexity(let text : String) -> (pass:Bool, errmsg:String) {
        
        // check the length of the password.
        let result1 = checkLength(text)
        if !result1.pass {
            return result1
        }
        
        // check whether the password contains at least one uppercase character.
        let result2 = checkCapital(text)
        if !result2.pass {
            return result2
        }
        
        // check whether the password contains at least one lowercase character.
        let result3 = checkLowercase(text)
        if !result3.pass {
            return result3
        }
        
        // check whether the password contains at least one number chararcter.
        let result4 = checkHasNumber(text)
        if !result4.pass {
            return result4
        }

        // check whether the password contains at least one special character.
        let result5 = checkSpecialCharacter(text)
        if !result5.pass {
            return result5
        }

        // pass all the test
        return (true, errmsg: "")
    }
    
    /// check the length of the password.
    private func checkLength(text: String) -> (pass: Bool, errmsg: String){
        if text.characters.count < 8 {
            return (false, errmsg: "The password must contain at least 8 characters.")
        } else {
            return (true, errmsg:"")
        }
    }
    
    /// check whether the password contains at least one uppercase character.
    private func checkCapital(text:String) -> (pass: Bool, errmsg: String){
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest0 = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        if !texttest0.evaluateWithObject(text) {
            return (false, errmsg: "The password must contain at least one uppercase character.")
        } else {
            return (true, errmsg:"")
        }
    }
    
    /// check whether the password contains at least one lowercase character.
    private func checkLowercase(text:String) -> (pass: Bool, errmsg: String) {
        let lowercaseLetterRegEx  = ".*[a-z]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", lowercaseLetterRegEx)
        if !texttest1.evaluateWithObject(text) {
            return (false, errmsg: "The password must contain at least one lowercase character.")
        } else {
            return (true, errmsg:"")
        }
    }
    
    /// check whether the password contains at least one number chararcter.
    private func checkHasNumber(text:String) -> (pass: Bool, errmsg:String) {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        if !texttest2.evaluateWithObject(text) {
            return (false, errmsg: "The password must contain at least one number.")
        } else {
            return (true, errmsg:"")
        }
    }
    
    /// check whether the password contains at least one special character.
    private func checkSpecialCharacter(text:String) -> (pass:Bool, errmsg:String) {
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest3 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        if !texttest3.evaluateWithObject(text) {
            return (false, errmsg: "The password must contain at least one special character.")
        } else {
            return (true, errmsg:"")
        }
    }
    
}

