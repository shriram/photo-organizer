#lang racket

(require racket/date)
(require math plot)
(require rackunit)

(define target-dir (string->path "/Users/sk/Dropbox/Photographs/To-File/Old/"))
(define clusters-dir "Clusters")

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

(define all-files/sec
  (map date->seconds
       (map regexp->date
            (filter-map (λ (f) (regexp-match fn-r (path->string f)))
                        all-files/path))))

(check-equal? (length all-files/path) (+ (length (non-matching)) (length all-files/sec)))

(define time-gap/days 2)
(define time-gap/seconds (* 60 60 24 time-gap/days))

(define all-but-last (take all-files/sec (sub1 (length all-files/sec))))
(define time-diffs (map - (rest all-files/sec) all-but-last))

(define (show)
  (define-values (bins counts)
    (count-samples time-diffs))
  (define b+c (map vector bins counts))
  (define b+c/s
    (sort b+c
          (λ (bc1 bc2)
            (< (vector-ref bc1 0) (vector-ref bc2 0)))))
  (plot (discrete-histogram b+c/s)))

(struct foto (pt dt ss) #:transparent) ;; path, date, seconds

(define fotos
  (filter-map (λ (p)
                (define fn (path->string p))
                (cond
                  [(regexp-match fn-r fn) => (λ (r)
                                               (define d (regexp->date r))
                                               (foto p d (date->seconds d)))]
                  [else false]))
              all-files/path))

(check-equal? (length fotos) (length all-files/sec))

(define fotos/sorted
  (sort fotos
        (λ (f1 f2)
          (< (foto-ss f1) (foto-ss f2)))))

(check-equal? (length fotos) (length fotos/sorted))

(define (clusters fs/s)
  (cond
    [(empty? fs/s) empty]
    [(cons? fs/s)
     (let-values ([(cl r) ;; cluster, rest
                   (make-cluster fs/s (foto-ss (first fs/s)))])
       (cons cl (clusters r)))]))

(define (make-cluster fs/s latest-ts)
  (define (helper fs/s latest-ts acc)
    (match fs/s
      [(list) (values acc empty)]
      [(list-rest hd tl)
       (if (< (- (foto-ss hd) latest-ts) time-gap/seconds)
           (helper tl (foto-ss hd) (cons hd acc))
           (values acc fs/s))]))
  (helper fs/s latest-ts empty))

(define cs (clusters fotos/sorted))

(check-equal? (length fotos/sorted) (apply + (map length cs)))

(define (make-dirs)
  (define clusters-path (build-path target-dir clusters-dir))
  (unless (directory-exists? clusters-path)
    (println clusters-path)
    (make-directory clusters-path))
  (for-each (λ (c)
              (define cluster-dir-name (foto-pt (first c)))
              (define cluster-path (build-path clusters-path cluster-dir-name))
              (unless (directory-exists? cluster-path)
                (println cluster-path)
                (make-directory cluster-path)))
            cs))

(define (move-files)
  (define clusters-path (build-path target-dir clusters-dir))
  (for-each (λ (c)
              (define cluster-dir-name (foto-pt (first c)))
              (define cluster-path (build-path clusters-path cluster-dir-name))
              (for-each (λ (f)
                          (define full-file-path (build-path target-dir (foto-pt f)))
                          (when (file-exists? full-file-path)
                            (println full-file-path)
                            (rename-file-or-directory
                             full-file-path
                             (build-path clusters-path cluster-dir-name (foto-pt f)))))
                        c))
            cs))