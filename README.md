# Example Usage
    λ trainRM rps 10000
runs 10 000 iterations of Regret Matching on Rock Paper Scissors. It might yield...
    ( [(Rock,0.33626209150224534),(Paper,0.3349704454088444),(Scissors,0.3287674630889102)]
	, [(Rock,0.32547598334254607),(Paper,0.32914888670129655),(Scissors,0.3453751299561573)]
	)
... or not - it's random after all.
# Questions
## Why not always choose the strategy with maximum regret?
This seems simpler to me than randomly choosing between strategies with positive regret. Is there a problem with the approach?
**What I tried:** I implemented this flavour of self-play (`trainMaxregret` in `MaxRegretSelfplay.hs`), a function that runs it on RPS and returns the largest deviation from optimal play (`evalMaxRegretWithRPS`), and a function that does the same for Regret Matching (`evalRegretMatchingWithRPS`). Here are the largest errors for different numbers of iterations:

n of iterations | Regret Matching | Max Regret Self Play
----------------|-----------------|---------------------
100 | 4.8e-2 | 6.7e-2
1000 | 3.8e-2 | 1.3e-2
10000 | 1.2e-2 | 6.7e-3
100000 | 1.9e-3 | 1.6e-3

Not a blowout for either algorithm.

There might be games for which Max Regret Self Play does not converge to a Nash equilibrium but Regret Matching does. If you know of such a game, please tell me!
