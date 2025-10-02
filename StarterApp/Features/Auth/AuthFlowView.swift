import SwiftUI

struct AuthFlowView: View {
    var body: some View {
        NavigationStack{
            LoginView()
                .navigationTitle("Login")
        }
    }
}
