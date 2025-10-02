import SwiftUI


struct LoginView: View {
    @EnvironmentObject private var session: SessionViewModel
    @StateObject private var vm = LoginViewModel() //живет столько же сколько этот view
    
    private enum Field { case username, password }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        Form{
            Section("Данные для входа"){
                TextField("Username", text: $vm.username)
                    .textContentType(.username)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focusedField, equals: .username)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .password
                    }
                SecureField("Password", text: $vm.password)
                    .textContentType(.password)
                    .focused($focusedField, equals: .password)
                    .submitLabel(.go)
                    .onSubmit {Task { await attemptLogin() } }
                    
            }
            
            if let err = vm.error{
                Section{
                    Text(err)
                        .foregroundStyle(.red)
                        .font(.callout)
                }
            }
            
            Section{
                Button{
                    Task {await attemptLogin() }
                }label: {
                    if vm.isLoading{
                        ProgressView()
                    }else{
                        Text("Login")
                    }
                }
                .disabled(!vm.isValid || vm.isLoading)
            }
        }
        .onAppear{ focusedField = .username}
    }

    private func attemptLogin() async {
        let ok = await vm.login()
        if ok{
            session.signIn()
        }
    }
}
