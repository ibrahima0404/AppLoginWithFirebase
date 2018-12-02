//
//  User.swift
//  AppLoginWithFirebase
//
//  Created by Ibrahima KH GUEYE on 12/12/2017.
//  Copyright © 2017 Ibrahima KH GUEYE. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseDatabase


struct UserInfo {
    var username: String!
    var email: String!
    var photoUrl: String!
    var country: String!
    var ref: DatabaseReference?
    var key: String!
    
    init(snapshot:DataSnapshot) {
        
        key = snapshot.key
        username = (snapshot.value as? NSDictionary)?["username"] as? String ?? ""
        email = (snapshot.value as? NSDictionary)?["email"] as? String ?? ""
        photoUrl = (snapshot.value as? NSDictionary)?["photoUrl"] as? String ?? ""
        country = (snapshot.value as? NSDictionary)?["country"] as? String ?? ""
        ref = snapshot.ref
    }
    
    
}
