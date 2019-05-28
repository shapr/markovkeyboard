;; markovkeyboard.el -- change your layout as you type to move most used keys to the home row!

;; Author: Shae Erisson <shae+markeyb@ScannedInAvian.com>
;; Author: Darius Bacon

(require 'dash)
;; keys from 'most accessible' to 'least accessible'
;; home keys from the pointer finger to pinky, then keys between,
;; then keys above in the same order
;; then keys below in the same order
(defvar key-accessibility "fjdkslaghrueiwoqptyvncmxzb") ; this is for qwerty
;; this somewhat arbitrary order is chosen so it's easy to map the frequency onto keyboard keys

(defvar keymap-default "fjdkslaghrueiwoqptyvncmxzb")
(defvar unigram-frequency '((32 1036511) (101 628234) (116 444459) (97 395872) (111 382683) (110 362397) (105 348464) (115 326238) (114 303977) (104 287323) (100 211677) (108 195904) (99 138853) (117 137114) (10 128457) (109 120829) (102 116374) (119 94576) (103 93732) (112 89967) (121 88196) (44 77675) (98 67206) (46 58672) (118 50525) (107 31160) (34 26108) (73 17174) (45 17127) (84 16282) (65 12217) (39 10018) (120 9196) (80 8946) (83 8659) (72 7358) (78 6621) (87 6255) (77 6234) (67 6119) (66 5962) (69 5584) (82 5578) (49 5572) (95 5488) (106 5114) (70 4501) (113 4422) (33 4345) (79 4184) (63 4155) (68 4029) (122 3651) (59 3511) (71 3184) (48 3064) (50 3053) (76 2744) (56 2527) (51 2492) (52 2417) (89 2285) (53 2192) (57 1999) (54 1993) (55 1890) (58 1855) (86 1853) (61 1764) (40 1748) (41 1748) (75 1638) (85 1618) (74 1322) (35 742) (88 614) (42 489) (91 435) (93 435) (124 408) (81 149) (90 145) (47 132) (36 110) (43 91) (9 12) (64 8) (38 8) (37 8) (62 3) (60 2) (94 2) (126 2)))
;; (defvar bigram-frequency ')


(defun char-in-string-p (ch str)
  (cl-search (string ch) str))
;; filter for only characters that we care about (specifically key-accessibility)
(loop for (key value) in unigram-frequency if (char-in-string-p key key-accessibility) collect (list key value))

(loop for standard-key across key-accessibility
      for (remapped-key frequency) in frequency-table
      collect (list (string standard-key) remapped-key))
;; (-filter (lambda (key value) (member key key-accessibility)))

((-filter (lambda (key value) (member key key-accessibility))) unigram-frequency)
;; Haskell -> filter (`elem` key-accessibility) unigram-frequency
;; this is how you define an input-method

(defun init-markov () (interactive)
  (require 'quail)
  (quail-define-package
   "markov-insanity" "Latin-1" "(╯°□°）╯" t
   "Markov (Insanity) input method (rule: make your own)

Good luck, you'll need it.
" nil t nil nil nil nil nil nil nil nil t)

  ;; default keymap is no change
  (quail-define-rules
   ("a" ?a)
   ("b" 'my-quail-function)
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
   ("q" ?q) ;; also 0 0 -> first list, first element
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
  )

(defun start-markov () (interactive)
  (set-input-method "markov-insanity"))

(defun remap (keymap)
  ;; is this it?
  (-zip-with 'quail-define-rules 'key-accessibility 'keymap)
  )
;; keymap is a dictionary from letter to new keymap

;; reading quail-define-rules several times, there's the option to pass a function
;; looks like you send in the list of this: ("a" . myfunction)
;; the docs imply that myfunction is then called with "a", after the
;; but is the TRANSLATION inserted into the buffer before handed to the function?
;; quail-lookup-key: Wrong number of arguments: (lambda nil ("a" "thisisaquailmap")), 2
(defun my-quail-function (a b)
  (
   (?a . "foo")
   (?b . "bar")
   ) ; valid quail map)
  )

(init-markov)

(quail-map-p '((?a "foo")))

(define-key buffer-map ?a
  (progn
    self-insert "a"
    (quail-define-rules (remap "a"))
    ))
(message (fboundp 'my-quail-function))
(message (null quail-current-package))
(local-set-key ?x (self-insert-command ?x))

(self-insert-command 1)

(local-set-key (kbd "a") '(self-insert-command 1))

'(progn
   (message "hi there")
   (self-insert-command 1))
