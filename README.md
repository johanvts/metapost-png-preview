# Metapost PNG preview for Emacs

Easy interactive workflow for writing Metapost in Emacs.

Based on [metapost-mode+](https://github.com/liyu1981/metapost-mode-) but
using the Metapost png backend.


![Alt text](png-preview.PNG?raw=true "Metapost PNG preview.")

## Usage

To preview the current figure:

```
M-x metapost-png-next
```

## Installation

Simply load the file

```
(load "metapost-png-preview-mode.el")
```

## ToDo

- Add as a Melpa package.
    -  Package-lint found these issues that should be fixed before adding to MELPA:
    -  16 issues found:
    -  1:0: warning: "Version:" or "Package-Version:" header is missing. MELPA will handle this, but other archives will not.
    -  1:0: error: Package should have a ;;; Commentary section.
    -  1:0: error: Package should have a Homepage or URL header.
    -  1:0: error: package.el cannot parse this buffer: Package lacks a file header
    -  7:0: error: "metapost-prev-outputformat" doesn't start with package's prefix "metapost-png-preview".
    -  11:0: error: "metapost-prog-mpost" doesn't start with package's prefix "metapost-png-preview".
    -  15:0: error: "metapost-regex-find-first-match" doesn't start with package's prefix "metapost-png-preview".
    -  23:0: error: "metapost-outputformat-set" doesn't start with package's prefix "metapost-png-preview".
    -  42:7: warning: Closing parens should not be wrapped onto new lines.
    -  44:0: error: "metapost-outputformat-remove" doesn't start with package's prefix "metapost-png-preview".
    -  55:0: error: "metapost-outputformat-restore" doesn't start with package's prefix "metapost-png-preview".
    -  62:0: error: "metapost-compile-buffer" doesn't start with package's prefix "metapost-png-preview".
    -  69:0: error: "metapost-prepare-buffer" doesn't start with package's prefix "metapost-png-preview".
    -  80:0: error: "metapost-locate-figure-no" doesn't start with package's prefix "metapost-png-preview".
    -  118:0: error: "metapost-png-next" doesn't start with package's prefix "metapost-png-preview".
    -  134:18: error: You should depend on (emacs "24.3") if you need `display-buffer-below-selected'.
- Testing, especially on non Windows10/miktex setups.

## License
[MIT](https://choosealicense.com/licenses/mit/)
