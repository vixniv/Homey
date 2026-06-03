//
//  OnboardingPage.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 03/06/26.
//

import Foundation

struct OnboardingPage {
    let imageName: String
    let title: String
    let subtitle: String
    let imageLeadingPadding: CGFloat
    let imageHeight: CGFloat
}

let onboardingPages: [OnboardingPage] = [
    OnboardingPage(
        imageName: "phone1",
        title: "Assign task",
        subtitle: "Assign and track house chores to home members easily.",
        imageLeadingPadding: 50,
        imageHeight: 450
    ),
    OnboardingPage(
        imageName: "phone2",
        title: "Check schedule",
        subtitle: "Check overall schedule for house chores for all home member.",
        imageLeadingPadding: 15,
        imageHeight: 450
    ),
    OnboardingPage(
        imageName: "phone3",
        title: "Progress checking",
        subtitle: "Check overall schedule for house chores for all home member.",
        imageLeadingPadding: 0,
        imageHeight: 480
    )
]
