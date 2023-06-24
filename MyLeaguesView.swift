//
//  MyLeaguesView.swift
//  Brand New
//
//  Created by Yaniv Naggar on 6/22/23.
//
import SwiftUI
import Firebase
import FirebaseFirestore

struct MyLeaguesView: View {
    @State private var leagues: [String] = []
    
    var body: some View {
        List(leagues, id: \.self) { league in
            NavigationLink(destination: LeagueView(leagueId: league)) {
                Text(league)
            }
        }
        .onAppear(perform: loadLeagues)
        .navigationTitle("My Leagues")
    }
    
    private func loadLeagues() {
        FireBaseBackground.fetchLeagues { result in
            switch result {
            case .success(let leagues):
                self.leagues = leagues
            case .failure(let error):
                print("Error getting leagues: \(error)")
            }
        }
    }
}

struct MyLeaguesView_Previews: PreviewProvider {
    static var previews: some View {
        MyLeaguesView()
    }
}
