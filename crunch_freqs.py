# -*- coding: utf-8 -*-

"""
Collect unigram and bigram statistics from a corpus of text.
Write out the data in an ELisp-friendly association-list format,
sorted by frequency descending.
"""


from collections import Counter

frequency = "fjdkslaghrueiwoqptyvncmxzb"

element_template = """ ("%s" ?%s)"""

# two parameters, letter 'a' and a string of pairs like this: ("a" ?a) ("A" ?A)
method_template = """
(quail-define-package
 "markov-insanity-%s" "Latin-1" "(╯°□°）╯" t
 "Markov (Insanity) input method (rule: make your own)

Good luck, you'll need it.
" nil t nil nil nil nil nil nil nil nil t)

(quail-define-rules
     %s
)
"""
# needs two binds "a" and "A" but there's only one markov-a input-method
bind_template = """
(local-set-key (kbd "%s") '(lambda () (interactive)
                            (set-input-method "markov-insanity-%s")
                            (self-insert-command 1)
                            )
               )
"""


def main(argv):
    real_filenames = argv[1:]
    real_main(real_filenames)

def real_main(real_filenames):
    trainer = Stats()
    for filename in real_filenames:
        print("filename is ", filename)
        with open(filename) as f:
            trainer.train(f.read().lower())
    trainer.filter_alpha()
    # with open('freqs', 'w') as f:
    #     trainer.dump(f)
    trainer.write_everything()
    return trainer



class Stats(object):
    def __init__(self):
        # self.unigrams counts unigrams we've trained on.
        # self.bigrams[c] counts bigrams-starting-with-c that we've trained on.
        # _prefixes holds all prefixes of all words we've trained on.
        self.unigrams = Counter()
        self.bigrams = {}
    def train(self, text):
        previous = '#'
        for c in text:
            self.unigrams.update(c)
            if previous not in self.bigrams:
                self.bigrams[previous] = Counter()
            self.bigrams[previous].update(c)
            previous = c
    def dump(self, f):
        f.write(format_bag(self.unigrams))
        f.write('\n')
        f.write(format_alist((elisp_char(ch), format_bag(counter))
                             for (ch, counter) in self.bigrams.items()))
    # remove anything that isn't a-z (for this prototype)
    # def get_unigram(self):
    #     for k in self.unigrams.keys():

    # return letters in order of total frequency
    def unis(self):
        return [x[0] for x in self.unigrams.most_common()]
    # return letters that come after char, in order of frequency
    def bigs(self, char):
        return [x[0] for x in self.bigrams[char].most_common()]

    def total_frequency(self,char):
        char_bigs = self.bigs(char)
        filtered_unis = [char for char in self.unis() if char not in char_bigs]
        return char_bigs + filtered_unis
    def get_input_method(self, char):
        total_pairs = zip(frequency, self.total_frequency(char)) # produces list like [('f', 'e'), ('j', 'i'), ('d', 'z'), ('k', 'l'), ('s', 'a'), ('l', 'o'),]
        mapped_pairs = [ element_template % (a,b) for (a,b) in total_pairs]
        mapped_pairs += [ element_template % (a.upper(),b.upper()) for (a,b) in total_pairs] # upper case too!
        mapped_pairs_string = '\n'.join(mapped_pairs)
        return method_template % (char, mapped_pairs_string)

    def write_everything(self):
        all_methods = []
        all_binds = []
        for char in "abcdefghijklmnopqrstuvxwyz":
            all_methods.append(self.get_input_method(char))
            all_binds.append(bind_template % (char, char)) # lowercase
            all_binds.append(bind_template % (char.upper(), char)) # uppercase

        f = open("markov-all.el",'w')
        f.write("(require 'quail)") # we'll need this
        f.write('\n'.join(all_methods))
        f.write('\n'.join(all_binds))
        print("wrote markov-all.el")

    def filter_alpha(self):
        for k in self.unigrams.keys():
            if not k.isalpha():
                del self.unigrams[k]
        # print sorted(self.unigrams.keys()) # did it work?
        for k in self.bigrams.keys():
            if not k.isalpha():
                del self.bigrams[k]
                continue
            for sk in self.bigrams[k].keys():
                if not sk.isalpha():
                    del self.bigrams[k][sk]
        # print sorted(self.bigrams.keys())

def format_alist(pairs):
    return '(%s)' % ' '.join('(%s %s)' % pair for pair in pairs)

def format_bag(counter):
    return format_alist((elisp_char(ch), n)
                        for (ch, n) in counter.most_common())

def elisp_char(ch):
    return '?' + ch if ch.isalpha() else str(ord(ch))

#def format_simple(pairs):
#    return
if __name__ == '__main__':
    import sys
    main(sys.argv)
