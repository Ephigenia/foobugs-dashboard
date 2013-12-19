This is a customized [dashing](http://shopify.github.com/dashing) dashboard for [foobugs](http://www.foobugs.com) containing a set of new widget jobs that also can be used in a fresh dashing setup.

## Widgets & Jobs

All of the widgets use public APIs or regexps on scraped website content. So no need fo complicated OAuth Authentification. In most cases a user id or username is the only thing you need to get the data.

* Facebook-page metrics (likes, checkins or talking about)
* Foursquare venue checkins
* GitHub repository stats (forks and watchers)
* GitHub user metrics (followers, following, repos and gists)
* Google play store (application score and comments count)
* Instagram user (photos, followers, following)
* Klout score
* Slideshare user (count of slides, followers)
* Twitter account (followers, following and tweets)
* Vimeo account (likes, uploads, contacts etc.)
* Vimeo account vidoes top-list (top-X of user’s videos)
* Yahoo stock market quote value
* Youtube video metrics (rating, views, likes, comments, favorites)

## Using Widgets

All widgets can be displayed with the `Number` widget that is part of the dashing setup. Please check the `sample.erb` in this repository to see how to use them.

You also can copy single job files over to your own dashboard and use them there. Just place the according `.rb` file in your `jobs` directory.

## What’s that for?

Image you have some KPIs you always want to see when you’re in the office. You just use dashing and the jobs you need to display them permanently on a screen. We’ve installed a permanent dashboard display using a raspberry PI and a LCD screen. We’ll blog about this in 1-2 weeks.

## Demo & Screen

There are two demo dashboards installed on heroku right now:

### Default Dashboard

[Standard Dashboard](http://foobugs-dashboard.herokuapp.com)

<img src="https://raw.github.com/foobugs/foobugs-dashboard/master/dashing_foobugs_screenshot.jpg" /></img>

### Stock Market Dashboard

[Stock Market Example](http://foobugs-dashboard.herokuapp.com/stocks)

<img src="https://raw.github.com/foobugs/foobugs-dashboard/master/dashing_foobugs_stocks_screenshot.jpg"></img>
