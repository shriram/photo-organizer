#lang racket

(define target-dir "/Users/sk/Dropbox/Camera Uploads/")

(define all-files/path (directory-list target-dir))

(define fn-r #rx"(....)-(..)-(..) (..)\\.(..)\\.(..)\\..*")

;; Print filenames that don't match
;; Most should be harmless (like .DS_Store and Icon)
;;   but run this to make sure no important files are missed
(define (non-matching)
  (filter (λ (f) (not (regexp-match fn-r (path->string f))))
          all-files/path))
