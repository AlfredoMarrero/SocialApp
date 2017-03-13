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
let STORAGE_BASE = FIRStorage.storage().reference()

// Declaring a singelton
class DataService {
    
    static let ds = DataService()
    // Database references
    private var _REF_BASE = DB_BASE
    private var _REF_POST = DB_BASE.child("posts")
    private var _REF_USERS = DB_BASE.child("users")
    
    // Storage references
    private var _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")

    
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
    
    // Post images
    var REF_POST_IMAGES: FIRStorageReference {
        return _REF_POST_IMAGES
    }
    
    
    
}
