//
//  DataService.swift
//  SocialApp
//
//  Created by Alfredo M. on 3/12/17.
//  Copyright © 2017 Alfredo M. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

// Declaring a singelton
class DataService {
    
    static let ds = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_POST = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_POST: FIRDatabaseReference {
        return _REF_POST
    }
    
    var REF_USERS: FIRDatabaseReference {
        return _REF_USERS
    }
    
    var REF_BASE: FIRDatabaseReference {
        return _REF_BASE
    }
    
    func createFirebaseDBUser(uid: String, userData:  Dictionary<String, String>) {
        REF_USERS.child(uid).updateChildValues(userData)
    
    
    }

}
