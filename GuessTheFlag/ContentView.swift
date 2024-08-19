//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Aaron Graves on 3/5/24.
//

import SwiftUI

struct FlagImage: View {
    var country: String
    
    var body: some View {
        Image(country)
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var showingReset = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var score = 0
    @State private var rounds = 0
    let maxRounds = 8
    
    // For animations
    @State private var selectedFlag = -1
    
    // Accessibility
    let labels = [
        "Estonia": "Flag with three horzontal stripes. Top stripe blue, middle stripe black, bottom stripe white.",
        "France": "Flag with three vertical stripes. Left stripe blue, middle stripe white, right stripe red.",
        "Germany": "Flag with three horizontal stripes. Top stripe black, middle stripe red, bottom stripe gold.",
        "Ireland": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe orange.",
        "Italy": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe red.",
        "Nigeria": "Flag with three vertical stripes. Left stripe green, middle stripe white, right stripe green.",
        "Poland": "Flag with two horizontal stripes. Top stripe white, buttom stripe red.",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe is gold with a crest on the left, bottom thin stripe red.",
        "UK": "Flag with overlapping read and white crosses, both straight and diagonally, on a blue background.",
        "Ukraine": "Flag with two horizontal stripes. Top stripe blue, bottom stripe yellow.",
        "US": "Flag with many red and white stripes, with white stars on a blue background in the top-left corner."
    ]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(country: countries[number])
                        }
                        .accessibilityLabel(labels[countries[number]])
                        .opacity(selectedFlag >= 0 && selectedFlag != number ? 0.25 : 1)
                        .scaleEffect(selectedFlag >= 0 && selectedFlag != number ? 0.5 : 1)
                        .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y: 1, z: 0))
                        .animation(.default, value: selectedFlag)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        .alert("Game over!", isPresented: $showingReset) {
            Button("Start over", action: startOver)
        } message: {
            Text("You've completed \(maxRounds) rounds, your final score is \(score)/\(maxRounds).")
        }
    }
    
    func flagTapped(_ number: Int) {
        // Selected flag number
        selectedFlag = number
        // Clear out anything that was in scoreMessage
        scoreMessage = ""
        // Round count
        rounds += 1
        
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct!"
            scoreMessage = "Your score is now \(score)"
        } else {
            scoreTitle = "Wrong!"
            scoreMessage = "I'm sorry, that's the flag of \(countries[number]). Your score remains \(score)"
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
        
        //If we've completed maxRounds rounds, let's start over!
        if(rounds >= maxRounds) {
            showingReset = true
        }
    }
    
    func startOver() {
        score = 0
        //askQuestion()
    }
}

#Preview {
    ContentView()
}
