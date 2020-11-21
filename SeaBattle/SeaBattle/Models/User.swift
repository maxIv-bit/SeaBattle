//
//  User.swift
//  SeaBattle
//
//  Created by Maks on 21.11.2020.
//

import Foundation
import Firebase

struct User {
  
  let uid: String
  let email: String
  
  init(authData: Firebase.User) {
    uid = authData.uid
    email = authData.email ?? ""
  }
  
  init(uid: String, email: String) {
    self.uid = uid
    self.email = email
  }
}
