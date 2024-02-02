//
//  ResumeEvaluator.swift
//  ResumeDesigner
//
//  Created by Julien Vanheule on 14/09/2021.
//

import Foundation

class ResumeEvaluator {
    private var resume: ResumeContent
    private var advices: [Advice]
    
    var message: String
    var completion: Float //(from 0 to 1 (fully complete = respect all advice conditions)
    
    init(resume: ResumeContent) {
        self.resume = resume
        self.advices = [
            Advice(name: "Name", message: "Fill in your full name.", condition: {
                !resume.contact.name.isEmpty
            }),
            Advice(name: "Phone", message: "Fill in your phone number.", condition: {
                !resume.contact.phone.isEmpty
            }),
            Advice(name: "Address", message: "Fill in your address.", condition: {
                !resume.contact.street.isEmpty && !resume.contact.city.isEmpty
            }),
            Advice(name: "Email", message: "Fill in your email.", condition: {
                !resume.contact.email.isEmpty
            }),
            Advice(name: "Job title", message: "What is your job?", condition: {
                !resume.contact.designation.isEmpty
            }),
            Advice(name: "Work experience", message: "List your work experiences.", condition: {
                for section in resume.sections {
                    if section.style == .detailled && section.items.count >= 1 {
                        return true
                    }
                }
                return false
            }),
            Advice(name: "Skills", message: "List your skills.", condition: {
                for section in resume.sections {
                    if section.style == .titleRate && section.items.count >= 1 {
                        return true
                    }
                }
                return false
            }),
            Advice(name: "Languages", message: "List your languages.", condition: {
                for section in resume.sections {
                    if section.style == .language && section.items.count >= 1 {
                        return true
                    }
                }
                return false
            }),
            Advice(name: "Portrait", message: "Add you photo.", condition: {
                !resume.contact.formattedAddress.isEmpty
            }),
            Advice(name: "Hobbies, certificats, projects", message: "Add another section to complete your resume.", condition: {
                return resume.sections.count >= 5
            }),
        ]
        
        var cpt:Float = 0
        for advice in advices {
            if !advice.fullfilled {
                self.completion = cpt/Float(advices.count)
                self.message = advice.message
                return
            }
            cpt += 1
        }
        self.completion = 1
        self.message = "Your resume is ready."
    }
}

struct Advice {
    var name: String
    var message: String
    var condition: () -> Bool
    
    var fullfilled: Bool {
        return condition()
    }
}
