;; markovkeyboard.el -- change your layout as you type to move most used keys to the home row!

;; Author: Shae Erisson <shae+markeyb@ScannedInAvian.com>
;; Author: Darius Bacon


;; this is how you define an input-method
(require 'quail)
(quail-define-package
 "markov-insanity" "Latin-1" "SV<" t
 "Markov (Insanity) input method (rule: make your own)

Good luck, you'll need it.
" nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
 ("a" ?a)
 ("b" ?b)
 ("c" ?c)
 ("d" ?d)
 ("e" ?e)
 ("f" ?f)
 ("g" ?g)
 ("h" ?h)
 ("i" ?i)
 ("j" ?j)
 ("k" ?k)
 ("l" ?l)
 ("m" ?m)
 ("n" ?n)
 ("o" ?o)
 ("p" ?p)
 ("q" ?q)
 ("r" ?s)
 ("t" ?t)
 ("u" ?u)
 ("v" ?v)
 ("w" ?w)
 ("x" ?x)
 ("y" ?y)
 ("z" ?z)

 ("A" ?A)
 ("B" ?B)
 ("C" ?C)
 ("D" ?D)
 ("E" ?E)
 ("F" ?F)
 ("G" ?G)
 ("H" ?H)
 ("I" ?I)
 ("J" ?J)
 ("K" ?K)
 ("L" ?L)
 ("M" ?M)
 ("N" ?N)
 ("O" ?O)
 ("P" ?P)
 ("Q" ?Q)
 ("R" ?S)
 ("T" ?T)
 ("U" ?U)
 ("V" ?V)
 ("W" ?W)
 ("X" ?X)
 ("Y" ?Y)
 ("Z" ?Z)
 )

