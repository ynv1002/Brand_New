//
//  CreateLeagueView.swift
//  Brand New
//
//  Created by Yaniv Naggar on 6/22/23.
//

import SwiftUI

struct CreateLeagueView: View {
    @State private var leagueName: String = ""
    @State private var teamName: String = ""
    @State private var team = FireBaseBackground.Team()
    
    let positions = ["QB", "RB1", "RB2", "WR1", "WR2", "TE", "FLX", "DEF", "K"]

    var body: some View {
        ScrollView {
            VStack {
                TextField("League Name", text: $leagueName)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8.0)
                
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
                    createLeagueAndTeam()
                }) {
                    Text("Create League and Team")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(8.0)
                }
                .padding(.top)
            }
        }
        .padding()
        .navigationTitle("Create a New League and Team")
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
    
    private func createLeagueAndTeam() {
        guard !leagueName.isEmpty else {
            // Show an error message or perform appropriate validation
            return
        }

        FireBaseBackground.createLeague(leagueName: leagueName) { [self] result in
            switch result {
            case .success(let leagueId):
                print("League created with ID: \(leagueId)")
                self.createTeam(with: leagueId)
            case .failure(let error):
                print("Failed to create league: \(error.localizedDescription)")
                // Handle league creation error
            }
        }
    }
    
    private func createTeam(with leagueId: String) {
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

struct CreateLeagueView_Previews: PreviewProvider {
    static var previews: some View {
        CreateLeagueView()
    }
}
