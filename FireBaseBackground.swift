//
//  FireBaseBackground.swift
//  Brand New
//
//  Created by Yaniv Naggar on 6/23/23.
//
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct FireBaseBackground {
    
    struct Team {
        var QB: Player?
        var RB1: Player?
        var RB2: Player?
        var WR1: Player?
        var WR2: Player?
        var TE: Player?
        var FLX: Player?
        var DEF: Player?
        var K: Player?
        var Bench: [Player?] = Array(repeating: nil, count: 7)
    }
    
    static func login(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

    static func signUp(email: String, password: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
            } else {
                storeUserData(email: email, userID: authResult?.user.uid ?? "") { result in
                    switch result {
                    case .success(_):
                        completion(.success(true))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private static func storeUserData(email: String, userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        let userData: [String: Any] = ["email": email, "leagues": [] as [String]]

        usersCollection.document(userID).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

    static func createLeague(leagueName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        let newLeagueRef = db.collection("leagues").document()
        let leagueData = ["name": leagueName]

        newLeagueRef.setData(leagueData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(newLeagueRef.documentID))
            }
        }
    }

    static func joinLeague(leagueId: String, userID: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userID)

        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().flatMap(String.init(describing:)) ?? "nil"
                print("Document data: \(dataDescription)")
                let leagues = document.get("leagues") as? [String] ?? []
                if leagues.contains(leagueId) {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User already joined this league"])))
                } else {
                    userRef.updateData(["leagues": FieldValue.arrayUnion([leagueId])]) { error in
                        if let error = error {
                            completion(.failure(error))
                        } else {
                            completion(.success(true))
                        }
                    }
                }
            } else {
                print("Document does not exist")
            }
        }
    }

    static func createTeam(leagueId: String, userID: String, team: Team, completion: @escaping (Result<Bool, Error>) -> Void) {
        let db = Firestore.firestore()

        let newTeamRef = db.collection("leagues").document(leagueId).collection("teams").document(userID)

        newTeamRef.getDocument { (document, error) in
            if let document = document, document.exists {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User already has a team in this league"])))
            } else {
                let teamData = teamToDict(team: team)

                newTeamRef.setData(teamData) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(true))
                    }
                }
            }
        }
    }
    
    private static func teamToDict(team: Team) -> [String: Any] {
        var teamData: [String: Any] = [:]
        teamData["QB"] = team.QB
        teamData["RB1"] = team.RB1
        teamData["RB2"] = team.RB2
        teamData["WR1"] = team.WR1
        teamData["WR2"] = team.WR2
        teamData["TE"] = team.TE
        teamData["FLX"] = team.FLX
        teamData["DEF"] = team.DEF
        teamData["K"] = team.K
        teamData["Bench"] = team.Bench

        return teamData
    }
    
    static func checkLeagueExists(leagueName: String, completion: @escaping (Result<String, Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("leagues").whereField("name", isEqualTo: leagueName).getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                if let document = querySnapshot?.documents.first {
                    completion(.success(document.documentID))
                } else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No league found with this name"])))
                }
            }
        }
    }
    static func fetchLeagues(completion: @escaping (Result<[String], Error>) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("leagues").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(.failure(error))
            } else {
                let leagues = querySnapshot?.documents.compactMap { $0["name"] as? String } ?? []
                completion(.success(leagues))
            }
        }
    }
    // Links the created league to the user in Firestore.
    static func linkLeagueToUser(userId: String, leagueId: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        let db = Firestore.firestore()

        db.collection("users").document(userId).updateData([
            "leagues": FieldValue.arrayUnion([leagueId])
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(true))
            }
        }
    }

}

