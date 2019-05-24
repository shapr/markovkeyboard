"""
Collect unigram and bigram statistics from a corpus of text.
Write out the data in an ELisp-friendly association-list format,
sorted by frequency descending.
"""

from collections import Counter
def main(argv):
    real_filenames = argv[1:]
    real_main(real_filenames)

def real_main(real_filenames):
    trainer = Stats()
    for filename in real_filenames:
        print("filename is ", filename)
        print("sys.argv is", sys.argv)
        with open(filename) as f:
            trainer.train(f.read().lower())
    trainer.filter_alpha()
    with open('freqs', 'w') as f:
        trainer.dump(f)
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
    def filter_alpha(self):
        for k in self.unigrams.keys():
            if not k.isalpha():
                del self.unigrams[k]
        print sorted(self.unigrams.keys()) # did it work?
        for k in self.bigrams.keys():
            if not k.isalpha():
                del self.bigrams[k]
                continue
            for sk in self.bigrams[k].keys():
                if not sk.isalpha():
                    del self.bigrams[k][sk]
        print sorted(self.bigrams.keys())

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
