//
//  NetworkingService.swift
//  AppLoginWithFirebase
//
//  Created by Ibrahima KH GUEYE on 10/12/2017.
//  Copyright © 2017 Ibrahima KH GUEYE. All rights reserved.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

struct NetworkingService {
    
    enum LoginState {
        case success
        case failed(String)
    }
    
    var loginCallback: ((LoginState)->Void)?
    
    var databaseRef: DatabaseReference {
        return Database.database().reference()
    }
    var storageRef: StorageReference {
        return Storage.storage().reference()
    }
    
    //MARK : save user informations
    private func saveInfo(user: User!, username: String, password: String, country: String) {
        
        // create dictionnary with user infos
        let userInfo = ["email": user.email, "username": username, "country": country, "uid": user.uid, "photoUrl": String(describing: user.photoURL!)]
        
        // create user reference
        let userRef = databaseRef.child("users").child(user.uid)
        
        // save user info in database
        userRef.setValue(userInfo)
        
        signIn(email: user.email!, password: password)
        
    }
    
    func signIn(email: String, password: String) {
       
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil {
                if let user = user {
                    self.loginCallback!(.success)
                    print("\(String(describing: user.displayName)) has signed succesfully")
                }
            }else {
                self.loginCallback!(.failed(error!.localizedDescription))
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    //MARK : set the informations
    private func setUserInfo(user: User!, username: String, password: String, country: String, data: NSData)  {
        
        //create path for user image
        let imagePath = "profileImage\(user.uid)/userPic.jpg"
        
        //create image reference
        let imageRef = storageRef.child(imagePath)
        
        //create Metadata for the image
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        //save the user image in the fireStorage file
        imageRef.putData(data as Data, metadata: metaData) {(metaData, error) in
            if error == nil {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = username
                changeRequest.photoURL = metaData!.downloadURL()
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil {
                        self.saveInfo(user: user, username: username, password: password, country: country)
                    }else {
                        print("Error: \(error!.localizedDescription)")
                    }
                })
            }else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    //MARK : create the user
    func signUp(email: String, username: String, password: String, country: String, data: NSData){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error == nil {
                self.loginCallback!(.success)
                self.setUserInfo(user: user, username: username, password: password, country: country, data: data)
            }else {
                self.loginCallback!(.failed(error!.localizedDescription))
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    func resetPassword(email: String)  {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if error == nil {
                print("An email with information how to reset password has been sent to you. Thank you!")
//                Auth.auth().
            }else {
                print("Error: \(error!.localizedDescription)")
            }
        }
    }
    
    
    
    
}
