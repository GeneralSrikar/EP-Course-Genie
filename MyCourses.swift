import SwiftUI
import FirebaseAuth
import Firebase
import FirebaseCore
import FirebaseFirestore

struct MyCourses: View {
    var db = Firestore.firestore()
    var email: String
    @State var courses: [String] = []
    @State var myCourses: [MyCourse] = []
    @State var dataLoaded = false
    @State var totalCredits = 0

    var body: some View {
        NavigationView {
            VStack {
                Text("My Courses")
                    .font(.title)
                    .padding()

                List(myCourses) { course in
                    HStack{
                        VStack(alignment: .leading) {
                            Text(course.name)
                                .font(.headline)
                            Text(course.level)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        VStack{
                            Text(String(course.credits))
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            Text("credits")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
                Text("Total Credits: \(totalCredits) /54")
                    .font(.headline)
                    .foregroundColor(totalCredits > 54 ? .red : .black)
                Spacer()
            }
            .onAppear {
                if !dataLoaded {
                    getCourses()
                }
            }
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
                        NavigationLink(destination: MyCourses(email: email).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "list.bullet.clipboard")
                                .resizable()
                                .frame(width: 24, height: 32)
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

    func getCourses() {
        Task {
            let docRef = db.collection("Users").document(email)
            do {
                let document = try await docRef.getDocument()
                if document.exists {
                    courses = document.data()?["Courses"] as! [String]
                } else {
                    print("Document does not exist")
                }
            } catch {
                print("Error getting document: \(error)")
            }

            for courseId in courses {
                let courseRef = db.collection("Courses").document(courseId)
                do {
                    let document = try await courseRef.getDocument()
                    if document.exists {
                        myCourses.append(MyCourse(id: document.data()?["id"] as! String,
                                                  name: document.data()?["Name"] as! String,
                                                  level: document.data()?["Level"] as! String,
                                                  grade: document.data()?["Grades"] as! [String],
                                                  subject: document.data()?["Subject"] as! String,
                                                  credits: document.data()?["Credits"] as! Int,
                                                  prerequisites: document.data()?["Prereq"] as! [String])
                                         )
                        totalCredits += document.data()?["Credits"] as! Int
                    } else {
                        print("Document does not exist")
                    }
                } catch {
                    print("Error getting document: \(error)")
                }
            }
            dataLoaded = true
        }
    }
}

struct MyCourses_Previews: PreviewProvider {
    static var previews: some View {
        MyCourses(email: "Test3@gmail.com")
    }
}
