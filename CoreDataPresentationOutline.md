# Core Data Presentation

Core Data Presentation Outline

1. What Is Core Data?
   - From Apple: "...provides generalized and automated soltions to common tasks associated with object life-cycle
   and object graph managment, including persistence"
   - Some Features
	   - Undo/Redo support for your objects
	   - Automatically maintains relationships between objects
	   - Faulting i.e. Lazy loading
	   - Schema migration
	   - Full KVO Support
   - Different persistent types (binary, xml, sqllite, in-memory ability to make custom) 
	- ios does not allow the xml store type
   - It's not a database, not a good option if you need to do databasey type of things (update large datasets for example)
   
2. Main Parts of Core Data
   - Managed Object Model
	 - Defines your object graph, entities, their properties, and relationships to other entities, i.e. a Schema
	 - Entities are NSManagedObjects and it's subclasses
  - Managed Object Context
	- In-memory work space for your managed objects (think "scratchpad")
	- You can have more than one and edits to managed objects can be performed independently
	- Contexts can be nested (parent->child relationships)
   - Persistent Store Coordinator
	 - Sits between managed object contexts and persistent stores
	 - A single NSPersistentStoreCoordinator can cooridnate with multiple stores and contexts
	 - Can only support one managed object model
   - Persistent Store (NSPersistentStore)
	 - Abstract class which handles the reads and writes to the physical store
	 - You can't directly sublass NSPersistentStore, but you can subclas NSAtomicStore and NSIncrementalStore
	 - You won't normally care too much about the details of this class, unless your a wizard.

3. Setting up Core Data In Your Project
   - Include the correct frameworks (CoreData)
   - Creating a data model using the data model editor in Xcode
	 - Importance of setting an inverse (how this differs from a relational database)
	 - Go over entities and various UI model editor stuff
	 - Transient properties
	 - Index
	 - Relationship properties
	   - 1-1
	   - to-many
	   - deletion rules
   - Loading the MOM
   - Setting up the PSC
   - Creating a MOC

4. Modifying Will's tableview demo to use core data
   - Subclassing NSManagedObject subclasses
	 - you don't have to subclass, you can use NSManagedObject like a dictionary
	 - the hard way
	 - using mogenerator 
   - use child MOC for edit controllers
   - deleting entities
   - saving entities   
   - fetching
	 - building fetch requests in code
	 - creating them in the data model editor
	 
5. Core Data and Multi-Threading
  - Containment types and NSManangedObjectContext
  - Pre IOS 5 Method:  NSConfinementConcurrencyType
	- MOC / thread
	- merge notification for save and deletes
  - MainQueue & Private Queue concurrency
	- performBlock: & performBlockAndWait:
	
6. Questions & Troll Stomping


	
