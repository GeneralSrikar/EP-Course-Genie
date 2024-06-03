import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

struct Unit1: Identifiable {
    let id = UUID()
    var title: String
    var link: String
    var description: String
}

struct AddUnitView: View {
    var email: String
    var courseId : String
    var db = Firestore.firestore()
    @State private var units: [Unit1] = Array(repeating: Unit1(title: "", link: "", description: ""), count: 3)
    @State private var navigateBack = false

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                ScrollView {
                    ForEach(units.indices, id: \.self) { index in
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Unit \(index + 1)")
                                .font(.headline)

                            TextField("Unit Title", text: $units[index].title)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("Link", text: $units[index].link)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            TextField("Description", text: $units[index].description)
                                .textFieldStyle(RoundedBorderTextFieldStyle())

                            Divider()
                        }
                        .padding(.horizontal)
                    }
                }
                Button(action: addUnits) {
                    Text("+")
                        .font(.title)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .bold()
                }
                .padding(.bottom, 20)
                
                Button(action: saveUnits) {
                    Text("Save Units")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                        .bold()
                }
                .padding(.bottom, 20)
                
                NavigationLink(destination: CourseSelectionView1(email: email).navigationBarBackButtonHidden(true), isActive: $navigateBack) {
                    EmptyView()
                }
            }
            .navigationTitle("Course Details")
        }
    }
    func addUnits(){
        print("here")
        units.append(Unit1(title: "", link: "", description: ""))
        print(units)
    }
    func saveUnits() {
        let coursesRef = db.collection("CourseDetail")
        for unit in units{
            let id = UUID().description
            print(id)
            coursesRef.document(id).setData([
                "Course Id": courseId,
                "Title": unit.title,
                "Link": unit.link,
                "Description": unit.description
            ]) { error in
                if let error = error {
                    print("Error adding units: \(error)")
                }
            }
        }
        navigateBack.toggle()
    }
}

// Assuming Course, CourseRow, ProfileView, CourseSelectionView, and CapstoneView are also defined

#Preview {
    AddUnitView(email: "", courseId: "test")
}
