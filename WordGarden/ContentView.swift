//
//  ContentView.swift
//  WordGarden
//
//  Created by David Brick on 12/30/25.
//

import SwiftUI

struct ContentView: View {
    //    @State private var wordList = ["SWIFT","DOG","CAT"]
    private static let maximumGuesses = 8   // Need to refere to this as Self.maximumGuesses
    @State private var wordsGuessed = 0
    @State private var wordsMissed = 0
    @State private var gameStatusMessage = "How many guesses to uncover the hidden word?"
    @State private var currentWordIndex = 0
    @State private var wordToGuess = ""
    @State private var revealedWord = ""
    @State private var guessedLetter = ""
    @State private var lettersGuessed = ""
    @State private var guessesRemaining = maximumGuesses
    @State private var imageFileName = "flower"+String(maximumGuesses)
    @State private var playAgainHidden = true
    @State private var playAgainButtonLabel = "Play Again?"
    @FocusState private var textFieldIsFocused: Bool
    private let wordsToGuess = ["SWIFT","DOG","CAT"]
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Words Guessed: \(wordsGuessed)")
                    Text("Words Missed: \(wordsMissed)")
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Words to Guess: \(wordsToGuess.count - wordsGuessed - wordsMissed)")
                    Text("Words in Game: \(wordsToGuess.count)")
                }
            }
            .padding(.horizontal)
            Text(gameStatusMessage)
                .font(.title)
                .multilineTextAlignment(.center)
                .frame(height: 80)
                .minimumScaleFactor(0.5)
                .padding()
            
            Text(revealedWord)
                .font(.title)
            if playAgainHidden {
                HStack {
                    TextField("", text: $guessedLetter)
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
                        .onChange(of: guessedLetter) {
                            guessedLetter = guessedLetter.trimmingCharacters(in: .letters.inverted)
                            guard let lastChar = guessedLetter.last else { return }
                            guessedLetter = String(lastChar).uppercased()
                        }
                        .focused($textFieldIsFocused)
                        .onSubmit {
                            guard guessedLetter != "" else { return }
                            guessALetter()
                            updateGamePlay()
                        }
                    Button("Guess a Letter") {
                        guessALetter()
                        updateGamePlay()
                    }
                    .buttonStyle(.bordered)
                    .tint(.mint)
                    .disabled(guessedLetter.isEmpty)
                }
            } else {
                Button(playAgainButtonLabel)
                {
                    if currentWordIndex == wordsToGuess.count {
                        currentWordIndex = 0
                        wordsGuessed = 0
                        wordsMissed = 0
                        playAgainButtonLabel = "Another Word?"
                    }
                    wordToGuess = wordsToGuess[currentWordIndex]
                    revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
                    lettersGuessed = ""
                    guessesRemaining = Self.maximumGuesses
                    imageFileName = "flower\(guessesRemaining)"
                    gameStatusMessage = "How Many Guesses to Uncover the Hidden Word?"
                    playAgainHidden = true
                }
                .buttonStyle(.borderedProminent)
                .tint(.mint)
            }
            Image(imageFileName)
                .resizable()
                .scaledToFit()
        }
        .ignoresSafeArea(edges: .bottom)
        .onAppear {
            wordToGuess = wordsToGuess[currentWordIndex]
            revealedWord = "_" + String(repeating: " _", count: wordToGuess.count - 1)
        }
    }
    
    func guessALetter() {
        
        textFieldIsFocused = false
        lettersGuessed = lettersGuessed + guessedLetter
        revealedWord=wordToGuess.map {
            letter in lettersGuessed.contains(letter) ? "\(letter)" : "_"
        }.joined(separator: " ")
    }
    
    func updateGamePlay() {
        if !wordToGuess.contains(guessedLetter) {
            guessesRemaining -= 1
            imageFileName = "flower\(guessesRemaining)"
        }
        
        if !revealedWord.contains("_") {
            wordsGuessed += 1
            gameStatusMessage = "You Guessed It! It took you \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es") to Guess the Word."
            currentWordIndex += 1
            playAgainHidden = false
        } else if guessesRemaining == 0 {
            gameStatusMessage = "Your are out of Guesses. The word was \(wordToGuess)."
            wordsMissed += 1
            currentWordIndex += 1
            playAgainHidden = false
        } else {
            //TODO: Redo this with LocalizedStringKey & Inflect
            gameStatusMessage = "You've made \(lettersGuessed.count) Guess\(lettersGuessed.count == 1 ? "" : "es")"
        }
        if currentWordIndex == wordsToGuess.count {
            playAgainButtonLabel = "Restart Game?"
            gameStatusMessage += "\nYou've Tried All of the Words. Restart from the Beginning?"
        }
            guessedLetter = ""
    }
    
}

#Preview {
    ContentView()
}
