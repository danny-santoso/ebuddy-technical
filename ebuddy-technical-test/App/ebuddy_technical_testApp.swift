//
//  ebuddy_technical_testApp.swift
//  ebuddy-technical-test
//
//  Created by danny santoso on 12/19/24.
//

import SwiftUI
import FirebaseFirestore

@main
struct ebuddy_technical_testApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                UserListView(
                    viewModel: UserListViewModel(
                        fetchUserUseCase: Injection.init().provideFetchUser()))
            }
        }
    }
}
