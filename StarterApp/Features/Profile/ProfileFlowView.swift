import SwiftUI

struct ProfileFlowView: View {
    @EnvironmentObject private var session: SessionViewModel
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 16) {
                Text("This is profile screen")
                
                Button("Logout"){
                    session.signOut()
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}
