# Modern C# Language Features (2018–2025) — Reference With Explanations

A summary of significant C# language features from versions 8 and later, post-2018. Each includes a brief explanation and a code example for clarity.

---

## C# 8.0 (2019, .NET Core 3.0+ & .NET Standard 2.1+)

### Nullable Reference Types
**Explanation:**  
Before C# 8, all reference types could be `null`, but the compiler didn't help you keep track of what could or couldn't be null. With nullable reference types, you can explicitly indicate when a reference may be `null` (`T?`) and the compiler will give you warnings if you ignore potential `null`s.

```csharp
#nullable enable
string? name = null; // Nullable reference type - allowed
string notNullName = "Alice";
// notNullName = null; // Warning: null assigned to non-nullable
```
This applies to **any reference type**, including your own (`Customer?`, `Employee?`).

---

### Async Streams
**Explanation:**  
Instead of returning `IEnumerable<T>` for synchronous streams, you can now return `IAsyncEnumerable<T>` and use `await foreach` to asynchronously iterate over results, which is ideal for streaming data or I/O operations.

```csharp
public async IAsyncEnumerable<int> GetNumbersAsync() {
    for (int i = 0; i < 3; i++) {
        await Task.Delay(100);
        yield return i;
    }
}

await foreach (var n in GetNumbersAsync()) {
    Console.WriteLine(n); // Prints 0, 1, 2 with delay
}
```

---

### Ranges and Indices
**Explanation:**  
New operators make it concise and readable to work with slices of arrays, spans, or strings. The `..` operator defines a range, and `^` counts from the end.

```csharp
int[] values = { 1, 2, 3, 4, 5 };
var sub = values[1..^1]; // Elements 1 up to last (not including): [2, 3, 4]
```

---

### Default Interface Methods
**Explanation:**  
Interfaces can now provide default implementations for members, reducing the need for "base" implementation classes.

```csharp
public interface ILogger {
    void Log(string msg) => Console.WriteLine(msg); // Default implementation
}
```

---

### Switch Expressions
**Explanation:**  
A new, concise way to write switch statements as expressions, making code more declarative and functional.

```csharp
string GetRole(int level) => level switch {
    1 => "User",
    2 => "Admin",
    _ => "Guest"
};
```

---

## C# 9.0 (2020, .NET 5+)

### Records
**Explanation:**  
Records are reference types intended for immutable data models, value-based equality, and succinct syntax for data classes.

```csharp
public record Person(string Name, int Age);

var p1 = new Person("Alice", 30);
var p2 = new Person("Alice", 30);

bool same = p1 == p2; // true: value-based equality
```

---

### Init-only Setters
**Explanation:**  
Properties can now be set only at object initialization, not modified later, supporting immutable patterns.

```csharp
public class User {
    public string Username { get; init; }
}

var u = new User { Username = "demo" }; // Allowed
// u.Username = "other"; // Error: init-only property
```

---

### With-expressions
**Explanation:**  
Easily create a shallow copy of an object with some properties changed, especially with records.

```csharp
var person1 = new Person("Alice", 30);
var person2 = person1 with { Name = "Bob" }; // still Age=30
```

---

### Top-level Programs
**Explanation:**  
C# can now infer the "entry point" for small apps, so you can omit the `Program` class and `Main` method for concise code.

```csharp
// Program.cs
Console.WriteLine("Hello World!"); // No boilerplate needed
```

---

### Pattern Matching Enhancements
**Explanation:**  
Pattern matching is extended for more expressive code—support for `and`, `or`, `not`, comparison patterns, type checks, and more.

```csharp
if (obj is string s && s.Length > 5) { /* string, length > 5 */ }
if (n is > 0 and < 100) { /* n between 1 and 99 */ }
```

---

### Target-typed new Expressions
**Explanation:**  
You can omit the type on the right-hand side of a new expression when it's clear from context.

```csharp
Person p = new("Alice", 30); // Clear, no need to repeat 'Person'
```

---

## C# 10.0 (2021, .NET 6+)

### Global Using Directives
**Explanation:**  
Global usings can be defined in one place (e.g., `Usings.cs`), making them available everywhere and reducing repetitive code.

```csharp
// Usings.cs
global using System.Text;
// Now available in every source file in the project
```

---

### File-scoped Namespaces
**Explanation:**  
Single-line namespace declarations eliminate an extra level of indentation for cleaner file structure.

```csharp
namespace MyApp;

// Applies to all code in this file. No braces needed.
```

---

### Record Structs
**Explanation:**  
You can now use the record syntax for value types, supporting immutability and value-based equality conveniently.

```csharp
public readonly record struct Point(int X, int Y);
```

---

### Improved Lambda Support
**Explanation:**  
Lambdas gain parity with methods; can have natural types, attributes, and more concise syntax.

```csharp
Func<int, int> square = (int x) => x * x;
```

---

### Constant Interpolated Strings
**Explanation:**  
Interpolated strings can now be declared as `const` if all placeholders are constants.

```csharp
const string greeting = $"Hello, {nameof(User)}!";
```

---

### Extended Property Patterns
**Explanation:**  
Pattern matching for nested properties, making object checks concise.

```csharp
if (order is { Customer.Address.City: "NY" }) { /* matches NY customers */ }
```

---

## C# 11.0 (2022, .NET 7+)

### Raw String Literals
**Explanation:**  
Triple quotes allow easily writing multi-line, unescaped string literals, perfect for things like JSON, XML, or SQL.

```csharp
string json = """
{
    "name": "Alice",
    "age": 30
}
""";
```

---

### List Patterns
**Explanation:**  
You can match arrays or lists using patterns, like destructuring or checking sequence structure.

```csharp
int[] arr = { 1, 2, 3, 4 };
if (arr is [1, 2, ..]) { /* Array starts with 1, 2 */ }
```

---

### Required Members
**Explanation:**  
Declare properties or fields as `required` to force callers to initialize them to avoid inadvertent nulls/missing data.

```csharp
public class Person {
    public required string Name { get; init; }
}

var p = new Person { Name = "Alice" }; // OK
// var p2 = new Person(); // Error: Name is required
```

---

### UTF-8 String Literals
**Explanation:**  
The `u8` suffix creates a read-only span of UTF-8 bytes from a string literal, enabling efficient interop and no allocations.

```csharp
ReadOnlySpan<byte> data = "hello"u8;
```

---

### Generic Math Support
**Explanation:**  
Constrained generics for numeric operations; now you can write generic code that does math (e.g., matrices, statistics).

```csharp
public T Add<T>(T a, T b) where T : INumber<T> => a + b;
```

---

## C# 12.0 (2023, .NET 8+)

### Primary Constructors for Classes & Structs
**Explanation:**  
Classes and structs can have constructors directly in the type declaration line, similar to records. Reduces boilerplate.

```csharp
public class Book(string title, int year) {
    public string Title => title;
    public int Year => year;
}
var b = new Book("C# in Depth", 2024);
```

---

### Collection Expressions
**Explanation:**  
New square-bracket syntax for creating/initializing collections, inspired by Python and JavaScript.

```csharp
int[] numbers = [1, 2, 3];
List<string> letters = ["a", "b", "c"];
```

---

### Default Lambda Parameters
**Explanation:**  
Lambdas/functions can declare optional parameters with default values, like methods.

```csharp
Func<int, int, int> add = (a, b = 10) => a + b;
var result = add(5); // b=10 used by default
```

---

### Ref Readonly Parameters
**Explanation:**  
You can pass arguments by readonly reference, protecting against mutation and improving performance for large structs.

```csharp
void PrintLength(ref readonly string s)
    => Console.WriteLine(s.Length);
```

---

### Alias Any Type
**Explanation:**  
You can now create a using-alias for any type, including tuples or generics, for more readable code.

```csharp
using NumberTuple = (int X, int Y);
NumberTuple point = (5, 10);
```

---

## C# 13.0 (Preview/future, .NET 9+)

> C# 13 is under development; future examples may evolve.

### Params Span Parameters
**Explanation:**  
Allow varargs of spans to support high-performance methods dealing with memory blocks.

```csharp
void PrintNumbers(params Span<int> numbers)
{ foreach(var n in numbers) Console.WriteLine(n); }
```

---

### Field Keyword for Auto-Property Backing
**Explanation:**  
Provides a way to explicitly reference an auto-property's backing field in property accessors, enabling more advanced usages.

```csharp
private int _x;
public int X {
    get => field;    // 'field' refers to the backing field
    set => field = value;
}
```

---

### Pattern Matching Enhancements
**Explanation:**  
Ongoing expansion to make pattern matching more expressive, especially for lists, dictionaries, and nested structures.

```csharp
// Pattern examples may expand in syntax in future releases!
```

---

## **Other Notables**

### Source Generators (C# 9+)
**Explanation:**  
Enables generation of source code at compile time, often used for performance or automating repetitive patterns (e.g., auto-mapping, serialization).

---

### Interpolated String Handlers (C# 10+)
**Explanation:**  
Allows more control over how interpolated strings are processed for performance, especially useful for logging APIs.

---

### Performance-focused types
**Explanation:**  
Types like `Span<T>` and stackalloc allow efficient, allocation-free manipulation of memory.

```csharp
Span<byte> buffer = stackalloc byte[256];
```

---

## **Resources & References**

- [What's new in C#](https://learn.microsoft.com/en-us/dotnet/csharp/whats-new/)
- [C# Language Version History](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/proposals/csharp/)
- [C# Feature Status](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/configure-language-version)

---

*For more explanations or real-world usage examples, consult Microsoft Docs or request an example here!*