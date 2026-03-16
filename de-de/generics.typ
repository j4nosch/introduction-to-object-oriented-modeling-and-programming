#import "../common/callouts.typ": example

= Generics

Generics erlauben es, Datentypen als Parameter zu übergeben. Dies ermöglicht es, Klassen, Interfaces oder Methoden für verschiedene Datentypen zu verwenden.

- Generics kommen nach dem Modifikator, aber vor dem Return Type
- Generics können mit extends und super eingeschränkt werden
- Generics erlauben das Nutzen von Wildcards (?)
- Es können beliebig viele Datentypen definiert werden

```java
// Methode mit 2 Generic Types, wobe A von B abhängt
static <B, A extends B> A upcast(B b) {
  return (A) b;
}

// Generics können Typen verwenden, bevor diese definiert wurden
static <A extends B, B> A upcast(B b) {
  return (A) b;
}

static <T> void consumeAll(Consumer<? super T> consumer, Collection<? extends T> collection) {
  for (T element : collection) consumer.accept(element);
}

// Genercs können wiederum in den Generics von Interfaces und co. weiterverwendet werden
static <T> T op(T left, BinaryOperator<T> op, T right) {
  return op.apply(left, right);
}
```

```java
Object b = "abc";
String a = cast(b);

System.out.println(a);

consumeAll(System.out::println, List.of("a", "b", "c"))

System.out.println(op("abc", (l, r) -> l + r, "def"));
```

#example("Incompatible Types")[
  Was passiert, wenn es keine Typen gibt, welche die Einschränkungen der Generics erfüllt? Das folgende Beispiel hat die Funktion `downcast`, welche eine Instanz in einen niedrigeren Typen umwandelt.

  ```java
  static <A, B extends A> A downcast(B b) {
    return (A) b;
  }
  ```

  Der folgende Aufruf ist legitim:

  ```java
  Object a = downcast("abc");
  ```

  Wenn jedoch versucht wird, die Funktion auf ein Object anzuwenden, um es zu einem String umzuwandeln, entsteht ein Fehler:

  ```java
  Object b = "asfd";
  String a = downcast(b);
  ```

  Dies liegt daran, dass Object nicht aus String erbt, und somit nicht die Bedingung erfüllen kann. Die folgende Fehlermeldung wird zur Compilezeit ausgegeben:

  ```log
  error: incompatible types: inference variable A has incompatible bounds
        String a = downcast(b);
                           ^
    upper bounds: String,Object
    lower bounds: B,Object
  where A,B are type-variables:
    A extends Object declared in method <A,B>downcast(B)
    B extends A declared in method <A,B>downcast(B)
  ```
]

