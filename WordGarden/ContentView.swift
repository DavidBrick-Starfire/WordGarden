//
//  ContentView.swift
//  WordGarden
//
//  Created by David Brick on 12/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var wordList = ["SWIFT","DOG","CAT"]
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMessage = "How many guesses to uncover the hidden word?"
    @State private var currentWord = 0
    @State private var letterGuessed = ""
    @State private var imageFileName = "flower8"
    @State private var playAgainHidden = true
    @FocusState private var textFieldIsFocused: Bool
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: 0")
                    Text("Words Missed: 0")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Words to Guessed: \(wordList.count - wordsGuessed - wordsMissed)")
                    Text("Words in Game: \(wordList.count)")
                }
            }
            .padding(.horizontal)
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .padding()
            
            //TODO: Siwtch to wordsToGuess[currentWord]
            Text("_ _ _ _ _")
                .font(.title)
            if playAgainHidden {
                HStack {
                    TextField("", text: $letterGuessed)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 30)
                        .overlay {
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(.gray, lineWidth: 2)
                        }
                        .keyboardType(.asciiCapable)
                        .submitLabel(.done)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.characters)
                        .onChange(of: letterGuessed) {
                            letterGuessed = letterGuessed.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = letterGuessed.last else { return }
                            letterGuessed = String(lastChar).uppercased()
                        }
                        .focused($textFieldIsFocused)
                    Button("Guess a Letter") {
                        //TODO:  Button guess here
 //                       playAgainHidden = false
                        textFieldIsFocused = false
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(letterGuessed.isEmpty)
                }
            } else {
                Button("Another Word")
                {
                    //TODO: Another Wrod Button Action Here
 //                   playAgainHidden=true
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
        }
        Image(imageFileName)
            .resizable()
            .scaledToFit()
            .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ContentView()
}
