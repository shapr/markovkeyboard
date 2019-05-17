"""
Collect unigram and bigram statistics from a corpus of text.
Write out the data in an ELisp-friendly association-list format,
sorted by frequency descending.
"""

from collections import Counter

def main(argv):
    trainer = Stats()
    for filename in sys.argv[1:]:
        with open(filename) as f:
            trainer.train(f.read().lower())
    with open('freqs', 'w') as f:
        trainer.dump(f)

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
    def dump(self, file):
        print format_counter(self.unigrams)
        print format_alist((str(ord(ch)), format_counter(counter))
                           for (ch,counter) in self.bigrams.items())

def format_counter(counter):
    return '(%s)' % ' '.join('(%d %d)' % (ord(ch), n)
                             for (ch,n) in counter.most_common())

def format_alist(pairs):
    return '(%s)' % ' '.join('(%s %s)' % pair for pair in pairs)


if __name__ == '__main__':
    import sys
    main(sys.argv)
