//
//  participantID.swift
//  Trigger Hunter AR
//
//  Created by Krrish Dholakia on 4/23/18.
//  Copyright © 2018 Mobile & Ubiquitous Computing 2017. All rights reserved.
//

import Foundation


class Participant: Codable {
    let participant_id: String
    
    init(participant_id: String) {
        self.participant_id = participant_id
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.participant_id = aDecoder.decodeObject(forKey: "participant_id") as! String!;
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.participant_id, forKey: "participant_id")
        
    }
}
