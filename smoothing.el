;; Interpolate two frequency tables (or "bags").

;; We're representing a frequency table as an a-list of (key count)
;; sorted in descending order of counts.

;; An interpolated table has an entry for every key that's in *either*
;; original table. The count for each key in the new table is a
;; weighted sum of the counts in the originals (taking a missing key
;; in the other to have a 0 count).

(defun bag-interpolate (weight-1 bag-1 weight-2 bag-2)
  "Return a linear combination of two frequency tables."
  (let ((total-1 (bag--total bag-1))
        (total-2 (bag--total bag-2))
        (keys (union (bag--keys bag-1) (bag--keys bag-2))))
    (let ((pairs (loop for key in keys
                       collect `(,key ,(+ (* (/ weight-1 (+ weight-1 weight-2))
                                             (/ (bag--get bag-1 key) total-1))
                                          (* (/ weight-2 (+ weight-1 weight-2))
                                             (/ (bag--get bag-2 key) total-2)))))))
      (sort pairs (lambda (p q)
                    (< (cadr p) (cadr q)))))))

(defun bag--keys (bag)
  "Set of keys of a bag."
  (mapcar #'car bag))

(defun bag--total (bag)
  "Sum of all counts of a bag."
  (reduce #'+ (mapcar #'cadr bag)))

(defun bag--get (bag key)
  "The count for a given key of a bag (0 if missing)."
  (or (cadr (assoc key bag))
      0))
