import SwiftUI
import Combine

enum stages {
    case start, during, end
}

struct QuizView: View {
    
    @StateObject var quizService = QuizService()
    
    @State var stage: stages = .start
    
    var quizPrompts: [Prompts] = Prompts.samplePrompts
    
    init() {
        quizPrompts.shuffle()
    }

    var body: some View {
        
        VStack {
            
            ProgressView("", value: quizService.progress, total: Double(quizPrompts.count))
                .tint(.green)
                .background(.thinMaterial)
                .animation(.easeIn, value: quizService.progress)
                .frame(maxWidth: .infinity)
                
            
            VStack {
                switch stage {
                case .start:
                    StartCard(stage: $stage)
                        .padding()
                    
                case .during:
                    PromptCards(prompts: quizPrompts, quizService: quizService, stage: $stage)
                        .padding()
                case .end:
                    EndCard(quizService: quizService)
                        .padding()
                }
            }
            .padding()
            .animation(.easeInOut(duration: 0.5), value: stage)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct StartCard: View {
    
    @Binding var stage: stages
    
    var body: some View {
        
        VStack {
            Text("Are you ready?")
                .font(.system(.title, design: .rounded))
                .fontWeight(.heavy)
                .padding()
            
            Button {
                stage = .during
            } label: {
                Text("Begin")
                    .font(.system(.title2, design: .rounded))
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                    .padding()
                    .background(.green)
                    .cornerRadius(15)
                    .padding()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct PromptCards: View {
    
    let prompts: [Prompts]
    
    let quizService: QuizService
    
    @State var index = 0
    
    @Binding var stage: stages
    
    var body: some View {
        VStack {
            Text(prompts[index].prompt)
                .font(.title2)
                .fontWeight(.bold)
                .fontDesign(.rounded)
                .padding(.vertical)
            
            ForEach(prompts[index].options, id: \.self) { quizAnswer in
                
                Button {
                    quizService.answers.send(quizAnswer)
                    
                    if prompts.count == index + 1  {
                        stage = .end
                        
                        // Send completion to save totalPoints
                        quizService.answers.send(completion: .finished)
                        quizService.saver.send(completion: .finished)
                        
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
        .animation(.default, value: index)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct EndCard: View {
    
    let quizService: QuizService
    
    var body: some View {
        VStack {
            Text("Your Points: \(quizService.totalPoints)/20")
                .padding()
            Text("Thank you!")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.rounded)
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        QuizView()
    }
}
