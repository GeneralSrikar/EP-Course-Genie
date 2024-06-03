import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore
struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                WelcomeView()
                
                Spacer()
                
                SignUpView()
                
                Spacer()
                
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    Text("Already have an account? Log in")
                        .foregroundColor(.red)
                }
                .padding()
                .navigationBarBackButtonHidden(true)
            }
            .navigationBarHidden(true)
        }
    }
}
struct WelcomeView: View {
    var body: some View {
        VStack {
            Image("Eagle")
                .resizable()
                .frame(width: 300)
            Text("Welcome to EPHS Course Genie!")
                .foregroundColor(.red)
                .font(.title)
                .padding()
        }
    }
}
struct SignUpView: View {
    var db = Firestore.firestore()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var navigateToHome = false
    @State private var incorrectPassword = false
    @State private var showAlert = false
    @State private var error_text = ""
    @State private var firstNames = [String]()
    @State private var emails = [String]()
    @State private var lastNames = [String]()
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Last Name", text: $lastName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: signUp) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
                    .padding(.horizontal, 20)
                    .bold()
            }
            .padding()
            
            // Display error message if password is incorrect
            if incorrectPassword {
                Text("Incorrect password. Please try again.")
                    .foregroundColor(.red)
                    .padding()
            }
            
            NavigationLink(destination: ProfileView(email: email).navigationBarBackButtonHidden(true), isActive: $navigateToHome) {
                EmptyView()
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(error_text), dismissButton: .default(Text("OK")))
            }
        }
        .padding()
    }
    func signUp() {
        if(firstName.count < 1){
            error_text = "First Name cannot be less than 2 letters"
            showAlert.toggle()
        }
        else{
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    print(error.localizedDescription)
                    showAlert.toggle()
                    error_text = error.localizedDescription
                } else {
                    // User successfully signed up, now navigate to home
                    login()
                }
            }
        }
    }
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
                let usersRef = db.collection("Users")
                usersRef.document(email).setData([
                    "First Name":firstName,
                    "Last Name":lastName,
                    "Courses":[]
                ])
                navigateToHome.toggle()
            }
        }
    }
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
