import SwiftUI

struct ContentView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showHomeView = false

    var body: some View {
        if showHomeView {
            HomeView()
        } else {
            main
        }
    }

    var main: some View {
        NavigationStack {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .padding()

                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8.0)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8.0)

                Button(action: {
                    FireBaseBackground.login(email: email, password: password) { result in
                        switch result {
                        case .success(let success):
                            print("Login success: \(success)")
                            self.showHomeView = true
                        case .failure(let error):
                            print("Login error: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8.0)
                }
                .padding(.top)

                Button(action: {
                    FireBaseBackground.signUp(email: email, password: password) { result in
                        switch result {
                        case .success(let success):
                            print("Sign up success: \(success)")
                            self.showHomeView = true
                        case .failure(let error):
                            print("Sign up error: \(error.localizedDescription)")
                        }
                    }
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8.0)
                }
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
