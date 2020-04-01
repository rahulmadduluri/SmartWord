//
//  SuggestionRow.swift
//  SmartWordApp
//
//  Created by Rahul Madduluri on 3/26/20.
//  Copyright © 2020 rm. All rights reserved.
//

import SwiftUI

// A currently or recently searched city that displays the min/max temperature and the current conditions
struct SuggestionRow: View {
            
    private var suggestion: String
    
    init(suggestion: String) {
        print("OH")
        self.suggestion = suggestion
    }
    
    var body: some View {
        HStack(alignment: .center) {
            Text(suggestion)
                .font(Font.system(size: 14))
                .frame(width: 200, height: 30, alignment: .center)
        }
    }
}

struct SuggestionRow_Previews: PreviewProvider {
    static var previews: some View {
        SuggestionRow(suggestion: "test suggestion")
    }
}
