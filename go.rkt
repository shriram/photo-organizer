#lang racket

(define target-dir "/Users/sk/Dropbox/Camera Uploads/")

(define all-files/path (directory-list target-dir))

(define fn-r #rx"(....)-(..)-(..) (..)\\.(..)\\.(..)\\..*")
