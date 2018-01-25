# Example Usage
```haskell
trainRM rps 10000
```
runs 10 000 iterations of Regret Matching on Rock Paper Scissors. It might yield...
```haskell
( [(Rock,0.33626209150224534),(Paper,0.3349704454088444),(Scissors,0.3287674630889102)]
, [(Rock,0.32547598334254607),(Paper,0.32914888670129655),(Scissors,0.3453751299561573)]
)
```
... or not -- it's random after all.
# Questions
## Why not always choose the strategy with maximum regret?
That flavour of self-play seems too simple to me to not already have a name, but as I don't know how to google it, I will call it Max Regret Self Play here. It seems more obvious to me than randomly choosing between strategies with positive regret, so is there a problem with the approach?

**What I tried:** I implemented the algorithm (`trainMaxregret` in `MaxRegretSelfplay.hs`), a function that runs it on RPS and returns the largest deviation from optimal play (`evalMaxRegretWithRPS`), and a function that does the same for Regret Matching (`evalRegretMatchingWithRPS`). Here are the largest errors for different numbers of iterations:

n of iterations | Regret Matching | Max Regret Self Play
----------------|-----------------|---------------------
100 | 4.8e-2 | 6.7e-2
1000 | 3.8e-2 | 1.3e-2
10000 | 1.2e-2 | 6.7e-3
100000 | 1.9e-3 | 1.6e-3

Not a blowout for either algorithm.

Maybe the deciding factor is not performance, but convergence. If you know a game for which Regret Matching converges to Nash but Max Regret Self Play does not, please tell me!

# TODO
- [ ] Simplify the code, especially `iterateRM` and its helper functions
- [ ] Switch the implementation to mutable arrays
- [ ] Move on to the CFR part of the paper
