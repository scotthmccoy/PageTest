////
////  ContentView.swift
////  PageTest
////
////  Created by Scott McCoy on 1/30/22.
////
//
//import SwiftUI
//
//
////From https://stackoverflow.com/questions/70596634/why-animation-doesnt-work-inside-a-child-view-passed-by-binding
//
//@main
//struct PageTestApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}
//
//
//extension ContentView {
//    class ViewModel: ObservableObject {
//        @Published var users = [User]()
//
//        func createUser() {
//            users.append(User(times: []))
//        }
//    }
//
//    struct User: Equatable {
//        let name = UUID().uuidString
//        var times: [Date]
//    }
//}
//
//struct ContentView: View {
//    @StateObject var vm = ViewModel()
//
//    var body: some View {
//        NavigationView {
//            List {
//                ForEach(vm.users.indices, id: \.self) { index in
//                    NavigationLink {
//                        UserView(user: $vm.users[index])
//                    } label: {
//                        Text(vm.users[index].name)
//                    }
//                }
//                .onDelete { offsets in
//                    vm.users.remove(atOffsets: offsets)
//                }
//                Button("Add") {
//                    withAnimation {
//                        vm.createUser()
//                    }
//                }
//            }
//            .navigationTitle("Parent View")
//        }
//    }
//}
//
//struct UserView: View {
//    @Binding var user: ContentView.User
//
//    var body: some View {
//        List {
//            ForEach(user.times.indices, id: \.self) { index in
//                Text(user.times[index].description)
//            }
//            .onDelete { offsets in
//                user.times.remove(atOffsets: offsets)
//            }
//            Button {
//                withAnimation {
//                    user.times.append(Date())
//                }
//            } label: {
//               Text("Add Time")
//            }
//
//        }
//        .navigationTitle("Child View")
//        .animation(.default, value: user.times)
//    }
//}
//
