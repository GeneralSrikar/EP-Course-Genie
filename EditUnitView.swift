import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

struct EditUnitView: View {
    var email: String
    var courseId : String
    var db = Firestore.firestore()
    @State var units: [Unit1]
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
    EditUnitView(email: "Test3@gmail.com", courseId: "3DF48266-B100-4BE7-968A-826AC5786277", units: [])
}
