//
//  StyleStruct.swift
//  MyHabbits
//
//  Created by Ffhh Qerg on 18.04.2022.
//

import UIKit


enum StyleStuct {

    enum Font {
        static let title3 = UIFont.systemFont(ofSize: 20, weight: .semibold)
        static let headline = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let body = UIFont.systemFont(ofSize: 17)
        static let footnoteCapitalized = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let footnoteStatus = UIFont.systemFont(ofSize: 13, weight: .semibold)
        static let footnote = UIFont.systemFont(ofSize: 13)
        static let caption = UIFont.systemFont(ofSize: 12)
    }
    
    enum Color {
        static let accent = UIColor(named: "AccentColor") ?? UIColor.systemPurple
        static let blue = UIColor(named: "HabitsBlueColor") ?? UIColor.systemBlue
        static let green = UIColor(named: "HabitsGreenColor") ?? UIColor.systemGreen
        static let indigo = UIColor(named: "HabitsIndigoColor") ?? UIColor.systemIndigo
        static let orange = UIColor(named: "HabitsOrangeColor") ?? UIColor.systemOrange
        static let lightGray = UIColor(named: "LightGrayColor") ?? UIColor.systemGray6
        static let gray = UIColor.systemGray2
        static let darkGray = UIColor.systemGray
    }
    
    enum Margin {
        static let large: CGFloat = 22
        static let normal: CGFloat = 16
        static let small: CGFloat = 6
        
        enum Inner {
            static let small: CGFloat = 10
            static let normal: CGFloat = 12
            static let large: CGFloat = 15
        }
        
        enum Habit {
            static let normal: CGFloat = 20
            static let large: CGFloat = 26
            static let giant: CGFloat = 40
        }
    }
    
    enum Spacing {
        static let smallest: CGFloat = 4
        static let small: CGFloat = 7
        static let normal: CGFloat = 12
        static let large: CGFloat = 15
    }
    
    enum Radius {
        static let small: CGFloat = 4
        static let large: CGFloat = 8
    }
    
    enum Size {
        static let habitColorIndicator: CGFloat = 30
        static let minimumColumnWidth: CGFloat = 320
        static let progressCellHeight: CGFloat = 60
        static let progressBarHeight: CGFloat = 7
        static let habitCellHeight: CGFloat = 130
        static let habitTrackTickSize: CGFloat = 36
        static let habitTrackTickBorder: CGFloat = 2
    }
    
    enum MotivationalSpeeches {
        static let start = "?????????? ?????????? ????????????!"
        static let inProgress = "?????? ??????????????????!"
        static let finished = "??????????????!"
    }
    
    enum ActionType {
        case create
        case edit
    }
    
    enum ReuseIdentifier {
        static let habitDetail = "HabitDetailTableViewCell"
    }
    
    enum Defaults {
        static let habitColor = StyleStuct.Color.orange
    }

}

