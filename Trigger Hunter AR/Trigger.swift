//
//  Trigger.swift
//  Trigger Hunter AR
//
//  Created by Cal Stephens on 11/9/17.
//  Copyright © 2017 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import UIKit

// MARK: Structs

struct Trigger {
    let name: String
    let pluralizedName: String
    let subjectName: String
    let image: UIImage
    let backgroundText: String
    let actionPlan: [String]
    let quiz: Quiz
}

struct Quiz {
    let questions: [Question]
    
    init(_ questions: [Question]) {
        self.questions = questions
    }
    
    func question(after currentQuestion: Question?) -> Question? {
        guard let currentQuestion = currentQuestion else {
            return questions.first
        }
        
        if let currentIndex = questions.index(of: currentQuestion),
            currentIndex != questions.count - 1
        {
            return questions[currentIndex + 1]
        }
        
        return nil
    }
}

struct Question: Equatable {
    let text: String
    let correctAnswer: String
    let incorrectAnswers: [String]
    
    var allAnswers: [String] {
        return [correctAnswer] + incorrectAnswers
    }
    
    static func ==(lhs: Question, rhs: Question) -> Bool {
        return lhs.text == rhs.text
            && lhs.allAnswers == rhs.allAnswers
    }
}

// MARK: Data

extension Trigger {
    
    static func named(_ name: String) -> Trigger? {
        return all.first(where: { $0.name == name })
    }
    
    static let all = [
    
        Trigger(
            name: "Dust Mite",
            pluralizedName: "Dust Mites",
            subjectName: "a dust mite",
            image: #imageLiteral(resourceName: "Dust Mite"),
            backgroundText: "Dust Mites are microscopic bugs related to ticks. They eat dead skin that people shed every day and prefer warm, humid environments. Dust mites live mostly in bedding, stuffed toys, and fabric-covered furniture.",
            actionPlan: [
                "Avoid dust collectors",
                "Remove dust often with a damp cloth",
                "Wash clothes once a week in hot water and dry in a dryer",
                "Store clothers in enclosed cases or closet"],
            quiz: Quiz([
                Question(
                    text: "Where do Dust Mites like to live?",
                    correctAnswer: "Bedding",
                    incorrectAnswers: [
                        "In the Fridge",
                        "Underwater",
                        "In your Food"]),
                Question(
                    text: "What would best help you avoid Dust Mites?",
                    correctAnswer: "Washing your clothes once a week",
                    incorrectAnswers: [
                        "Sleeping outside",
                        "Staying indoors",
                        "Using bugspray"]),
                Question(
                    text: "How large are Dust Mites?",
                    correctAnswer: "Microscopic",
                    incorrectAnswers: [
                        "Cat-sized",
                        "Elephant-sized",
                        "Ladybug-sized"])
                ])),
        
        Trigger(
            name: "Smoke",
            pluralizedName: "Smoke",
            subjectName: "smoke",
            image: #imageLiteral(resourceName: "Smoke"),
            backgroundText: "Smoke is a common trigger made of small particles and gases. It can come from wood fires, cigarettes, or most materials when burnt. Smoke can also come from burning candles and cooking. Large amounts of smoke inside will slowly go away but the process happens quicker with open doors and windows.",
            actionPlan: [
                "Avoid fires within enclosed areas.",
                "Ask people to not smoke cigarettes around you.",
                "Disallow smoking in your home and car.",
                "In case of forest fires, close all windows and doors and stay inside.",
                "Leave areas that have a lot of smoke."],
            quiz: Quiz([
                Question(
                    text: "What is a common source of smoke?",
                    correctAnswer: "Cigarettes",
                    incorrectAnswers: [
                        "Light Bulbs",
                        "Chalk",
                        "Bees"]),
                Question(
                    text: "How you make smoke disappear from inside your house?",
                    correctAnswer: "Open doors and windows",
                    incorrectAnswers: [
                        "Light a candle",
                        "Run the sink",
                        "Turn off the lights"]),
                Question(
                    text: "If someone is smoking a cigarette near you, what should you NOT do?",
                    correctAnswer: "Nothing",
                    incorrectAnswers: [
                        "Ask the person to stop smoking",
                        "Leave the area",
                        "Have an adult ask the person to stop smoking"])
                ])),
        
        Trigger(
            name: "Flu Virus",
            pluralizedName: "the Flu Virus",
            subjectName: "a flu virus",
            image: #imageLiteral(resourceName: "Flu Virus"),
            backgroundText: "The flu and similar viruses can lead to asthma attacks. The flu is very contagious and most common at the start of school and around the holidays.",
            actionPlan: [
                "Wash your hands regularly with warm water and soap.",
                "Get a flu shot every year.",
                "Do not share food or drinks with someone who is sick.",
                "Do not hug or kiss someone who is sick."],
            quiz: Quiz([
                Question(
                    text: "What should you do every year to prevent getting the flu?",
                    correctAnswer: "Get a flu shot",
                    incorrectAnswers: [
                        "Drink a glass of orange juice",
                        "Run a mile",
                        "Eat a bowl of chicken noddle soup"]),
                Question(
                    text: "When is it most common to get the flu?",
                    correctAnswer: "Holidays",
                    incorrectAnswers: [
                        "Summer",
                        "Over the Weekend",
                        "Mondays"]),
                Question(
                    text: "If someone is sick, what should you do?",
                    correctAnswer: "Wash your hands with soap and water",
                    incorrectAnswers: [
                        "Share their lunch",
                        "Give them a hug",
                        "Share water bottles"])
                ])),
        
        Trigger(
            name: "Mold",
            pluralizedName: "Mold",
            subjectName: "mold",
            image: #imageLiteral(resourceName: "Mold"),
            backgroundText: "Mold can cause asthma attacks when the spores are breathed in. It grows most commonly on old food and dead plants. Mold can also grow in dark, damp, warm places. ",
            actionPlan: [
                "Make sure there are no leaky pipes throughout the house.",
                "Make sure there are no leaks in the roof.",
                "Throw out any food that has gone bad.",
                "Use bleach to remove and kill any mold.",
                "Install a dehumidifier to keep mold from growing."],
            quiz: Quiz([
                Question(
                    text: "What do you do with food with mold on it?",
                    correctAnswer: "Throw it away",
                    incorrectAnswers: [
                        "Eat it",
                        "Feed it to the dog",
                        "Scrape off the mold"]),
                Question(
                    text: "How do you remove mold?",
                    correctAnswer: "Bleach",
                    incorrectAnswers: [
                        "Fire",
                        "Warm water",
                        "Scrape it off"]),
                Question(
                    text: "What is a common reason for mold?",
                    correctAnswer: "Leaky pipes",
                    incorrectAnswers: [
                        "Not dusting",
                        "Termites",
                        "Cleaning with bleach"])
                ])),
        
        Trigger(
            name: "Pet Dander",
            pluralizedName: "Pet Dander",
            subjectName: "pet dander",
            image: #imageLiteral(resourceName: "Pets"),
            backgroundText: "Pets, like cats and dogs, and other animals can lead to an asthma attack. Their skin, also called dander, and sometimes fur and feathers can irritate your lungs and make breathing difficult. Shaving pets is not effective to prevent an asthma attack since the skin is the primary cause.",
            actionPlan: [
                "Limit contact with pets and other animals.",
                "Have a parent make sure to vacuum and to dust regularly, but don’t be around when they do.",
                "Bathe your pet every one or two weeks.",
                "Keep the pet out of your bedroom."],
            quiz: Quiz([
                Question(
                    text: "How often should you bathe your pet?",
                    correctAnswer: "Every one or two weeks",
                    incorrectAnswers: [
                        "Never",
                        "Every day",
                        "When they smell bad"]),
                Question(
                    text: "Which part of an animal irritates the lungs?",
                    correctAnswer: "Skin",
                    incorrectAnswers: [
                        "Claws",
                        "Saliva",
                        "Hair"]),
                Question(
                    text: "What should you do if you have a pet?",
                    correctAnswer: "Vacuum regularly",
                    incorrectAnswers: [
                        "Let the pet sleep in your bed",
                        "Ignore the pet",
                        "Use the pet as a pillow"])
                ])),
        
        Trigger(
            name: "Pollen",
            pluralizedName: "Pollen",
            subjectName: "pollen",
            image: #imageLiteral(resourceName: "Pollen"),
            backgroundText: "Pollen a small particle found in the air that comes from plants. It is found in grass, weeds, trees, and flowers. Pollen is released by plants throughout the spring and summer. Thunderstorms and lots of wind will release more pollen into the air. Many people are allergic to pollen, but not everyone.",
            actionPlan: [
                "Make sure windows and doors are closed during pollen season.",
                "Install an air filter in your house.",
                "Get tested to see if you are allergic to any pollen."],
            quiz: Quiz([
                Question(
                    text: "What is a source of pollen?",
                    correctAnswer: "Flowers",
                    incorrectAnswers: [
                        "Water",
                        "Animals",
                        "Rocks"]),
                Question(
                    text: "What will cause pollen to fill the air?",
                    correctAnswer: "Thunderstorms",
                    incorrectAnswers: [
                        "Sunrise",
                        "Sunset",
                        "Snow"]),
                Question(
                    text: "What can you do during pollen season to limit your exposure?",
                    correctAnswer: "Close windows and doors",
                    incorrectAnswers: [
                        "Open windows",
                        "Stay outside",
                        "Hold your nose"])
                ])),
    
    ]
    
}
