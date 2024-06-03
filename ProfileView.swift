import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

struct ProfileView: View {
    var db = Firestore.firestore()
    @State private var email: String
    
    // Use UserDefaults to store profile name
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    
    init(email: String) {
        self._email = State(initialValue: email)
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer() // Shift things up
                
                ProfileHeaderView(firstName: $firstName, lastName: $lastName, email: email)
                    .padding()
                
                Spacer()
                
                VStack {
                    HStack {
                        Text("Change First Name")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    
                    TextField("First Name", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    HStack {
                        Text("Change Last Name")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    
                    TextField("Last Name", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                .padding()
                .onAppear {
                    loadProfileData()
                }
                Spacer()
                
                Button(action: {
                    changeName()
                }) {
                    Text("Save Changes")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .bold()
                }
                .padding()
                
                NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true)) {
                    Text("Logout")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .bold()
                }
                .padding()
            }
            .padding(.top, -20)
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ProfileView(email: email).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "person.fill")
                        }
                        
                        Spacer()
                        NavigationLink(destination: CourseSelectionView(email: email).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "book.fill")
                        }
                        
                        Spacer()
                        Button(action: {}) {
                            NavigationLink(destination: MyCourses(email: email).navigationBarBackButtonHidden(true)) {
                                Image(systemName: "square.and.pencil")
                                    .resizable()
                                    .frame(width:24,height:32)
                            }
                        }
                        
                        Spacer()
                        
                        NavigationLink(destination: CapstoneView(email: email).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "graduationcap")
                        }
                        
                        Spacer()
                    }
                }
            }
        }
    }
    
    func loadProfileData() {
        Task{
            let docRef = db.collection("Users").document(email)
            do{
                let document = try await docRef.getDocument()
                if document.exists {
                    firstName = document.data()?["First Name"] as! String
                    lastName = document.data()?["Last Name"] as! String
                } else {
                    print("Document does not exist")
                }
            }
            catch{
                print("Error getting document: \(error)")
            }
        }
    }
    
    func changeName() {
        let docRef = db.collection("Users").document(email)
        docRef.updateData(["First Name": firstName, "Last Name": lastName]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

struct ProfileHeaderView: View {
    @Binding var firstName: String
    @Binding var lastName: String
    var email: String
    
    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 100, height: 100)
                .foregroundColor(.red)
                .padding()
            
            HStack {
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("\(firstName) \(lastName)")
                        .font(.title)
                        .padding(.bottom, 5)
                    
                    Text(email)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.bottom, 5)
                }
                
                Spacer()
            }
            Spacer()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(email: "Test3@gmail.com")
    }
}
