//
//  JoinView.swift
//  Brand New
//
//  Created by Yaniv Naggar on 6/22/23.
//

import SwiftUI

struct JoinView: View {
    @State private var leagueName: String = ""
    @State private var teamName: String = ""
    @State private var team = FireBaseBackground.Team()
    @State private var leagueId: String?
    @State private var leagueExists: Bool = false

    let positions = ["QB", "RB1", "RB2", "WR1", "WR2", "TE", "FLX", "DEF", "K"]

    var body: some View {
        ScrollView {
            VStack {
                TextField("League Name", text: $leagueName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8.0)
                
                Button(action: {
                    checkLeagueExists()
                }) {
                    Text("Search")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8.0)
                }
                .padding(.top)
                
                if leagueExists {
                    TextField("Team Name", text: $teamName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8.0)
                    
                    Text("Starters")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(positions, id: \.self) { position in
                        playerTextField(position, player: getPlayerBinding(for: position))
                    }
                    
                    Text("Bench Players")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(0..<team.Bench.count, id: \.self) { index in
                        playerTextField("Player \(index + 1)", player: getBenchPlayerBinding(at: index))
                    }
                    
                    Button(action: {
                        createTeam()
                    }) {
                        Text("Join League")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(8.0)
                    }
                    .padding(.top)
                } else if leagueId != nil {
                    Text("No league found with this name.")
                        .foregroundColor(.red)
                        .padding(.top)
                }
            }
        }
        .padding()
        .navigationTitle("Join a League")
    }

    private func playerTextField(_ position: String, player: Binding<Player?>) -> some View {
        HStack {
            Text(position)
                .frame(width: 80, alignment: .leading)
            TextField("Player Name", text: Binding(
                get: { player.wrappedValue?.name ?? "" },
                set: { newName in
                    if var current = player.wrappedValue {
                        current.name = newName
                        player.wrappedValue = current
                    } else if !newName.isEmpty {
                        player.wrappedValue = Player(name: newName, value: 1)
                    }
                }
            ))
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8.0)
            Picker("Value", selection: Binding(
                get: { player.wrappedValue?.value ?? 1 },
                set: { newValue in
                    if var current = player.wrappedValue {
                        current.value = newValue
                        player.wrappedValue = current
                    } else {
                        player.wrappedValue = Player(name: "", value: newValue)
                    }
                }
            )) {
                ForEach(1...10, id: \.self) {
                    Text("\($0)")
                }
            }
            .labelsHidden()
            .pickerStyle(MenuPickerStyle())
        }
        .padding(.vertical, 4)
    }
    
    private func getPlayerBinding(for position: String) -> Binding<Player?> {
        switch position {
        case "QB":
            return $team.QB
        case "RB1":
            return $team.RB1
        case "RB2":
            return $team.RB2
        case "WR1":
            return $team.WR1
        case "WR2":
            return $team.WR2
        case "TE":
            return $team.TE
        case "FLX":
            return $team.FLX
        case "DEF":
            return $team.DEF
        case "K":
            return $team.K
        default:
            return Binding<Player?>(
                get: { nil },
                set: { _ in }
            )
        }
    }
    
    private func getBenchPlayerBinding(at index: Int) -> Binding<Player?> {
        return Binding<Player?>(
            get: { team.Bench[index] },
            set: { team.Bench[index] = $0 }
        )
    }

    private func checkLeagueExists() {
        FireBaseBackground.checkLeagueExists(leagueName: leagueName) { result in
            switch result {
            case .success(let leagueId):
                print("League exists with ID: \(leagueId)")
                leagueExists = true
                self.leagueId = leagueId
            case .failure(let error):
                print("Error checking league existence: \(error)")
                leagueExists = false
            }
        }
    }

    private func createTeam() {
        guard let leagueId = leagueId else {
            // Handle missing league ID error
            return
        }

        FireBaseBackground.createTeam(leagueId: leagueId, userID: teamName, team: team) { result in
            switch result {
            case .success:
                print("Team created successfully")
                // Handle successful team creation
            case .failure(let error):
                print("Error creating team: \(error)")
                // Handle team creation error
            }
        }
    }
}

struct JoinView_Previews: PreviewProvider {
    static var previews: some View {
        JoinView()
    }
}
