//
//  ContentView.swift
//  PageTest
//
//  Created by Scott McCoy on 1/30/22.
//

import SwiftUI

//MARK: Model
struct Shelf {
  var id = UUID()
  var title: String

  var books: [Book]
}

struct Book {
  var id = UUID()
  var title: String

  var pages: [Page]
}

struct Page {
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
                        shelf.books.append(Book(title:"New Book", pages:[]))
                    }
                }
            ) {
                ForEach(Array(shelf.books.enumerated()), id: \.1.id) { (i, book) in
                    NavigationLink("Book \(i)", destination: BookView(book: self.$shelf.books[i]))
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
    
    var body: some View {
        List {
            Section(header:
                HStack {
                    Text("Pages")
                    Spacer()
                    Button("Add Page") {
                        book.pages.append(Page(content:"New Page"))
                    }
                }
            ) {
                ForEach(Array(book.pages.enumerated()), id: \.1.id) { (i, page) in
                    NavigationLink("Page \(i)", destination: PageView(page:$book.pages[i], pageNumber:i))
                }
            }
        }
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
