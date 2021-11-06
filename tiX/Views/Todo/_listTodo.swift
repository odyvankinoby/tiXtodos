
import SwiftUI
import CoreData

struct ListTodos: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var settings: UserSettings
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.timestamp, ascending: false)]) var todos: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "dueDate >= %@", Date().midnight as CVarArg)) var today: FetchedResults<Todo>
    
    @FetchRequest(entity: Todo.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Todo.todo, ascending: false)], predicate: NSPredicate(format: "dueDate < %@", Date().midnight as CVarArg)) var overdue: FetchedResults<Todo>
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)]) var categories: FetchedResults<Category>
    
    @State private var newItem = false
    
    @State private var selectCategory = false
    
    @State private var showImportant = false
    
    @State private var showOverdue = false
    
    @State private var showToday = false
    
    @State private var showAll = true
    
    @State private var searchQuery: String = ""
    @State private var deleteTicked = false
    @State private var categorySelected = false
    @State private var cat = Category()
    
    @State private var inlineEdit = false
    @State private var inlineItem = UUID()
    @FocusState private var isFocused: Bool
    @State private var inlineTodo = ""
    @State private var editInProgress = 0
    
    @State private var accentColor = Color.tix
    
    private var todaysItems: [Todo] {
        today.filter {
            Calendar.current.isDate($0.dueDate ?? Date(), equalTo: Date(), toGranularity: .day)
        }
    }
    
    var body: some View {
        NavigationView {
            HStack {
                if selectCategory {
                    List {
                        ForEach(categories, id: \.self) { catItem in
                            
                            VStack(alignment: .leading){
                                HStack(alignment: .center){
                                    Image(systemName: "square.fill")
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .onTapGesture {
                                            withAnimation {
                                                cat = catItem
                                                categorySelected = true
                                                selectCategory.toggle()
                                            }
                                        }
                                        .foregroundColor(catItem.color?.color ?? Color.tix)
                                        .padding(.trailing, 10)
                                        .padding(.bottom, 10)
                                        .padding(.top, 10)
                                    
                                    Text(catItem.name ?? "\(loc_category)")
                                        .font(.callout)
                                        .foregroundColor(catItem.color?.color ?? Color.tix)
                                    Spacer()
                                }.onTapGesture {
                                    withAnimation {
                                        cat = catItem
                                        categorySelected = true
                                        selectCategory.toggle()
                                    }
                                }
                            }
                        }
                    }.listRowBackground(Color.clear)
                }
                
                if showAll {
                    ForEach(todos, id: \.self) { todo in
                    VStack(alignment: .leading){
                        HStack(alignment: .center){
                            Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .onTapGesture {
                                    withAnimation {
                                        ViewContextMethods.isDone(todo: todo, context: viewContext)
                                    }
                                }
                                .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                .padding(.trailing, 10)
                                .padding(.bottom, 10)
                                .padding(.top, 10)
                            VStack(alignment: .leading){
                                HStack(alignment: .top) {
                                    if inlineEdit && todo.id == inlineItem {
                                        TextField(loc_todo, text: $inlineTodo)
                                            .focused($isFocused)
                                            .font(.headline)
                                            .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                            .onDisappear(perform: {
                                                isFocused = false
                                                accentColor = Color.tix
                                                accentColor = todo.todoCategory?.color?.color ?? Color.tix
                                                //ViewContextMethods.saveItem(todo: todo, toDoText: inlineTodo, context: viewContext)
                                            })
                                        Spacer()
                                        Button(action: {
                                            withAnimation {
                                                inlineEdit = false
                                                inlineItem = UUID()
                                            }
                                        }) {
                                            Text(loc_save)
                                                .font(.headline)
                                                .foregroundColor(categorySelected ? cat.color?.color : .tix.opacity(showAll ? 0.5 : 1))
                                        }
                                    } else {
                                        Text(todo.todo ?? "\(loc_todo)")
                                            .onTapGesture {
                                                if !inlineEdit {
                                                    inlineEdit = true
                                                    inlineItem = todo.id ?? UUID()
                                                    isFocused = true
                                                    inlineTodo = todo.todo ?? ""
                                                    accentColor = todo.todoCategory?.color?.color ?? Color.tix
                                                }
                                            }
                                            .font(.headline)
                                            .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                        Spacer()
                                        Image(systemName: todo.important ? "exclamationmark.circle" : "")
                                            .foregroundColor(Color.red.opacity(todo.isDone ? 0.5 : 1))
                                    }
                                    
                                }
                                HStack(alignment: .bottom) {
                                    Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                                        .font(.subheadline)
                                        .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                    Spacer()
                                   
                                }
                            }
                            
                            
                        }
                        
                    }
                }
                } else {
                List {
                   /* if showAll {
                        ForEach(todos, id: \.self) { todo in
                            NavigationLink(destination: EditItem(todo: todo, cat: todo.todoCategory ?? Category()).environment(\.managedObjectContext, self.viewContext))
                            {
                                VStack(alignment: .leading){
                                    
                                    HStack(alignment: .center){
                                        Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .onTapGesture {
                                                withAnimation {
                                                    ViewContextMethods.isDone(todo: todo, context: viewContext)
                                                }
                                            }
                                            .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                            .padding(.trailing, 10)
                                            .padding(.bottom, 10)
                                            .padding(.top, 10)
                                        VStack(alignment: .leading){
                                            HStack(alignment: .top) {
                                                if inlineEdit && todo.id == inlineItem {
                                                    TextField(loc_todo, text: $inlineTodo)
                                                        .focused($isFocused)
                                                        .font(.headline)
                                                        .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                        .onDisappear(perform: {
                                                            isFocused = false
                                                            accentColor = Color.tix
                                                            accentColor = todo.todoCategory?.color?.color ?? Color.tix
                                                            ViewContextMethods.saveItem(todo: todo, toDoText: inlineTodo, context: viewContext)
                                                        })
                                                    Spacer()
                                                    Button(action: {
                                                        withAnimation {
                                                            inlineEdit = false
                                                            inlineItem = UUID()
                                                        }
                                                    }) {
                                                        Text(loc_save)
                                                            .font(.headline)
                                                            .foregroundColor(categorySelected ? cat.color?.color : .tix.opacity(showAll ? 0.5 : 1))
                                                    }
                                                } else {
                                                    Text(todo.todo ?? "\(loc_todo)")
                                                        .onTapGesture {
                                                            if !inlineEdit {
                                                                inlineEdit = true
                                                                inlineItem = todo.id ?? UUID()
                                                                isFocused = true
                                                                inlineTodo = todo.todo ?? ""
                                                                accentColor = todo.todoCategory?.color?.color ?? Color.tix
                                                            }
                                                        }
                                                        .font(.headline)
                                                        .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                    Spacer()
                                                    Image(systemName: todo.important ? "exclamationmark.circle" : "")
                                                        .foregroundColor(Color.red.opacity(todo.isDone ? 0.5 : 1))
                                                }
                                                
                                            }
                                            HStack(alignment: .bottom) {
                                                Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                                                    .font(.subheadline)
                                                    .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                Spacer()
                                               
                                            }
                                        }
                                        
                                        
                                    }
                                    
                                }.frame(maxWidth: .infinity)
                                
                            }
                        }.onDelete(perform: deleteToday(offsets:))
                         .listStyle(PlainListStyle())
                    }
                    else  { */
                        if showToday {
                            ForEach(todayResults, id: \.self) { todo in
                                NavigationLink(destination: EditItem(todo: todo, cat: todo.todoCategory ?? Category()).environment(\.managedObjectContext, self.viewContext))
                                {
                                    VStack(alignment: .leading){
                                        
                                        HStack(alignment: .center){
                                            
                                            Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .onTapGesture {
                                                    withAnimation {
                                                        ViewContextMethods.isDone(todo: todo, context: viewContext)
                                                    }
                                                }
                                                .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                .padding(.trailing, 10)
                                                .padding(.bottom, 10)
                                                .padding(.top, 10)
                                            VStack(alignment: .leading){
                                                HStack {
                                                Text(todo.todo ?? "\(loc_todo)")
                                                    .font(.headline)
                                                    .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                    Spacer()
                                                    Image(systemName: todo.important ? "exclamationmark.circle" : "")
                                                        .foregroundColor(Color.red.opacity(todo.isDone ? 0.5 : 1))
                                                }
                                                HStack {
                                                Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                                                    .font(.subheadline)
                                                    .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                    Spacer()
                                                    /*Text(todo.todoCategory?.name ?? "")
                                                        .font(.subheadline)
                                                        .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))*/
                                                }
                                            }
                                            
                                            
                                        }
                                        
                                    }.frame(maxWidth: .infinity)
                                    
                                }
                            }.onDelete(perform: deleteToday(offsets:))
                             .listStyle(PlainListStyle())
                            } else {
                            
                            
                            ForEach(overdueResults, id: \.self) { todo in
                                
                                
                                NavigationLink(destination: EditItem(todo: todo, cat: todo.todoCategory ?? Category()).environment(\.managedObjectContext, self.viewContext))
                                {
                                    VStack(alignment: .leading){
                                        
                                        HStack(alignment: .center){
                                            
                                            Image(systemName: todo.isDone ? "circle.fill" : "circle")
                                                .resizable()
                                                .frame(width: 30, height: 30)
                                                .onTapGesture {
                                                    withAnimation {
                                                        ViewContextMethods.isDone(todo: todo, context: viewContext)
                                                    }
                                                }
                                                .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                .padding(.trailing, 10)
                                                .padding(.bottom, 10)
                                                .padding(.top, 10)
                                            VStack(alignment: .leading){
                                                HStack {
                                                Text(todo.todo ?? "\(loc_todo)")
                                                    .font(.headline)
                                                    .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                Spacer()
                                                    Image(systemName: todo.important ? "exclamationmark.circle" : "")
                                                        .foregroundColor(.red.opacity(todo.isDone ? 0.5 : 1))
                                                }
                                                HStack {
                                                Text(todo.hasDueDate ? "\(todo.dueDate!, formatter: itemFormatter)" : "")
                                                    .font(.subheadline)
                                                    .foregroundColor(todo.todoCategory?.color?.color.opacity(todo.isDone ? 0.5 : 1) ?? Color.tix.opacity(todo.isDone ? 0.5 : 1))
                                                    Spacer()
                                                }
                                                
                                            }
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                }
                            }.onDelete(perform: deleteOverdue(offsets:))
                            .listStyle(PlainListStyle())
                        }
                    }
                }//.listRowBackground(Color.clear)
            }.background(Color.tix.opacity(0.5))
                .navigationBarTitle(selectCategory ? loc_categories : showOverdue ? loc_overdue : showAll ? loc_all_todos : loc_today, displayMode: .automatic).allowsTightening(true)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        
                        if selectCategory && categorySelected {
                            Button(action: {
                                withAnimation {
                                    categorySelected = false
                                    selectCategory.toggle()
                                }
                            }) {
                                Text(loc_all)
                                    .foregroundColor(.tix)
                            }
                            .toggleStyle(.button)
    
                        } else {
                            Button(action: {
                                withAnimation {
                                    selectCategory.toggle()
                                }
                            }) {
                                Image(systemName: categorySelected ? "folder.fill" : "folder")
                                    .resizable()
                                    .foregroundColor(categorySelected ? cat.color?.color : .tix.opacity(showAll ? 0.5 : 1))
                            }
                            .toggleStyle(.button)
                            .disabled(showAll)
                        }
                        Button(action: {
                            withAnimation {
                                showImportant.toggle()
                                
                            }
                        }) {
                            Image(systemName: showImportant ? "exclamationmark.circle.fill" : "exclamationmark.circle")
                                .resizable()
                                .foregroundColor(showImportant ? .red : .tix.opacity(showAll ? 0.5 : 1))
                        }
                        .toggleStyle(.button)
                        .disabled(showAll)
                        
                        Button(action: {
                            withAnimation {
                                showAll = false
                                showOverdue = false
                                showToday = true
                            }
                        }) {
                            Image(systemName: "calendar")
                                .resizable()
                                .foregroundColor(showToday ? .tixDark : .tix)
                        }
                        .toggleStyle(.button)
                        
                        Button(action: {
                            withAnimation {
                                showAll = false
                                showOverdue = true
                                showToday = false
                            }
                        }) {
                            Image(systemName: showOverdue ? "calendar.badge.exclamationmark" : "calendar.badge.exclamationmark")
                                .resizable()
                                .foregroundColor(showOverdue ? .tixDark : .tix)
                        }
                        .toggleStyle(.button)
                        
                        Button(action: {
                            withAnimation {
                                showAll = true
                                showOverdue = false
                                showToday = false
                                categorySelected = false
                                showImportant = false
                                selectCategory = false
                            }
                        }) {
                            Image(systemName: "list.bullet")
                                .resizable()
                                .foregroundColor(showAll ? .tixDark : .tix)
                        }
                        .toggleStyle(.button)
                        
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        
                        Button(action: {
                            withAnimation {
                                newItem.toggle()
                            }
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .foregroundColor(.tix)
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        
                    }
                }
                .sheet(isPresented: $newItem) { NewItem(cat: self.cat, col: self.cat.color?.color ?? Color.tix) }
                .onAppear(perform: onAppear)
                .navigationViewStyle(StackNavigationViewStyle())
                .accentColor(accentColor) // NAV
                .background(Color.clear)
                .listRowBackground(Color.clear)
                .onAppear(){
                    UITableView.appearance().backgroundColor = .clear
                }
                
        }
    }
    
    
    private func onAppear() {
        
        getInbox()
        
        let setRequest = NSFetchRequest<Todo>(entityName: "Todo")
        //let setPredicate = NSPredicate(format: "isDone == true")
        let setSortDescriptor1 = NSSortDescriptor(keyPath: \Todo.todo, ascending: true)
        setRequest.fetchLimit = 3
        //setRequest.predicate = setPredicate
        setRequest.sortDescriptors = [setSortDescriptor1]
        var cnt = 0
        var one = ""
        var two = ""
        var three = ""
        
        do {
            let sets = try self.viewContext.fetch(setRequest) as [Todo]
            
            for td in sets {
                cnt+=1
                
                if cnt == 1 {
                    one = td.todo ?? ""
                    
                }
                if cnt == 2 {
                    two = td.todo ?? ""
                }
                if cnt == 3 {
                    three = td.todo ?? ""
                }
                
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get top 3 todos: \(error.localizedDescription)")
        }
        
        WidgetUpdater(one: one, two: two, three: three, oneTicked: false, twoTicked: true, threeTicked: false, open: today.count).updateValues()
    }
    
    private func deleteToday(offsets: IndexSet) {
        withAnimation {
            offsets.map { today[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteOverdue(offsets: IndexSet) {
        withAnimation {
            offsets.map { overdue[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func textChanged(upper: Int, text: inout String) {
        if text.count > upper {
            text = String(text.prefix(upper))
        }
    }
    
    var allResults: [Todo] {
        if categorySelected {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat && $0.important == true
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat && $0.important == true
                    }
                }
            } else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat
                    }
                }
            }
        } else {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.important == true
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.important == true
                    }
                }
            }
            else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty
                    }
                }
            }
        }
    }
    
    var todayResults: [Todo] {
        if categorySelected {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat && $0.important == true
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat && $0.important == true
                    }
                }
            } else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat
                    }
                }
            }
        } else {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.important == true
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.important == true
                    }
                }
            }
            else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return today.filter {
                        !$0.todo!.isEmpty && $0.isDone == false
                    }
                default:
                    return today.filter {
                        !$0.todo!.isEmpty
                    }
                }
            }
        }
    }
    
    var overdueResults: [Todo] {
        if categorySelected {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat && $0.important == true
                    }
                default:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat && $0.important == true
                    }
                }
            } else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.todoCategory == cat
                    }
                default:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.todoCategory == cat
                    }
                }
            }
        } else {
            if showImportant {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.isDone == false && $0.important == true
                    }
                default:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.important == true
                    }
                }
            }
            else {
                switch settings.hideTicked { //we will need this for our toggle later
                case true:
                    return overdue.filter {
                        !$0.todo!.isEmpty && $0.isDone == false
                    }
                default:
                    return overdue.filter {
                        !$0.todo!.isEmpty
                    }
                }
            }
        }
    }
    
    func getInbox() {
        
        let setRequest = NSFetchRequest<Category>(entityName: "Category")
        let setPredicate = NSPredicate(format: "isDefault == true")
        //let setSortDescriptor1 = NSSortDescriptor(keyPath: \Todo.todo, ascending: true)
        setRequest.predicate = setPredicate
        setRequest.fetchLimit = 1
        //setRequest.sortDescriptors = [setSortDescriptor1]
        do {
            let cats = try self.viewContext.fetch(setRequest) as [Category]
            
            for cat in cats {
                self.cat = cat
            }
        } catch let error {
            NSLog("error in FetchRequest trying to get default category: \(error.localizedDescription)")
        }
        
    }
    

    
}
private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    //formatter.timeStyle = .short
    return formatter
}()


