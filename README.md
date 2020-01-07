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
- Fix some trouble with opening multiple Metapost output buffers.
