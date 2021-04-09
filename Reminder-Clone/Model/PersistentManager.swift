//
// Created by JK on 2021/04/16.
//

import UIKit
import CoreData

class PersistentManager {
	static let shared = PersistentManager()

	private lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "Reminder_Clone")
		container.loadPersistentStores(completionHandler: { (_, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	private lazy var context: NSManagedObjectContext = persistentContainer.viewContext

	func newEntity(entity: NSManagedObject.Type) -> NSManagedObject {
		entity.init(context: context)
	}

	func fetch<T: NSManagedObject>(request: NSFetchRequest<T>) -> [T]? {
		do {
			let fetchResult = try context.fetch(request)
			return fetchResult
		} catch {
			print(error.localizedDescription)
			return nil
		}
	}

	func fetch<T: NSManagedObject>(objectID: NSManagedObjectID) -> T? {
		if let entity = context.object(with: objectID) as? T {
			return entity
		}
		return nil
	}

	func delete(_ object: NSManagedObject) -> Bool {
		context.delete(object)
		do {
			try context.save()
			return true
		} catch {
			return false
		}
	}

	func edit<T: NSManagedObject> (type entity: T.Type, filter: NSPredicate, _ completion: @escaping ([T]) -> Void) throws -> Bool {

		let request = entity.fetchRequest()
		request.predicate = filter
		if let fetchResult = try context.fetch(request) as? [T] {
			defer { saveContext() }
			completion(fetchResult)
			return true
		}
		return false
	}
	/*
	func edit(with objectID: NSManagedObjectID, _ completion: (NSManagedObject)-> Bool) {
		let entity = context.object(with: objectID)
		if completion(entity) {
			saveContext()
		}
	}
	*/

	func saveContext () {
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}
