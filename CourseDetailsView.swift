import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore


struct CourseDetailsView: View {
    @StateObject var viewModel = CourseSelectionViewModel()
    @State private var showSavedMessage = false // State variable to control the visibility of the saved message
    var email: String
    @State var getCourses: [MyCourse] = []
    @State var courseId = "test"
    var db = Firestore.firestore()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NavigationLink(destination: CourseSelectionView(email: email).navigationBarBackButtonHidden(true)) {
                    Text("Course Selection")
                }
                .padding()
                // My Courses button at the top left corner
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
                        HStack(){
                            NavigationLink(destination: DetailView(email: email, courseId: course.id, courseName: course.name).navigationBarBackButtonHidden(true)) {
                                Text(course.name)
                            }
                        }
                    }
                }
                Spacer()
                // Saved message
                    .toolbar {
                        ToolbarItem(placement: .bottomBar) {
                            HStack {
                                Spacer()
                                NavigationLink(destination: ProfileView(email: email).navigationBarBackButtonHidden(true)) {
                                    Image(systemName: "person.fill")
                                }
                                
                                Spacer()
                                NavigationLink(destination: CourseDetailsView(email: email).navigationBarBackButtonHidden(true)) {
                                    Image(systemName: "book.fill")
                                }
                                
                                Spacer()
                                Button(action: {}) {
                                    NavigationLink(destination: MyCourses(email: email).navigationBarBackButtonHidden(true)) { // Link to MyCourses page
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
            .navigationBarHidden(true)
        }
    }
}

// Define a ViewModel to manage form data

struct CourseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        CourseDetailsView(email: "Test3@gmail.com")
    }
}
