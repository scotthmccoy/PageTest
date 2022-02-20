//
//  ContentView.swift
//  PageTest
//
//  Created by Scott McCoy on 1/30/22.
//

import SwiftUI

//MARK: Model
struct Node : Identifiable {
  var id = UUID()
  var name: String

  var children: [Node]
}



//MARK: App
@main
struct PageTestApp: App {
    @State var node = Node(name:"Root Node", children:[])
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                NodeView(node:$node)
            }
            //NOTE: Need this to prevent the PageView from popping when editing Page.content
            .navigationViewStyle(.stack)
        }
    }
}


//MARK: ShelfView
struct NodeView: View {
    
    @Binding var node:Node

    var body: some View {
        List {
            Section("Name") {
                TextField("", text: $node.name)
            }
            Section(header:
                HStack {
                    Text("Children")
                    Spacer()
                    Button("Add") {
                        withAnimation {
                            let name = String(UUID().uuidString.prefix(5))
                            node.children.append(Node(name: name, children: []))
                        }
                    }
                }
            ) {
                ForEach($node.children) { $child in
                    NavigationLink("\(child.name), \(child.children.count) children", destination: NodeView(node: $child))
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(node.name)
    }
}

/*

//MARK: BookView
struct BookView: View {
    @Binding var book: Book

    var body: some View {
        VStack {
            lnkPageView
            List {
                Section(header:
                    HStack {
                        Text("Pages")
                        Spacer()
                        Button("Add Page") {
                            //NOTE: Need this to allow for animation of appending pages
                            withAnimation {
                                book.pages.append(Page(content:"New Page"))
                            }
                        }
                    }
                ) {
                    ForEach($book.pages) { $page in
                        btnPageView($page)
                    }
                }
            }
        }
        //NOTE: Need this to allow for animation of appending pages
        .animation(.default, value: book.pages)
        .listStyle(GroupedListStyle())
        .navigationBarTitle(book.title)
    }
    
    
    //MARK: Nav Link to PageView
    @State var selectedPage:Binding<Page>?
    @State var navigationLinkIsActive = false
    
    var lnkPageView : some View {
        VStack {
            //The Navlink doesn't exist until populated
            if let selectedPage = selectedPage {
                NavigationLink(destination: PageView(page:selectedPage, pageNumber:0), isActive:$navigationLinkIsActive) {
                    EmptyView()
                }
            }
        }
        .frame(width: 0, height: 0)
        .hidden()
    }
    
    func btnPageView(_ page:Binding<Page>) -> some View {
        Button(action: {
            self.selectedPage = page
            DispatchQueue.main.async {
                self.navigationLinkIsActive = true
            }
        }, label: {
            ZStack {
                HStack {
                    Text("\(page.wrappedValue.content)")
                        .foregroundColor(.black)
                    Spacer()
                    Image(systemName:"chevron.forward")
                        .resizable()
                        .padding(6)
                        .frame(width: 19, height: 23)
                        .foregroundColor(.gray)
                }
            }
        })
    }
}

//MARK: PageView
struct PageView: View {
    @Binding var page:Page

    let pageNumber:Int
    
    var body: some View {
        List {
            Section("Edit Page") {
                TextField("", text: $page.content)
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle("Page \(pageNumber)")
    }
}

*/
