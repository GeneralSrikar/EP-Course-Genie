import SwiftUI
import _AVKit_SwiftUI
import WebKit

// WebView for displaying web content
struct WebView: View {
    let urlString: String
    
    var body: some View {
        if let url = URL(string: urlString) {
            WebViewWrapper(request: URLRequest(url: url))
        } else {
            Text("Invalid URL")
        }
    }
}

// Wrapper for WKWebView
struct WebViewWrapper: UIViewRepresentable {
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

struct YoutubeView: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        guard let lin = URL(string: self.urlString) else {
            return WKWebView()
        }
        let request = URLRequest(url: lin)
        let webView = WKWebView()
        webView.load(request)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<YoutubeView>) {}
}

// Side Menu Content
struct SideMenu: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 50) {
            Divider()
            
            Button(action: {}) {
                Text("Courses")
                    .foregroundColor(.red)
                    .buttonStyle(RedButtonStyle())
            }
            
            Button(action: {}) {
                Text("Course Selection")
                    .foregroundColor(.red)
                    .buttonStyle(RedButtonStyle())
            }
            
            Button(action: {}) {
                Text("Capstone Pathways")
                    .foregroundColor(.red)
                    .buttonStyle(RedButtonStyle())
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .offset(x: isShowing ? 0 : -200)
        .animation(.easeInOut)
        .zIndex(1)
    }
}

// Your SwiftUI view for Capstone pathways
struct CapstoneView: View {
    let videoURL = "https://www.youtube.com/T-QkH6KN5KA"
    @State private var showMenu = false
    var email: String
    @State private var navigateToCourses = false
    @State private var navigateToHome = false
    let path = Bundle.main.path(forResource: "Info", ofType: "mp4")
    // let url = URL(string: "https://www.youtube.com/watch?v=T-QkH6KN5KA")
    // let url = URL(fileURLWithPath: path ?? "Not Found")
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    VStack {
                        VideoPlayer(player: AVPlayer(url: URL(fileURLWithPath: path ?? "Not Found")))
                            .cornerRadius(20)
                            .frame(width: 370)
                            .frame(height: 250)
                    }
                    if !showMenu {
                        VStack(spacing: 20) {
                            NavigationLink(destination: BusinessAndManagementView()) {
                                Text("Business & Management")
                            }
                            .buttonStyle(RedButtonStyle())
                            .foregroundColor(.black)
                            
                            NavigationLink(destination: HumanAndPublicServicesView()) {
                                Text("Human & Public Services")
                            }
                            .buttonStyle(RedButtonStyle())
                            .foregroundColor(.black)
                            
                            NavigationLink(destination: NaturalAndAppliedSciencesView()) {
                                Text("Natural & Applied Sciences")
                            }
                            .buttonStyle(RedButtonStyle())
                            .foregroundColor(.black)
                            
                            NavigationLink(destination: EngineeringPathwayView()) {
                                Text("Engineering, Technology, & Manufacturing")
                            }
                            .buttonStyle(RedButtonStyle())
                            .foregroundColor(.black)
                            
                            NavigationLink(destination: CommunicationAndArtsView()) {
                                Text("Communication & Arts")
                            }
                            .buttonStyle(RedButtonStyle())
                            .foregroundColor(.black)
                        }
                        .padding(.bottom)
                    }
                    Spacer()
                }
                .blur(radius: showMenu ? 20 : 0)
                .offset(x: showMenu ? 200 : 0)
                
                if showMenu {
                    SideMenu(isShowing: $showMenu)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.5))
                        .onTapGesture {
                            withAnimation {
                                showMenu.toggle()
                            }
                        }
                }
            }
            .navigationTitle(showMenu ? "" : "Capstone Pathways")
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        NavigationLink(destination: ProfileView(email: email).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "person.fill")
                        }
                        Spacer()
                        NavigationLink(destination: CourseSelectionView(email: email).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "book.circle")
                                .resizable()
                                .frame(width: 32, height: 32)
                        }
                        Spacer()
                        NavigationLink(destination: MyCourses(email: email).navigationBarBackButtonHidden(true)) {
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width: 24, height: 32)
                        }
                        Spacer()
                        Button(action: Home) {
                            Image(systemName: "graduationcap")
                            NavigationLink(destination: CapstoneView(email: email).navigationBarBackButtonHidden(true)) {
                                EmptyView()
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    func Home() {
        navigateToHome = true
    }
    
    func Courses() {
        navigateToCourses = true // Activate the CoursesView
    }
}

// Custom Button Style
struct RedButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(8)
            .padding(.horizontal)
            .font(.headline)
    }
}

// Business & Management View
struct BusinessAndManagementView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Entrepreneurship")
                    .font(.title)
                    .bold()
                Text("Prerequisites: Marketing Strategies and Business Innovations")
                
                Text("Integrated Marketing & Analytics")
                    .font(.title)
                    .bold()
                Text("Prerequisites: Marketing strategies & Digital & Social Media Marketing")
                
                Text("Supporting Courses (Take 8 credits to complete this pathway)")
                    .font(.title2)
                    .bold()
                Text("Accounting, Spreadsheets and Databases, AP Microeconomics, AP Macroeconomics, Business Innovations, Business Introduction, Digital and Social Media Marketing, Personal Finance, AP Psychology, Business Law & Ethics etc.")
                
                Text("Why you should take this capstone")
                    .font(.title2)
                    .bold()
                Text("Are you interested in starting or joining a business? This capstone has courses such as entrepreneurship and Integrated marketing and analytics which can get the necessary information and experience needed to be in the business world.")
            }
            .padding()
        }
        .navigationTitle("Business & Management")
    }
}

// Human & Public Services View
struct HumanAndPublicServicesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Civics in Action")
                    .font(.title)
                    .bold()
                Text("Prerequisites: Completion of two social studies courses")
                
                Text("Supporting Courses:")
                    .font(.title2)
                    .bold()
                Text("AP Human Geography, AP US History, AP Comparative Politics, AP World History, AP Microeconomics, AP Macroeconomics, AP Psychology, Science of Happiness, Level 4 World Language Course, Bilingual Communications, World Religions etc.")
                
                Text("Why you should take this capstone")
                    .font(.title2)
                    .bold()
                Text("Are you ready to help the community? This capstone can help you understand and learn more about your community and the world through courses such as Civics in Action, AP Comparative Politics, AP Microeconomics etc.")
            }
            .padding()
        }
        .navigationTitle("Human & Public Services")
    }
}

// Natural & Applied Sciences View
struct NaturalAndAppliedSciencesView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Science Research and Design")
                    .font(.title)
                    .bold()
                Text("Prerequisites: None")
                
                Text("Supporting Courses (Take 8 credits to complete the pathway)")
                    .font(.title2)
                    .bold()
                Text("Honors Earth & Space Science, Honors Biology, AP Biology, Honors Chemistry, AP Chemistry, Honors Physics, AP Physics, AP Environmental Science, Statistics & Data Science or AP Statistics, Spreadsheets & Databases, Computer Science Principles, AP Computer Science Principles, AP Computer Science A: Java, iOS App Development etc.")
                
                Text("Why you should take this capstone")
                    .font(.title2)
                    .bold()
                Text("If you are someone interested in learning and researching about the world and applying your knowledge, then this capstone will be perfect for you. It has many supporting courses such as Honors Biology and AP Chemistry, so if you are interested in these subjects, you should take this capstone.")
            }
            .padding()
        }
        .navigationTitle("Natural & Applied Sciences")
    }
}

// Engineering, Technology, & Manufacturing View
struct EngineeringPathwayView: View {

    var body: some View {

        ScrollView {

            VStack(alignment: .leading, spacing: 20) {

                Text("IOS App Development")

                    .font(.title)

                    .bold()

                Text("Prerequisites: AP Computer Science Principles and AP Java")

                Text("Advanced Woodcrafting")

                    .font(.title)

                    .bold()

                Text("Prerequisites: Woodcrafting")

                Text("Principles of Engineering")

                    .font(.title)

                    .bold()

                Text("Prerequisites: None")

                

                Text("Supporting Courses(Take 8 credits to complete this pathway)")

                    .font(.title2)

                    .bold()

                Text("Intro to Engineering, Interior Design Studio, Cyber Security, Senior Intern Program, Research and Design, Residential Design, Engineering Manufacturing - Metal Work, Engineering Fabrication - Metal Product Designing, Adv Robotics and Automation, Robotics & Automation, Computer Science Principles, AP Computer Science Principles, AP Computer Science A: Java, etc.")
                Text("Why you should take this capstone")
                    .font(.title2)
                    .bold()
                Text("Interested in applying your math and science skills to bring discoveries to life? Taking courses like IOS App Development, Advanced Woodcrafting, Principles of Engineering, etc., can help you take a deep dive into what this capstone is really about.")
            }
            .padding()
        }
        .navigationTitle("Engineering, Technology, & Manufacturing")
    }
}

// Communication & Arts View
struct CommunicationAndArtsView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Journalism: Reporting and Visual Storytelling")
                    .font(.title)
                    .bold()
                Text("Prerequisites: Journalism or Introduction to Journalism")
                
                Text("Advanced Art: Drawing and Painting")
                    .font(.title)
                    .bold()
                Text("Prerequisites: Art")
                
                Text("Advanced Art: 3D Design")
                    .font(.title)
                    .bold()
                Text("Prerequisites: Art")
                
                Text("Film Production: Screenwriting")
                    .font(.title)
                    .bold()
                Text("Prerequisites: Film Production")
                
                Text("Advanced Film Production")
                    .font(.title)
                    .bold()
                Text("Prerequisites: Film Production")
                
                Text("Supporting Courses")
                    .font(.title2)
                    .bold()
                Text("Graphic Design, Digital Art, 2D and 3D Animation, Honors 3D Design, AP Literature, Creative Writing, Art, AP Art, Design Automation (CAD), Business of Art and Communication, Drama and Technical Theatre, AP Psychology, Advanced Photography, Web Development, Video Game Design, Business Law & Ethics etc.")
                
                Text("Why you should take this capstone")
                    .font(.title2)
                    .bold()
                Text("Are you a creative person who loves art and creating? This capstone has many supporting courses in arts, writing and film which can help you find the creative spark that you are looking for. If you are interested in creating something new, this capstone can help you achieve that.")
            }
            .padding()
        }
        .navigationTitle("Communication & Arts")
    }
}


// Preview provider for SwiftUI previews
struct CapstoneView_Previews: PreviewProvider {
    static var previews: some View {
        CapstoneView(email: "Test3@gmail.com")
    }
}
/*
 truct CapstoneView: View {
     let videoURL = "https://www.youtube.com/embed/T-QkH6KN5KA" // Updated URL
     @State private var showMenu = false
     var firstName: String
     var lastName: String
     var email: String
     var password: String
     @State var isLoggedIn: Bool
     @State private var navigateToCourses = false
     @State private var navigateToHome = false
     
     var body: some View {
         NavigationView {
             ZStack {
                 VStack {
                     VStack{
                         YoutubeView(urlString: videoURL) // Replaced VideoPlayer with YoutubeView
                             .scaledToFit()
                     }
                     if !showMenu {
                         VStack(spacing: 20) {
                             // NavigationLinks...
                         }
                         .padding(.bottom)
                     }
                     Spacer()
                 }
                 .blur(radius: showMenu ? 20 : 0)
                 .offset(x: showMenu ? 200 : 0)
                 
                 if showMenu {
                     SideMenu(isShowing: $showMenu)
                         .frame(maxWidth: .infinity, maxHeight: .infinity)
                         .background(Color.black.opacity(0.5))
                         .onTapGesture {
                             withAnimation {
                                 showMenu.toggle()
                             }
                         }
                 }
             }
             .navigationTitle(showMenu ? "" : "Capstone Pathways")
             .toolbar {
                 ToolbarItem(placement: .bottomBar) {
                     HStack {
                         Spacer()
                         NavigationLink(destination: ProfileView(firstName: "abc", lastName: "", email: "", password: "", isLoggedIn: true)) {
                             Image(systemName: "person.fill")
                         }
                         Spacer()
                         NavigationLink(destination: CoursesView(firstName: "", lastName: "", email: "", password: "", isLoggedIn: true))
                         {
                             Image(systemName: "book.circle")
                                 .resizable()
                                 .frame(width: 32, height: 32)
                         }
                         Spacer()
                         NavigationLink(destination: CourseSelectionView(firstName: "", lastName: "", email: "", password: "", isLoggedIn: true, isCoursesViewActive: true, isProfileViewActive: true))
                         {
                             Image(systemName: "square.and.pencil")
                                 .resizable()
                                 .frame(width:24,height:32)
                         }
                         Spacer()
                         Button(action: Home) {
                             Image(systemName: "graduationcap")
                             NavigationLink(destination: CapstoneView(firstName: "", lastName: "", email: "", password: "", isLoggedIn: true)) {
                                 EmptyView()
                             }
                         }
                         Spacer()
                     }
                 }
             }
         }
     }
     
     func Home() {
        navigateToHome = true
     }
 }
 */
