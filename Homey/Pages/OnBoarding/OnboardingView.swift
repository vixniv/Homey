//
//  OnboardingView.swift
//  Homey
//
//  Created by Nadila Rizky Amelia on 03/06/26.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var goToLogin = false

    var body: some View {
        NavigationStack {
            if goToLogin {
                HomeView() //Change LoginView()
            } else if currentPage == 0 {
                welcomeScreen
            } else {
                slideScreen
            }
        }
    }

    var welcomeScreen: some View {
        VStack {
            Spacer()
            Image("logo1")
                .padding(.bottom, 20)
            Text("Welcome to Homey!")
                .font(.title)
                .bold()
            Text("Add, organize, and assign house chores easily in one app.")
                .font(.title2)
                .padding(.horizontal, 20)
                .padding(.top, 3)
                .multilineTextAlignment(.center)

            Spacer()

            Button {
                currentPage = 1
            } label: {
                Text("Start")
                    .font(.title2)
                    .fontWeight(.medium)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.appPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(30)
                    .padding(.horizontal, 20)
            }
            .padding(.bottom, 100)
        }
    }

    var slideScreen: some View {
        let page = onboardingPages[currentPage - 1]
        let isLast = currentPage == onboardingPages.count

        return ZStack {
            LinearGradient(
                colors: [Color(red: 0.24, green: 0.67, blue: 0.93), .white],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Image(page.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: page.imageHeight)
                    .shadow(radius: 16)
                    .padding(.top, 40)
                    .padding(.leading, page.imageLeadingPadding)

                Spacer()

                Text(page.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Text(page.subtitle)
                    .font(.body)
                    .foregroundColor(.black.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 50)
                    .padding(.top, 8)

                Spacer()

                Button {
                    if isLast {
                        goToLogin = true
                    } else {
                        currentPage += 1
                    }
                } label: {
                    Text(isLast ? "Finish" : "Next")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.black)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.85))
                        .cornerRadius(30)
                        .padding(.horizontal, 32)
                }

                HStack(spacing: 8) {
                    ForEach(0..<onboardingPages.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentPage - 1 ? Color.black : Color.black.opacity(0.3))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.top, 16)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    OnboardingView()
}
