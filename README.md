# THSwiftUtil

Some useful utility methods for Swift. Examples use this type:

```
struct Foo {
  let intVal: Int
  let stringVal: String
}

func getArray() -> [Foo] { ... }
```

### Group elements of a `Collection`

```
let dataArray: [Foo] = getArray()
let groups = dataArray.groupBy({$0.stringVal})
```

`groups` here is an array of `Group` objects. `Group` conforms to `Collection` and has a `key` property that is the value that all of its elements share. A classic use case for this, combined with the `sortedBy` method below, would be building an array of sections for a grouped table view or collection view, like in the Contacts app in iOS:

```
struct Contact {
  let firstName: String
  let lastName: String
}

let contacts: [Contact] = getContacts()
let sections = contacts.groupBy({$0.lastName.prefix(1)}).sortedBy({$0.key})
let sectionIndexTitles = sections.map({$0.key})
```

### Sorting elements of a `Sequence`

Swift already has the [`sorted(by:)`](https://developer.apple.com/documentation/swift/sequence/2907222-sorted) method - this makes it a little more convenient to use by letting you just convert elements to a `Comparable`:

```
let dataArray: [Foo] = getArray()
let asc = dataArray.sortedBy({$0.intVal})
let desc = dataArray.sortedBy({$0.intVal})
```

### Count elements of a `Collection` that satisfy a predicate

Pass a closure that converts elements to a `Bool`:
```
let myInts = [1, 2, 3, 5, 6, 9]
let evenCount = myInts.countWhere({$0 % 2 == 0})
```

### Sum elements of a `Sequence`

When the elements of the `Sequence` conform to `Numeric`:
```
let myInts = [1, 2, 3]
let sum = myInts.sum()
```

Or for any element type, pass a closure to convert to a `Numeric`:
```
let dataArray: [Foo] = getArray()
let sum = dataArray.sum({$0.intVal})
```

### Distinct values in a `Collection`

When the elements conform to `Hashable`, get the distinct values or count them:
```
let strs = ["Hello", "Hello", "World"]
let dist = strs.distinct()
let count = strs.countDistinct()
```

Or for any element type, pass a closure to convert to a `Hashable`. Returns the same type.
```
let dataArray: [Foo] = getArray()
let dist: [Foo] = dataArray.distinct({$0.stringVal})
let count = dataArray.countDistinct({$0.stringVal})
```

### Min and Max

Get the maximum or minimum value of a `Sequence` according to a closure used to convert to a `Comparable`:
```
let dataArray: [Foo] = getArray()
let min: Foo = dataArray.min({$0.intVal})
let max: Foo = dataArray.max({$0.intVal})
```
