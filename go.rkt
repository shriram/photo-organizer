#lang racket

(define target-dir "/Users/sk/Dropbox/Camera Uploads/")

(define all-files/path (directory-list target-dir))

;; Example filenames:
(define fn/1 "2019-04-29 20.32.56.jpg")
(define fn/2 "2020-04-25 11.00.14-2.jpg")
(define fn/3 "2020-02-15 13.09.23.mp4")
(define fn-r #rx"(....)-(..)-(..) (..)\\.(..)\\.(..).*")

;; Print filenames that don't match
;; Most should be harmless (like .DS_Store and Icon)
;;   but run this to make sure no important files are missed
(define (non-matching)
  (filter (λ (f) (not (regexp-match fn-r (path->string f))))
          all-files/path))

(define (regexp->date m)
  ;; example of a match:
  ;; '("2020-04-25 11.00.14-2.jpg" "2020" "04" "25" "11" "00" "14")
  (define bits (rest m)) ;; remove whole string
  (define nums (map string->number bits))
  (match nums
    [(list year month day hh mm ss)
     (date ss mm hh day month year 0 0 false 0)]))
