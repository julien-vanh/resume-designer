//
//  Completion.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 11/10/2021.
//

import SwiftUI

struct Completion: View {
    var resume: Resume
    var evaluator: ResumeEvaluator
    
    init(resume: Resume){
        self.resume = resume
        self.evaluator = ResumeEvaluator(resume: resume.content)
    }
    
    var body: some View {
        VStack {
            ProgressionBar(value: evaluator.completion).frame(height: 10)
            
            HStack(alignment: .top) {
                Text(NSLocalizedString(evaluator.message, comment: ""))
                    .font(.callout)
                
                Spacer()
                
                Text(percentDisplay())
                    .font(.headline)
                    .foregroundColor(evaluator.completion > 0 ? .green : .red)
            }
            
        }
    }
    
    private func percentDisplay() -> String {
        return "\(Int(evaluator.completion * 100.0))%"
    }
}

struct Completion_Previews: PreviewProvider {
    static var previews: some View {
        Completion(resume: RandomGenerator.randomResume())
    }
}
