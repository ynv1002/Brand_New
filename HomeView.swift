//
//  HomeView.swift
//  Brand New
//
//  Created by Yaniv Naggar on 6/22/23.
//

import SwiftUI

struct HomeView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            CreateLeagueView()
                .tabItem {
                    Label("Create", systemImage: "plus.circle.fill")
                }
                .tag(0)

            JoinView()
                .tabItem {
                    Label("Join", systemImage: "person.badge.plus")
                }
                .tag(1)

            MyLeaguesView()
                .tabItem {
                    Label("View", systemImage: "eye.fill")
                }
                .tag(2)
        }
        .navigationTitle("Home")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Image(systemName: "person.circle")
            }
        }
    }
}




struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
