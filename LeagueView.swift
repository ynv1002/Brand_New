//
//  LeagueView.swift
//  Brand New
//
//  Created by Yaniv Naggar on 6/22/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct LeagueView: View {
    let leagueId: String
    @State private var teams: [String] = []

    var body: some View {
        VStack {
            Text("Teams in the League")
                .font(.title)

            List(teams, id: \.self) { team in
                Text(team)
            }
        }
        .onAppear(perform: loadTeams)
    }
    
    private func loadTeams() {
        Firestore.firestore().collection("leagues").document(leagueId).collection("teams").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting teams: \(error)")
            } else {
                self.teams = querySnapshot?.documents.compactMap { $0["name"] as? String } ?? []
            }
        }
    }
}

struct LeagueView_Previews: PreviewProvider {
    static var previews: some View {
        LeagueView(leagueId: "Sample League ID")
    }
}
