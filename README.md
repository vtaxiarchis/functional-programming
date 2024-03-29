# README #

Labs for "TDA452 - Functional Programming" course

## Quick Setup ##

### Install Haskell ###
Haskell Platform is available in your distribution's package repository. Note that distribution-packaged versions are typically behind the current platform release. If you prefer to use the latest version rather than the distribution-packaged version, then you may want to use the generic Linux installer. Simply run:
```
$ sudo apt-get install haskell-platform
```

To install Haskell Platform in Mac OS X with Homebrew Cask, simply run:
```
$ brew cask install haskell-platform
```

### Start Haskell ###
If you have installed the Haskell Platform, open a terminal and type ghci (the name of the executable of the GHC interpreter) at the command prompt. Alternatively, if you are on Windows, you may choose WinGHCi in the Start menu.
```
$ ghci
    GHCi, version 6.12.3: http://www.haskell.org/ghc/  :? for help
    Loading package base ... linking ... done.
    Prelude>
```

### Using the GHCi ###
If you already have created a file called example.hs in Haskell you can use :l and :r as abbreviations for :load and :reload.
```
Prelude>  :l example.hs
[1 of 1] Compiling Main             ( example.hs, interpreted )
Ok, modules loaded: Main.
*Main>
```

## Lab assignment 1: The Power function ##

In this lab assignment, we implemented the well-known "power" function in two different new ways. The power function takes two arguments n and k and computes n^k (works only for non-negative k).


## Lab Assignment 2: BlackJack ##

In this lab assignment, we implemented a simple variant of the game Black Jack, using recursive functions and QuickCheck properties. The input/output functionality is provided in the Wrapper.hs file, which takes care of those things.


## Lab Assignment 3: Sudoku ##

In this Lab Assignment, we designed a program that will be able to solve Sudokus, a popular logical puzzle originating from Japan. To implement a Sudoku-solving program, we need to come up with a way of modelling Sudokus. A Sudoku is a matrix of digits or blanks and the natural way of modelling a matrix is as a list of lists.

## Lab Assignment 4: Graphical Calculator ##

In this Lab Assignment, we designed and implemented a very simple graphical calculator. For the graphical part we use the Haste compiler which is able to compile Haskell code to an HTML file which can be run in a web browser. Read more about Haste compiler and how to get started with Haste [here](https://haste-lang.org/).

