import assert from "assert";

let a: number = 1;

// this should generate a compilation error
let b: number = "a string";

console.log(a + b);

assert(a == b);
