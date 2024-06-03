import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore
// Define a data model for form answers
struct FormAnswers {
    var grade: String
    var subject: String
    var level: String
    // Add properties for other form fields
}

struct MyCourse: Identifiable {
    var id: String
    var name: String
    var level: String
    var grade: [String]
    var subject: String
    var credits: Int
    var prerequisites: [String]
}

struct MyCoursesView: View {
    var courses: [MyCourse]
    var email: String
    var body: some View {
        NavigationView{
            VStack {
                Text("My Courses")
                    .font(.title)
                    .padding()

                List(courses) { course in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(course.name)
                                .font(.headline)
                        }
                        .padding()
                        VStack{
                            Text(String(course.credits))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }
        }
    }
}

struct CourseSelectionView: View {
    @StateObject var viewModel = CourseSelectionViewModel()
    @State private var showSavedMessage = false // State variable to control the visibility of the saved message
    var email: String
    @State var getCourses: [MyCourse] = []
    @State var myCourses: [String] = []
    @State var courseName = "test"
    @State var coursePre: [String] = []
    @State var error = ""
    @State var showAlert = false
    @State var prereqs: [String] = []
    var db = Firestore.firestore()
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NavigationLink(destination: CourseDetailsView(email: email).navigationBarBackButtonHidden(true)) {
                    Text("Course Details")
                }
                .padding()
                // My Courses button at the top left corner
                let _ = userCourses()
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
                            viewModel.showCourses(myCourses: myCourses)
                            print(myCourses)
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
                HStack{
                    Text("Course List")
                        .font(.title)
                        .padding()
                    Text("Credits    ")
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                List(viewModel.getSelectedCourses()) { course in
                    VStack(alignment: .leading) {
                        HStack(){
                            Button(action: {
                                courseName = course.name.substring(from:course.name.index(course.name.startIndex, offsetBy: 2))
                                coursePre = course.prerequisites
                                addDel()}) {
                                    Text(course.name)
                                    .font(.headline)
                                }
                            .buttonStyle(.plain)
                            Text(String(course.credits))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(error), dismissButton: .default(Text("OK")))
                }
                Spacer()
                // Save Courses button
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

                // Saved message
                
            }
            .navigationBarHidden(true)
        }
    }
    func userCourses(){
        Task{
            let docRef = db.collection("Users").document(email)
            do {
              let document = try await docRef.getDocument()
              if document.exists {
                  myCourses = document.data()?["Courses"] as! [String]
              } else {
                print("Document does not exist")
              }
            } catch {
              print("Error getting document: \(error)")
            }
        }
    }
    func addDel(){
        print(myCourses)
        if(myCourses.contains(courseName)){
            var problem:[String] = []
            print(courseName)
            for course in myCourses {
                Task {
                    let docRef = db.collection("Courses").document(course)
                    do {
                        let document = try await docRef.getDocument()
                        if document.exists {
                            prereqs = document.data()?["Prereq"] as! [String]
                            print(prereqs)
                            if prereqs.contains(courseName){
                                problem.append(course)
                                error = problem.joined(separator: ",") + " in your course list has this course as Prerequisite."
                                showAlert = true
                            }
                        } else {
                            print("Document does not exist")
                        }
                    } catch {
                        print("Error getting document: \(error)")
                    }
                }
            }
            print(problem)
            if problem == [] {
                myCourses.remove(at: myCourses.firstIndex(of: courseName)!)
            }
            else{
                error = "Prerequisites : " + problem.joined(separator: ",") + " - Courses in your course list has this course as Prerequisite."
                showAlert.toggle()
            }
        }else {
            var missing:[String] = []
            for nam in coursePre {
                if myCourses.contains(nam){
                    
                }
                else{
                    missing.append(nam)
                }
            }
            if missing == [] {
                myCourses.append(courseName)
            }
            else{
                error = "Prerequisites : " + missing.joined(separator: ",") + " - missing from your course list."
                showAlert.toggle()
            }
        }
        Task{
            let docRef = db.collection("Users").document(email)
            docRef.updateData(["Courses": myCourses]){ (error) in
                if error == nil {
                    print("updated")
                }else{
                    print("not updated")
                }
            }
        }
        viewModel.showCourses(myCourses: myCourses)
    }
}

// Define a ViewModel to manage form data
class CourseSelectionViewModel: ObservableObject {
    @Published var formAnswers: FormAnswers
    @Published var selectedCourses: [MyCourse] = []
    @State var cId = ""
    @State var cName = ""
    @State var cLevel = ""
    @State var cGrade:[String] = []
    @State var cSubject = ""
    @State var cCredits = 0
    @Published var myCourses:[String] = []
    var db = Firestore.firestore()
    init() {
        // Load form answers when ViewModel is initialized
        // For demonstration, let's initialize with default values
        self.formAnswers = FormAnswers(grade: "Grade 9", subject: "Maths", level: "Regular")
    }

    // Function to save form answers and update selectedCourses
    func showCourses(myCourses: [String]){
        selectedCourses = []
        print("Form answers saved:")
        print("Grade: \(formAnswers.grade)")
        print("Subject: \(formAnswers.subject)")
        print("Level: \(formAnswers.level)")
        Task{
            //let coursesRef = db.collection("Courses")
            do {
              let querySnapshot = try await db.collection("Courses")
                    .whereField("Level", isEqualTo: formAnswers.level)
                    .whereField("Subject", isEqualTo: formAnswers.subject)
                    .whereField("Grades", arrayContains: formAnswers.grade)
                .getDocuments()
                for document in querySnapshot.documents {
                    if myCourses.contains(document.data()["Name"] as! String) {
                      selectedCourses.append(contentsOf: [
                        MyCourse(id: document.data()["id"] as! String,
                                 name: "- " + (document.data()["Name"] as! String),
                                 level: document.data()["Level"] as! String,
                                 grade: document.data()["Grades"] as! [String],
                                 subject: document.data()["Subject"] as! String,
                                 credits: document.data()["Credits"] as! Int,
                                 prerequisites: document.data()["Prereq"] as! [String]
                                )
                      ])
                  }
                  else {
                      selectedCourses.append(contentsOf: [
                        MyCourse(id: document.data()["id"] as! String,
                                 name: "+ " + (document.data()["Name"] as! String),
                                 level: document.data()["Level"] as! String,
                                 grade: document.data()["Grades"] as! [String],
                                 subject: document.data()["Subject"] as! String,
                                 credits: document.data()["Credits"] as! Int,
                                 prerequisites: document.data()["Prereq"] as! [String]
                                )
                      ])
                  }
              }
            } catch {
              print("Error getting documents: \(error)")
            }
        }
    }
    func showCourses() {
        selectedCourses = []
        print("Form answers saved:")
        print("Grade: \(formAnswers.grade)")
        print("Subject: \(formAnswers.subject)")
        print("Level: \(formAnswers.level)")
        Task{
            //let coursesRef = db.collection("Courses")
            do {
              let querySnapshot = try await db.collection("Courses")
                    .whereField("Level", isEqualTo: formAnswers.level)
                    .whereField("Subject", isEqualTo: formAnswers.subject)
                    .whereField("Grades", arrayContains: formAnswers.grade)
                .getDocuments()
              for document in querySnapshot.documents {
                  selectedCourses.append(contentsOf: [
                    MyCourse(id: document.data()["id"] as! String,
                             name: document.data()["Name"] as! String,
                             level: document.data()["Level"] as! String,
                             grade: document.data()["Grades"] as! [String],
                             subject: document.data()["Subject"] as! String,
                             credits: document.data()["Credits"] as! Int,
                             prerequisites: document.data()["Prereq"] as! [String]
                            )
                  ])
              }
            } catch {
              print("Error getting documents: \(error)")
            }

        }
    }

    // Function to get selected courses
    func getSelectedCourses() -> [MyCourse] {
        return selectedCourses
    }
}

// OtherScreenView definition
struct OtherScreenView: View {
    @EnvironmentObject var viewModel: CourseSelectionViewModel
    
    var body: some View {
        // Display form answers or perform other actions
        Text("Grade: \(viewModel.formAnswers.grade)")
        Text("Subject: \(viewModel.formAnswers.subject)")
        Text("Level: \(viewModel.formAnswers.level)")
    }
}

struct CourseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CourseSelectionView(email: "Test3@gmail.com")
    }
}
