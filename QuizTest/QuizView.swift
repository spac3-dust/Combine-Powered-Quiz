//
//  QuizView.swift
//  QuizTest
//
//  Created by Abe on 4/7/23.
//

import SwiftUI
import Combine

struct QuizPrompt: Hashable {
    
    let prompt: String
    
    let options: [QuizAnswer]
    
}

struct QuizAnswer: Hashable {
    
    let answer: String
    
    var value: Int
    
}

extension QuizPrompt {
    
    static let samplePrompts: [QuizPrompt] = [
        
        QuizPrompt(prompt: "Did you shut the lights off when not using it?",
                   options: [
                    QuizAnswer(answer: "Didn't consider it", value: 0),
                    
                    QuizAnswer(answer: "I did", value: 5),
                   ]),
        
        QuizPrompt(prompt: "Did you reduce water",
                   options: [
                    QuizAnswer(answer: "Didn't consider it", value: 0),
                    
                    QuizAnswer(answer: "I did today!", value: 5),
                   ])

    ]
}

class QuizService {
    
    var answers = PassthroughSubject<QuizAnswer, Never>()
    
    //@Published var answers: [QuizAnswer] = []
    @State var cancellables = Set<AnyCancellable>()
    
    var totalPoints: Int = 0
    
    init() {
        calculatePoints()
        
    }

    func calculatePoints() {
        answers
            .sink(receiveValue: { bob in
                self.totalPoints += bob.value
                
            })
            .store(in: &cancellables)
        
        print(totalPoints)
    }

}

struct QuizView: View {
    
    let quizPrompts: [QuizPrompt]
    let quizService = QuizService()
    
    @State var cancellables = Set<AnyCancellable>()
    
    @State var index: Int = 0
    
    @State private var showEndView = false
    
    var body: some View {
        
        VStack {
            if showEndView {
                VStack {
                    Text("Thank you.")
                        .font(.title)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    //Text("\(quizService.getPoints())")
                    
                    Text("Get Score")
                        .font(.largeTitle)
                        .onTapGesture {
                            quizService.calculatePoints()
                        }
                }
                .padding()
            }
            else {
                VStack {
                    Text(quizPrompts[index].prompt)
                        .font(.title2)
                        .fontWeight(.bold)
                        .fontDesign(.rounded)
                    
                    ForEach(quizPrompts[index].options, id: \.self) { quizAnswer in
                        
                        Button {
                            quizService.answers.send(quizAnswer)
                
                            if quizPrompts.count == index + 1  {
                                showEndView.toggle()
                            } else {
                                index += 1
                            }
                            
                        } label: {
                            Text(quizAnswer.answer)
                                .foregroundColor(.white)
                                .padding()
                                .background(.green)
                                .cornerRadius(15)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView(quizPrompts: QuizPrompt.samplePrompts)
    }
}
