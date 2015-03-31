#!/bin/sh
#
brew tap wkentaro/trr
brew update
brew audit --strict apel
brew audit --strict trr
brew install trr
brew test apel
brew test trr

