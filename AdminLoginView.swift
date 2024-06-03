//
//  AdminLoginView.swift
//  EPHS Course Genie
//
//  Created by 64014111 on 4/8/24.
//

import SwiftUI
import Firebase
import FirebaseAuth
struct AdminLoginView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var admincode = ""
    @State private var navigateToProfile = false
    @State private var navigateToHome = false
    @State private var passkey = ""
    @State private var isAuthenticated = false
    @State private var navigateToAdminProfileView = false
    
    var body: some View {
        NavigationView{
            VStack {
                Text("Admin Login")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding()
                    .fontWeight(.bold)
                
                TextField("First Name", text: $firstName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Last Name", text: $lastName)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                TextField("Admin Code", text: $admincode)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    if admincode == "A" {
                        navigateToAdminProfileView = true
                    }
                }) {
                    Text("Login")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding()
                .padding()
                
                NavigationLink(destination: CourseSelectionView1(email: "").navigationBarBackButtonHidden(true), isActive: $navigateToAdminProfileView) {
                    EmptyView()
                }
                .hidden()
                
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    Text("Not An Admin?")
                        .foregroundColor(.red)
                }
                .padding()
                .padding()
            }
            .padding()
        }
    }
}
struct AdminLoginView_Previews: PreviewProvider {
    static var previews: some View {
        AdminLoginView()
    }
}
