import SwiftUI

struct RootView: View {
    @StateObject private var session = SessionViewModel() ////живет столько же сколько этот view
    var body: some View {
        Group{
            if session.isAuthorized {
                TabView{
                    MainFlowView()
                        .tabItem {
                            Label("Main", systemImage: "house")
                        }
                    ProfileFlowView()
                        .tabItem {
                            Label("Profile", systemImage: "person.circle")
                        }
                }
            }else{
                AuthFlowView()
            }
        }
        .environmentObject(session) //.environmentObject(session) делает session доступным всем экранам ниже.
    }
}

struct MainFlowView: View {
    var body: some View {
        NavigationStack{
            VStack(spacing: 16) {
                Text("Main content will be here")
                NavigationLink("Open details") {
                    DetailView(title: "Detail screen")
                }
            }
            .navigationTitle("Main")
            .padding()
        }
    }
}


struct DetailView: View {
    let title: String
    
    var body: some View{
        Text(title)
            .font(.title2)
            .padding()
            .navigationTitle("Details")
    }
}

