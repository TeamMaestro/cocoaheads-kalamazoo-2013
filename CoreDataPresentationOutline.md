# Core Data Presentation

Core Data Presentation Outline

1. What Is Core Data?
   - Persistent Object Graph (whatever the proper apple term is here)
   - Different persistent types (binary, xml, sqllite, ability to make custom)
   - It's not a database
   
2. Main Parts of Core Data
   - Data model
   - Managed Object Model
   - Persistent Store Coordinator
   - Managed Object Context
   
3. Setting up Core Data In Your Project
   - Include the correct frameworks (CoreData)
   - Creating a data model using the data model editor in Xcode
	 - Go over entities and various UI model editor stuff
   - Loading the MOM
   - Setting up the PSC
   - Creating a MOC

4. Modifying Will's tableview demo to use core data
   - Subclassing NSManagedObject subclasses
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
 

	
