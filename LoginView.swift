import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore
struct LoginView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToProfile = false
    @State private var showAlert = false
    @State private var navigateToForgotPassword = false
    @State private var error_text = ""
    @State private var firstNames = [String]()
    @State private var emails = [String]()
    @State private var lastNames = [String]()
    var db = Firestore.firestore()
    var body: some View {
        NavigationView{
            VStack {
                Image("Eagle")
                    .resizable()
                    .frame(width: 300, height: 180)
                Text("Welcome back Students!")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding()
                Text("Login")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding()
                    .fontWeight(.bold)
                
                TextField("Email", text: $email)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                NavigationLink(destination: ForgotPasswordView(), isActive: $navigateToForgotPassword) {
                    Text("Forgot Password?")
                        .foregroundColor(.red)
                        .padding(.leading)
                        .disableAutocorrection(true)
                    Spacer()
                }
                
                Button(action: {
                    login()
                }) {
                    Text("Log In")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                
                NavigationLink(destination: ProfileView(email: email).navigationBarBackButtonHidden(true),  isActive: $navigateToProfile) {
                    EmptyView()
                }
                .padding()
                
                NavigationLink(destination: AdminLoginView().navigationBarBackButtonHidden(true)) {
                    Text("Admin Log In")
                        .foregroundColor(.blue)
                }
                
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.red)
                }
                .padding()
                .padding()
            }
            .padding()
            // Display error message if password is incorrect
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(error_text), dismissButton: .default(Text("OK")))
            }
        }
    }
    func login(){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print(error._code)
                if(error._code == 17999){
                    error_text = "Email or Password incorrect. Please try again."
                }
                else{
                    error_text = error.localizedDescription
                }
                showAlert.toggle()
            } else {
                Task{
                    let docRef = db.collection("Users").document(email)
                    do {
                        let document = try await docRef.getDocument()
                        if document.exists {
                            firstName = document.data()?["First Name"] as! String
                            lastName = document.data()?["Last Name"] as! String
                            navigateToProfile.toggle()
                        } else {
                            print("Document does not exist")
                        }
                    } catch {
                        print("Error getting document: \(error)")
                    }
                }
            }
        }
    }
    func forgotPassword() {
        navigateToForgotPassword.toggle()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

/*
 func login() {
 Auth.auth().signIn(withEmail: email, password: password) { result, error in
 if let error = error {
 print(error._code)
 if(error._code == 17999){
 error_text = "Email or Password incorrect. Please try again."
 }
 else{
 error_text = error.localizedDescription
 }
 showAlert.toggle()
 } else {
 let userData = UserDefaults.standard
 if let savedFirst = userData.array(forKey: "First Names") as? [String]{
 firstNames = savedFirst
 }
 if let savedLast = userData.array(forKey: "Last Names") as? [String]{
 lastNames = savedLast
 }
 if let savedEmail = userData.array(forKey: "Emails") as? [String]{
 emails = savedEmail
 }
 firstName = firstNames[emails.firstIndex(of: email) ?? 0]
 lastName = lastNames[emails.firstIndex(of: email) ?? 0]
 navigateToProfile.toggle()
 }
 }
 }
 */
