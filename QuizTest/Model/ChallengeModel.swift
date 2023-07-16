
import Foundation

struct Prompts: Hashable {
    
    let prompt: String
    
    let options: [Responses]
    
}

struct Responses: Hashable {
    
    let answer: String
    
    var value: Int
    
}

extension Prompts {
    
    static let samplePrompts: [Prompts] = [
        
        Prompts(prompt: "Did you shut the lights off when not using it?",
                   options: [
                    Responses(answer: "Didn't consider it", value: 0),
                    
                    Responses(answer: "I did", value: 5),
                   ]),
        
        Prompts(prompt: "Did you reduce water",
                   options: [
                    Responses(answer: "Didn't consider it", value: 0),
                    
                    Responses(answer: "I did today!", value: 5),
                   ]),
        
        Prompts(prompt: "Did you recycle today",
                   options: [
                    Responses(answer: "Didn't consider it", value: 0),
                    
                    Responses(answer: "I tried to...", value: 3),
                    
                    Responses(answer: "I did today!", value: 5),
                   ])

    ]
}
