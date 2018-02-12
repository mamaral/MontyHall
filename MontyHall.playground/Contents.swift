import Foundation

// Define the three strategies we will be simulating.
enum Strategy {
    case AlwaysSwitch
    case NeverSwitch
    case Random
}

// Keep track of how many wins we get.
print("Initial win count:", terminator: "")
var wins = 0

// There are three choices, door #1, door #2, and door #3.
print("Number of choices:", terminator: "")
let choiceCount = 3

// Let's run through a thousand iterations for a decent sample-size.
print("Simulation iterations:", terminator: "")
let iterations = 1_000

// Function that returns a random door - #1, #2, or #3.
func randomDoor() -> Int {
    return Int(arc4random_uniform(UInt32(choiceCount))) + 1
}

// Function that returns the initial door that is opened, revealing the
// first of two goats. This door cannot be the winning door, and cannot
// be your initial selection.
func doorContainingGoatWithWinningDoor(winningDoor: Int, initialSelection: Int) -> Int {
    for door in 1 ... choiceCount {
        if door != winningDoor && door != initialSelection {
            return door
        }
    }

    assertionFailure()
    return -1
}

// Function that returns the door you will switch to, given your initial
// selection and the door you were shown has the goat behind it.
func switchInitialSelection(initialSelection: Int, doorContainingGoat: Int) -> Int {
    for door in 1 ... choiceCount {
        if door != initialSelection && door != doorContainingGoat {
            return door
        }
    }

    assertionFailure()
    return -1
}

// Function that runs the simulation with a given strategy.
func runMontyHallSimulationWithStrategy(strategy: Strategy) -> Double {
    print("Running simulation...", terminator: "")

    for _ in 1 ... iterations {
        // Randomly choose the door with the card behind it, select
        // our initial guess, and unveil the door containing one of
        // the two goats.
        let winningDoor = randomDoor()
        var selection = randomDoor()
        let doorContainingGoat = doorContainingGoatWithWinningDoor(winningDoor: winningDoor, initialSelection: selection);

        // If we always want to switch OR we want to randomly switch and the randomness
        // is fulfilled, switch our intial selection.
        if strategy == .AlwaysSwitch || (strategy == .Random && ((arc4random() % 2) == 0)) {
            selection = switchInitialSelection(initialSelection:selection, doorContainingGoat: doorContainingGoat)
        }

        // We win if our selection is the winning door.
        if selection == winningDoor {
            wins += 1
        }
    }

    // Return the normalized win percentage.
    return 100 * (Double(wins) / Double(iterations))
}

// Define our strategy - change this to see how the results differ!
print("Strategy:", terminator: "")
let strategy = Strategy.NeverSwitch

// Output the results.
print("Win percentage with given strategy: \(strategy)", terminator: "")
let winRate = String(runMontyHallSimulationWithStrategy(strategy: strategy)) + "%"
