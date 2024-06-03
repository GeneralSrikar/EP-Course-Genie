import SwiftUI
import FirebaseAuth

struct ForgotPasswordView: View {
    @State private var email = ""
    @State private var showAlert = false
    @State private var errString = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            HStack { // Wrap "Forgot Password?" in HStack for left alignment
                Button(action: {
                    forgotPassword()
                }) {
                    Text("Forgot Password?")
                        .foregroundColor(.red)
                        .fontWeight(.bold)
                }
                .padding(.leading) // Add padding to align with password field
                Spacer() // Add Spacer to push button to the left
            }
            
            Button(action: {
                forgotPassword()
            }) {
                Text("Reset Password")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Reset"), message: Text(errString), dismissButton: .default(Text("OK")))
        }
        .padding()
    }
    
    func forgotPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
                showAlert = true
                errString = error.localizedDescription
            } else {
                print("Password reset email sent successfully!")
                showAlert = true
                errString = "Password reset email sent successfully!"
            }
        }
    }
}

struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
