//
//  ContentView.swift
//  PaperRockScissorsChoose
//
//  Created by Danny Tsang on 9/19/23.
//
typealias VoidClosure = () -> Void

import SwiftUI

enum ChoiceType {
    case paper
    case rock
    case scissors

    func text() -> String {
        switch self {
        case .paper:        return "Paper"
        case .rock:         return "Rock"
        case .scissors:     return "Scissors"
        }
    }

    func image() -> Image {
        switch self {
        case .paper:        return Image(systemName:"doc.circle")
        case .rock:         return Image(systemName:"moonphase.waning.crescent")
        case .scissors:     return Image(systemName:"scissors.circle.fill")
        }
    }

    func beats(_ choice: ChoiceType) -> Bool {
        switch self {
        case .paper:        return choice == .rock
        case .rock:         return choice == .scissors
        case .scissors:     return choice == .paper
        }
    }
}

struct TitleView: View {
    var title: String
    var body: some View {
        HStack {
            Spacer()
            Text(title)
                .font(.title)
                .foregroundColor(.white)
            Spacer()
        }
        .padding(5)
        .background(.black)
    }
}

struct ChoiceButton: View {
    var type: ChoiceType
    var action: VoidClosure

    var body: some View {
        Button() {
            action()
            print("PRINT: Tapped \(type.text())")
        } label: {
            VStack {
                type.image()
                    .font(Font.system(size: 50))
                Text(type.text())
            }
        }
        .font(.headline)
        .frame(width: 300, height: 100)
        .foregroundColor(.white)
    }
}

struct ContentView: View {
    let choices: [ChoiceType] = [.paper, .rock, .scissors]
    let maxRounds = 10

    @State private var playerChoice: Int?
    @State private var showResult: Bool = false
    @State private var computerChoice: Int = Int.random(in: 0..<2)
    @State private var computerPrediction: Int = Int.random(in: 0..<2)
    @State private var computerLiedCount = 0
    @State private var playerScore = 0
    @State private var tiedScore = 0
    @State private var computerScore = 0
    @State private var roundNumber = 0

    var body: some View {
        VStack {
            Group {
                Spacer()
                Text("PRS EXTREME")
                    .font(.custom("", size: 50))
                Spacer()
            }

            Group {
                TitleView(title: "Computer Chooses:")
                    .padding(5)
                Text(showResult ? choices[computerChoice].text() : "... I'm going with... \(choices[computerPrediction].text()) ...")
                Spacer()
           }

            Group {
                TitleView(title: "Player Chooses:")
                    .padding(5)

                ForEach(choices, id: \.self) { choice in
                    ChoiceButton(type: choice) {
                        playerChoice = choices.firstIndex(of: choice)
                        showResult = true
                    }
                    .background(playerChoice == choices.firstIndex(of: choice) ? .blue : .red)
                    .clipShape(Capsule())

                }
                Spacer()
            }

            Group {
                TitleView(title: "Stats")
                    .padding(5)
                VStack {
                    HStack {
                        Text("Player: \(playerScore)")
                        Spacer()
                        Text("Tied: \(tiedScore)")
                        Spacer()
                        Text("Computer: \(computerScore)")
                    }
                    HStack {
                        Text("Rounds: \(roundNumber)")
                        Spacer()
                        Text("Computer Lied: \(computerLiedCount)")
                    }
                }
                .padding(.horizontal, 40)
                Spacer()
            }


        }
        .alert("Result", isPresented: $showResult) {
            Button("OK") {
                scoreResult()
            }
        } message: {
            VStack {
                let message = choices[playerChoice ?? 0].beats(choices[computerChoice]) ? "You Win!" : choices[computerChoice].beats(choices[playerChoice ?? 0]) ? "You Lose" : "You Tied"
                Text("\(message)\n\nPlayer chose: \(playerChoice != nil ? choices[playerChoice ?? 0].text() : "NA")\nComputer chose: \(choices[computerChoice].text())")
            }
        }
    }

    func scoreResult() {
        if let playerChoice {
            if choices[playerChoice].beats(choices[computerChoice]) {
                playerScore += 1
            } else if choices[computerChoice].beats(choices[playerChoice]) {
                computerScore += 1
            } else {
                tiedScore += 1
            }
        }

        if computerChoice != computerPrediction {
            computerLiedCount += 1
        }

        resetGame()
    }

    func resetGame() {
        roundNumber += 1
        playerChoice = nil
        computerPrediction = Int.random(in: 0..<choices.count)
        computerChoice = Int.random(in: 0..<choices.count)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
