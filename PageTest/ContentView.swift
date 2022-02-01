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
                ShelfView(shelf:Shelf(title:"My Shelf", books:[]))
            }
            //NOTE: Need this to prevent the PageView from popping when editing Page.content
            .navigationViewStyle(.stack)
        }
    }
}


//MARK: ShelfView
struct ShelfView: View {
    @State var shelf: Shelf

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
