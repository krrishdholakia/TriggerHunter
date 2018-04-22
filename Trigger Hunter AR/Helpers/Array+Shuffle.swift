//
//  Array+Shuffle.swift
//  Trigger Hunter AR
//
//  Created by Cal Stephens on 11/13/17.
//  Copyright © 2017 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import Foundation

extension MutableCollection {
    
    // https://stackoverflow.com/questions/24026510/how-do-i-shuffle-an-array-in-swift
    
    /// Shuffles the contents of this collection in-place.
    mutating func shuffle() {
        let c = count
        guard c > 1 else { return }
        
        for (firstUnshuffled, unshuffledCount) in zip(indices, stride(from: c, to: 1, by: -1)) {
            let d: IndexDistance = numericCast(arc4random_uniform(numericCast(unshuffledCount)))
            let i = index(firstUnshuffled, offsetBy: d)
            swapAt(firstUnshuffled, i)
        }
    }
    
    /// Shuffles the contents of this collection.
    var shuffled: Self {
        var copy = self
        copy.shuffle()
        return copy
    }
    
}

