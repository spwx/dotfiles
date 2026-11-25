;;; early-init.el --- before the GUI and packages -*- lexical-binding: t; -*-

;; Garbage collect less often. The default (800KB) is tuned for 1990s
;; machines; LSP traffic in particular churns memory.
(setq gc-cons-threshold (* 64 1024 1024))

;; Remove UI chrome by editing the *frame parameters* the first frame is
;; created with, rather than creating it and then turning things off.
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Blend in title bar.
(push '(ns-transparent-titlebar . t) default-frame-alist)
(push '(ns-appearance . dark) default-frame-alist)

(setq inhibit-startup-screen t)

