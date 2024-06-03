import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

struct DetailView: View {
    var email: String
    var courseId: String
    var courseName: String
    var db = Firestore.firestore()
    @State var units: [Unit1] = []
    @State private var navigateBack = false
    @State var dataLoaded = false
    @State var prereqs: [String] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                NavigationLink(destination: CourseDetailsView(email: email).navigationBarBackButtonHidden(true)) {
                    Text("< Back")
                        .foregroundColor(.blue)
                        .padding()
                }
                Text("Course Details")
                    .foregroundColor(.red)
                    .font(.title)
                    .padding(.horizontal, 80)
                VStack(alignment: .leading, spacing: 8) {
                    Text("    Prerequisites")
                        .font(.headline)
                    Text("    "+prereqs.joined(separator: ","))
                }
                ScrollView {
                    
                    ForEach(units.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Unit \(index + 1)")
                                .font(.headline)
                            
                            TextField("Unit Title", text: $units[index].title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(true)
                            
                            TextField("Link", text: $units[index].link)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .disabled(true)
                            
                            // Use a ForEach loop for descriptions
                            
                            TextField("Description", text: $units[index].description)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .disabled(true)
                            
                            Divider()
                        }
                        .padding(.horizontal)
                    }
                }
                .onAppear{
                    self.getUnits()
                }
                NavigationLink(destination: CourseDetailsView(email: email).navigationBarBackButtonHidden(true), isActive: $navigateBack) {
                    EmptyView()
                }
            }
            /*.onAppear {
             if !dataLoaded {
             getUnits()
             }
             }*/
        }
    }
    func getUnits() {
        Task{
            do {
                let querySnapshot = try await db.collection("CourseDetail")
                    .whereField("Course Id", isEqualTo: courseId)
                    .getDocuments()
                for document in querySnapshot.documents {
                    units.append(contentsOf: [
                        Unit1(title: document.data()["Title"] as! String,
                              link: document.data()["Link"] as! String,
                              description: document.data()["Description"] as! String
                             )
                    ])
                }
            } catch {
                print("Error getting documents: \(error)")
            }
            let docRef = db.collection("Courses").document(courseName)
            do {
                let document = try await docRef.getDocument()
                if document.exists {
                    prereqs = document.data()?["Prereq"] as! [String]
                    print(prereqs)
                } else {
                    print("Document does not exist")
                }
            } catch {
                print("Error getting document: \(error)")
            }
        }
    }
}


// Assuming Course, CourseRow, ProfileView, CourseSelectionView, and CapstoneView are also defined

#Preview {
    DetailView(email: "Test3@gmail.com", courseId: "36C48D95-E0EA-4784-9A67-AC02F78292AC", courseName: "Math 10")
}
