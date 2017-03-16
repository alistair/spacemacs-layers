;;; packages.el --- csharp Layer packages File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defconst csharp-roslyn-packages
  '(
    company
    csharp-mode
    evil-matchit
    ggtags
    helm-gtags
    shut-up
    (omnisharp :location (recipe
         :fetcher github
         :repo "Omnisharp/omnisharp-emacs"
         :branch "feature-omnisharp-roslyn-support"
         :files ("*.el"
                  "src/*.el"
                  "src/actions/*.el")
      ))
    ))

(defun csharp-roslyn/init-omnisharp ()
  ;; Load omnisharp-mode with csharp-mode, this should start the omnisharp server automatically
  (add-hook 'csharp-mode-hook 'omnisharp-mode)
  (use-package omnisharp
    :defer t
    :init
    (progn
      (when (configuration-layer/package-usedp 'company)
        ;; needed to avoid an error when fetching doc using company
        ;; Note: if you are using a roslyn based omnisharp server you can
        ;; set back this variable to t.
        (setq omnisharp-auto-complete-want-documentation nil))
      (push 'company-omnisharp company-backends-csharp-mode)
      (add-to-list 'spacemacs-jump-handlers-csharp-mode
                'omnisharp-go-to-definition))
    :config
    (progn
      (spacemacs/declare-prefix-for-mode 'csharp-mode "mf" "csharp-roslyn/file")
      (spacemacs/declare-prefix-for-mode 'csharp-mode "mg" "csharp-roslyn/navigation")
      (spacemacs/declare-prefix-for-mode 'csharp-mode "mh" "csharp-roslyn/documentation")
      (spacemacs/declare-prefix-for-mode 'csharp-mode "mr" "csharp-roslyn/refactoring")
      (spacemacs/declare-prefix-for-mode 'csharp-mode "ms" "csharp-roslyn/server")
      (spacemacs/declare-prefix-for-mode 'csharp-mode "mt" "csharp-roslyn/tests")
      (spacemacs/set-leader-keys-for-major-mode 'csharp-mode
        ;; TO ADD
        ;;

        ;;these exist in emacs package
        ;; Solution/project manipulation

        ;; doesnt work
        ;;"fa" 'omnisharp-add-to-solution-current-file
        "fA" 'omnisharp-add-to-solution-dired-selected-files

        ;; Server manipulation, inspired spacemacs REPL bindings since C# does not provice a REPL
        "ss" 'omnisharp-start-omnisharp-server
        ;;"sS" 'omnisharp-stop-server
        ;;"sr" 'omnisharp-reload-solution

        ;; Help, documentation, info
        "ht" 'omnisharp-current-type-information
        "hT" 'omnisharp-current-type-information-to-kill-ring
        "hd" 'omnisharp-current-type-documentation

        ;; Is this really a good place for it
        "ho" 'omnisharp-show-overloads-at-point

        ;;Refactoring
        "rm" 'omnisharp-rename
        ;;doesnt work
        ;;"rM" 'omnisharp-rename-interactively
        "rr" 'omnisharp-run-code-action-refactoring

        ;; Navigation
        "gu"   'omnisharp-helm-find-usages
        "gU"   'omnisharp-find-usages-with-ido
        "gs"   'omnisharp-helm-find-symbols
        "gi"   'omnisharp-find-implementations
        "gI"   'omnisharp-find-implementations-with-ido
        "gG"   'omnisharp-go-to-definition-other-window
        "gr"   'omnisharp-navigate-to-region
        "gm"   'omnisharp-navigate-to-solution-member
        "gM"   'omnisharp-navigate-to-solution-member-other-window
        "gf"   'omnisharp-navigate-to-solution-file
        "gF"   'omnisharp-navigate-to-solution-file-then-file-member
        "gc"   'omnisharp-navigate-to-current-file-member

        ;;Code manipulation
        "=" 'omnisharp-code-format-entire-file
        "F" 'omnisharp-code-format-region

        ;; Checking

        ;; Navigation
        ;; Refactoring
        ;; Server manipulation, inspired spacemacs REPL bindings since C# does not provice a REPL
        ;;"ss" 'omnisharp-start-omnisharp-server
        ;;"sS" 'omnisharp-stop-server
        ;;"sr" 'omnisharp-reload-solution
        ;; Tests
        ;;"ta" 'omnisharp-unit-test-all
        ;;"tb" 'omnisharp-unit-test-fixture
        ;;"tt" 'omnisharp-unit-test-single
        ;; Code manipulation
        ;;"u" 'omnisharp-auto-complete-overrides
        ;;"i" 'omnisharp-fix-usings
        ;;"=" 'omnisharp-code-format
        ))))

(defun csharp-roslyn/post-init-company ()
  (spacemacs|add-company-hook csharp-mode))

(defun csharp-roslyn/init-csharp-mode ()
  (use-package csharp-mode
    :defer t))

(defun csharp-roslyn/post-init-evil-matchit ()
  (with-eval-after-load 'evil-matchit
    (plist-put evilmi-plugins 'csharp-mode '((evilmi-simple-get-tag evilmi-simple-jump)
                                             (evilmi-c-get-tag evilmi-c-jump))))
  (add-hook 'csharp-mode-hook 'turn-on-evil-matchit-mode))

(defun csharp-roslyn/post-init-ggtags ()
  (add-hook 'csharp-mode-local-vars-hook #'spacemacs/ggtags-mode-enable))

(defun csharp-roslyn/post-init-helm-gtags ()
  (spacemacs/helm-gtags-define-keys-for-mode 'csharp-mode))
