//
//  ContentView.swift
//  PageTest
//
//  Created by Scott McCoy on 1/30/22.
//

import SwiftUI

//MARK: Model
struct Shelf : Identifiable {
  var id = UUID()
  var title: String

  var books: [Book]
}

struct Book : Identifiable, Equatable {
  var id = UUID()
  var title: String

  var pages: [Page]
}

struct Page : Identifiable, Equatable {
  var id = UUID()
  var content: String
}


//MARK: App
@main
struct PageTestApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ShelfView(Shelf(title:"My Shelf", books:[]))
            }
            .navigationViewStyle(.stack)
        }
    }
}


//MARK: ShelfView
struct ShelfView: View {
    @State private var shelf: Shelf {
        didSet {
            print("Shelf Changed")
        }
    }

    init(_ shelf: Shelf) {
        _shelf = State<Shelf>(initialValue: shelf)
    }

    var body: some View {

        List {
            Section(header:
                HStack {
                    Text("Books")
                    Spacer()
                    Button("Add") {
                        withAnimation {
                            shelf.books.append(Book(title:"New Book", pages:[]))
                        }
                    }
                }
            ) {
                ForEach(Array(shelf.books.enumerated()), id: \.1.id) { (i, book) in
                    NavigationLink("Book \(i) - \(book.pages.count) pages", destination: BookView(book: self.$shelf.books[i]))
                }
            }
        }
        .listStyle(GroupedListStyle())
        .navigationBarTitle(shelf.title)
    }
}


//MARK: BookView
struct BookView: View {
    @Binding var book: Book {
        didSet {
            print("Book Changed")
        }
    }
    
    @State var selectedPage:Binding<Page>?
    @State var navigationLinkIsActive = false
    
    var body: some View {
        List {
            Section(header:
                HStack {
                    Text("Pages")
                    Spacer()
                    Button("Add Page") {
                        withAnimation {
                            book.pages.append(Page(content:"New Page"))
                        }
                    }
                }
            ) {
                
                VStack {
                    //The Navlink doesn't exist until populated
                    if let selectedPage = selectedPage {
                        NavigationLink(destination: PageView(page: selectedPage, pageNumber:0), isActive:$navigationLinkIsActive){ EmptyView() }
                    }
                }.hidden()
                
                
                //NavigationLink("\(page.content)", destination: PageView(page:$page, pageNumber:0))
                    
                ForEach($book.pages) { $page in
                    Button("\(page.content)") {
                        self.selectedPage = $page
                        DispatchQueue.main.async {
                            self.navigationLinkIsActive = true
                        }
                    }
                }
            }
        }
        .animation(.default, value: book.pages)
        .listStyle(GroupedListStyle())
        .navigationBarTitle(book.title)
    }
}

//MARK: PageView
struct PageView: View {
    @Binding var page:Page {
        didSet {
            print("Page Changed")
        }
    }
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
