import SwiftUI
import Combine

class QuizService: ObservableObject {
    
    // Publishers
    @Published var totalPoints = 0
    
    @Published var progress: Double = 0.0
    
    var answers = PassthroughSubject<Responses, Never>()
    
    var saver = PassthroughSubject<Int, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        calcPoints()
        save()
    }
    
    // Uses Combine to calculate total points whenever user input is received
    func calcPoints() {
        answers
            .sink { [self] ans in
                
                totalPoints += ans.value
                saver.send(totalPoints)
                progress += 1
                
            }
            .store(in: &cancellables)
    }
    
    func save() {
        saver
            .collect()
            .map{ $0.last! }
            .sink { int in
                UserDefaults.standard.set(int, forKey: "userPoints")
                print("Saved: \(int)")
            }
            .store(in: &cancellables)
    }
    
    
    
}
