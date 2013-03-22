This is a customized [dashing](http://shopify.github.com/dashing) dashbaord for [foobugs](http://www.foobugs.com) containing a list of widget jobs.

See this dashboard in action: [http://foobugs-dashboard.herokuapp.com](http://foobugs-dashboard.herokuapp.com)

<img src="https://raw.github.com/foobugs/foobugs-dashboard/dashing_foobugs_screenshot.jpg" /></img>

## Widgets & Jobs

All of the widgets use public APIs or regexps on scraped website content. So no need fo complicated OAuth Authentification.

* Facebook (Page) Metrics like Likes, Checkins or Talking About Numbers
* Foursquare Venue Metrics Checkins
* GitHub Repository Stats (Forks and Watchers)
* GitHub UserInfo Metrics like followers, following, repos and gists
* Klout Score
* Twitter User Info like Followers, Following and Tweet Count
* Yahoo Stock Quote Value
* Youtube Video Metrics (rating, views, likes, comments, favorites)

## Using Widgets

All widgets can be displayed with the `Number` widget that is part of the dashing setup. Please check the `sample.erb` in this repository to see how to use them.

You also can copy single job files over to your own dashboard and use them there. Just place the according `.rb` file in your `jobs` directory.