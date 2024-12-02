# Advent of Code 2024

We'll see how many days I get through this year.

To use or check my work or your work you'll need racket. If you're using nix then an .envrc and flake.lock are provided to get the same version of racket I'm using. (Please let me know if this doesn't work for you since I'm still new to nix and nix-shell).

## Running the tests
The tests are currently embedded in the `code.rkt` file for each day (until I decide to spend the time changing them out). To run the tests for the day follow the steps below:
1. In your terminal enter the directory of the day you'd like to run (e.g. `day-01`)
2. Type `raco test code.rkt` to run the code and see the results, example below.

```
λ > raco test code.rkt 
raco test: "code.rkt"
9 tests passed
```

## Running from the repl
To run a particular day follow the steps below:
1. In your terminal enter the directory of the day you'd like to run (e.g. `day-01`)
2. Type `racket` to enter the repl.
3. At the prompt type `(require "code.rkt")` to load the code used for part one and two.
4. Type `(part1 "input.txt")` to run the code associated with part 1 against the `input.txt` file, which is my (personal) input data from Advent of Code. The final answer is sent to the terminal.

## Running the script
Until I take time to compile it, you can run both parts on an input file with a simple script:
1. In your terminal enter the directory of the day you'd like to run (e.g. `day-01`)
2. Type `./run-code` to default to the "input.txt" file for that day or add any other file for both parts of the day to run against, e.g. `./run-code short-example-list.txt`.

## Running the code for performance
Again, until I can compile it, you can obtain the raw, interpretted time of evaluation with the following:
1. In your terminal enter the directory of the day you'd like to run (e.g. `day-01`)
2. Type `racket` to enter the repl.
3. At the prompt type `(require "code.rkt")` to load the code used for part one and two.
4. Type `(time (part1 "input.txt"))` to run the code associated with part 1 against the `input.txt` file. The first line returns three values: (1) the number of milliseconds the CPU time required to obtain the result ("cpu time"), (2) the number of "real" milliseconds required for the result ("real time"), and the number of milliseconds of CPU time (included in the first result) spent on garbage collection ("gc time").
