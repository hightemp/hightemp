
### Расширение window, global

```typescript
/*
 * нужно, т.к. будет ошибка
 * Augmentations for the global scope can only be directly nested in external modules or ambient module declarations.ts(2669)
 */
export {};

interface ApiMethods {
  loadProjects: () => void;
}

declare global {
  interface Window {
    API: ApiMethods;
  }
}

```

### Множественное наследование 

#### Mixin

```typescript
// http://justinfagnani.com/2015/12/21/real-mixins-with-javascript-classes/
// https://github.com/Microsoft/TypeScript/wiki/What's-new-in-TypeScript#support-for-mix-in-classes

type Constructor<T> = new (...args: any[]) => T;

class S {
  foo() {
    console.log('foo from S');
  }
}

// Here the possible SuperClass is set to {} (Object)
function Mixin1<T extends Constructor<{}>>(SuperClass: T) {
  return class extends SuperClass {
    foo() {
      console.log('foo from Mixin1');
      if (super.foo) super.foo();
    }
  };
}

// Here the possible SuperClass (S) is specified
function Mixin2<T extends Constructor<S>>(SuperClass: T) {
  return class extends SuperClass {
    foo() {
      console.log('foo from Mixin2');
      super.foo();
    }
  };
}

class C extends Mixin1(Mixin2(S)) {
  foo() {
    console.log('foo from C');
    super.foo();
  }
}

new C().foo();
```

### Add custom typings file in a JavaScript VSCode project

#### ES6 import syntax solution for those who are using babel

Create next files (names should be the same):

lib.js 
lib.d.ts
Inside lib.js write some code, lets say this one:

```typescript
export const testMethod = (name, params) => params && params.age ? `hello ${name} with age: ${params.age}` : `hello ${name}`;
export const myConst = {
     name: 'test',
     age: 5
 };
```

Inside lib.d.ts write this:
```typescript
declare namespace MyModule {
    interface IParams { age: number; }

    function testMethod(name: string, params: IParams): string;

    const myConst: {
        name: string,
        age: number
    }
}
export = MyModule;
```

Then, create somewhere file to consume newly created function and put this code:

```js
import { testMethod } from "./lib/lib";

const name = 'drag13';
const r = testMethod(name, { age: 5 });
console.log(r);
```