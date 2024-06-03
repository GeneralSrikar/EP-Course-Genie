import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

struct CourseSelectionView1: View {
    var db = Firestore.firestore()
    @StateObject var viewModel = CourseSelectionViewModel()
    @State private var showSavedMessage = false // State variable to control the visibility of the saved message
    var email: String
    @State var getCourses: [MyCourse] = []
    @State var myCourses: [String] = []
    @State var courseName = "test"
    @State var courseId = "test"
    @State var plusMinus = "+"
    @State var navigateAdd = false
    @State var navigateEdit = false
    var screenWidth = UIScreen.main.bounds.size.width
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NavigationLink(destination: ContentView().navigationBarBackButtonHidden(true)) {
                    Text("< Logout")
                        .foregroundColor(.blue)
                        .padding()
                }

                // Form content
                Form {
                    Section() {
                        Picker("Grade", selection: $viewModel.formAnswers.grade) {
                            Text("Grade 9").tag("Grade 9")
                            Text("Grade 10").tag("Grade 10")
                            Text("Grade 11").tag("Grade 11")
                            Text("Grade 12").tag("Grade 12")
                            Text("Flex Grade").tag("Flex Grade")
                        }
                        Picker("Subject", selection: $viewModel.formAnswers.subject) {
                            Text("Maths").tag("Maths")
                            Text("Social Studies").tag("Social Studies")
                            Text("Science").tag("Science")
                            Text("English").tag("English")
                            Text("Business").tag("Business")
                            Text("World Language").tag("World Language")
                            Text("Art").tag("Art")
                            Text("Electives").tag("Electives")
                        }
                        Picker("Level", selection: $viewModel.formAnswers.level) {
                            Text("Regular").tag("Regular")
                            Text("Honors").tag("Honors")
                            Text("AP").tag("AP")
                        }
                        Button(action: {
                            viewModel.showCourses()
                            showSavedMessage = true // Set the state variable to show the saved message
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSavedMessage = false // Hide the message after 2 seconds
                            }
                        }) {
                            Text("Show Courses")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                Text("Course List")
                    .font(.title)
                    .padding()

                List(viewModel.getSelectedCourses()) { course in
                    VStack(alignment: .leading) {
                        Text(course.name)
                            .font(.headline)
                            .padding(.horizontal, 40)
                        HStack(alignment: .center){
                            Button(action: {
                                courseName = course.name
                                courseEdit()
                                viewModel.showCourses()}) {
                                Text("Edit")
                                        .foregroundColor(.white)
                            }
                            .frame(width: screenWidth/2, height: 20, alignment: .center )
                            .background(Color.blue)
                            .buttonStyle(.plain)
                            Button(action: {
                                courseName = course.name
                                courseId = course.id
                                courseDelete()
                                viewModel.showCourses()}) {
                                Text("Delete")
                                        .foregroundColor(.white)
                            }
                            .frame(width: screenWidth/2, height: 20, alignment: .center )
                            .background(Color.blue)
                            .buttonStyle(.plain)
                        }
                    }
                }
                Spacer()
                // Save Courses button
                

                // Saved message
                Button(action: courseAdd) {
                    Text("Add Course")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(8)
                        .padding(.horizontal, 20)
                }
                NavigationLink(destination: AddCourseView(email: email).navigationBarBackButtonHidden(true), isActive: $navigateAdd) {
                    EmptyView()
                }
                NavigationLink(destination: EditCourseView(email: email, courseName: courseName).navigationBarBackButtonHidden(true), isActive: $navigateEdit) {
                    EmptyView()
                }
            }
            .navigationBarHidden(true)
        }
    }
    func courseEdit(){
        navigateEdit.toggle()
    }
    func courseDelete(){
        db.collection("Courses").document(courseName).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
        Task{
            do {
                let querySnapshot = try await db.collection("CourseDetail")
                    .whereField("Course Id", isEqualTo: courseId)
                    .getDocuments()
                for document in querySnapshot.documents {
                    try await document.reference.delete()
                }
            } catch {
                print("Error getting documents: \(error)")
            }
        }
    }
    func courseAdd()
    {
        navigateAdd.toggle()
    }
}


struct AdminCoursesView_Previews: PreviewProvider {
    static var previews: some View {
        CourseSelectionView1(email: "")
    }
}
