# markovkeyboard
keyboard layout that changes by markov frequency

# the big idea
Static keyboard layouts are boring and predictable. Let's spice up the whole idea of keyboard layouts by having the layout *CHANGE WHILE YOU ARE TYPING*!

The layout will update itself to move the keys that most frequently come next to the home row. 
For example, if you type only "the" all day, then when you press the letter 't' the letter 'h' will be on the home row.

# how do I type?
There are minor challenges involved if your keyboard layout could change with every keypress, thus this prototype is an emacs library that display the current layout at the bottom of the screen.
