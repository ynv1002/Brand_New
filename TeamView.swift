import SwiftUI

struct Player {
    var name: String
    var value: Int
}

struct TeamView: View {
    @State private var team = FireBaseBackground.Team()
    let leagueId: String
    let teamName: String
    
    let positions = ["QB", "RB1", "RB2", "WR1", "WR2", "TE", "FLX", "DEF", "K"]

    var body: some View {
        ScrollView {
            VStack {
                Text("Starters")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(positions, id: \.self) { position in
                    playerTextField(position, player: bindingForPosition(position))
                }
                
                Text("Bench Players")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(0..<team.Bench.count, id: \.self) { index in
                    playerTextField("Player \(index + 1)", player: bindingForBenchPlayer(index))
                }
                
                Button(action: {
                    createTeam()
                }) {
                    Text("Create Team")
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
        .navigationTitle("Create Team")
    }
    
    private func bindingForPosition(_ position: String) -> Binding<Player?> {
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
            return Binding(get: { nil }, set: { _ in })
        }
    }
    
    private func bindingForBenchPlayer(_ index: Int) -> Binding<Player?> {
        return Binding(get: { team.Bench[index] }, set: { newValue in
            team.Bench[index] = newValue
        })
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
            
            Stepper(value: Binding(
                get: { player.wrappedValue?.value ?? 1 },
                set: { newValue in
                    if var current = player.wrappedValue {
                        current.value = newValue
                        player.wrappedValue = current
                    } else {
                        player.wrappedValue = Player(name: "", value: newValue)
                    }
                }
            ), in: 1...10) {
                Text("\(player.wrappedValue?.value ?? 1)")
            }
        }
        .padding(.vertical, 4)
    }
    
    private func createTeam() {
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

struct TeamView_Previews: PreviewProvider {
    static var previews: some View {
        TeamView(leagueId: "your-league-id", teamName: "your-team-name")
    }
}
