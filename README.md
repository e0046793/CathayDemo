# CathayDemo
An iOS app that allows user fetch data from TMDB web service

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

What things you need to run the application

```
Xcode 8
Swift 3
iOS 10 and later
iPhone 
Portrait
```

### Installing

Open project by using Xcode 8, no dependencies required. 

Search for __Configuration.plist__ located in `Config` folder and set your TMDB API Key.

Press Command + R to build.

## Running the tests

Press Command + U to run all the tests. 

### Features
1. Home screen with list of available movies
    1. Ordered by release date
    2. Pull to refresh
    3. Load when scrolled to bottom
    4. Each movie to include:
        * Poster/Backdrop image
        * Title
        * Popularity
2. Detail screen
    1. Movie details with these  additional  details:
        * Synopsis
        * Genres
        * Language
        * Duration
    2. Book the movie (simulate opening of [this link](http://www.cathaycineplexes.com.sg) in a web view)
    
