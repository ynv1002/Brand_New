

/*
Users (collection)
    userId (document)
        email
        UserLeagues (sub-collection)
            userLeagueId (document)
                leagueId (reference to Leagues)
                teamId (reference to Teams)
Leagues (collection)
    leagueId (document)
        leagueName
        creatorId (reference to Users)
Teams (collection)
    teamId (document)
        teamName
        leagueId (reference to Leagues)
        ownerId (reference to Users)
        Players (sub-collection)
            playerId (document)
                playerName
                position
                rankin
 */
//






//  Brand_NewApp.swift
//  Brand New
//
//  Created by Yaniv Naggar on 6/22/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import Firebase
import FirebaseFirestore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct YourApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        ContentView()
      }
    }
  }
}
