[![Build Status](https://travis-ci.org/dimroc/iOS.ProjectMonitor.png?branch=master)](https://travis-ci.org/dimroc/iOS.ProjectMonitor)

iOS Project Monitor
===================

![Icon](https://raw.githubusercontent.com/dimroc/iOS.ProjectMonitor/master/client/ProjectMonitor/Images.xcassets/AppIcon.appiconset/AppIconv2.png)
[Available for free in the App Store!](https://itunes.apple.com/us/app/project-monitor/id857272990?ls=1&mt=8)

An iPhone app that monitors continuous integration servers for the status
of your builds. Should a build fail, a push notification will be sent to your
phone with information about the faulty commit. Coming to the app store in just a week (or two)!

![Screens](https://raw.githubusercontent.com/dimroc/iOS.ProjectMonitor/master/client/ProjectMonitor/Images.xcassets/screens.imageset/screens.png)

Currently supports [Semaphore](http://www.semaphoreapp.com) and [Travis](http://travis-ci.com/). Jenkins and TeamCity support coming soon. 

Feel free to fork the repo and contribute! The public Pivotal Tracker project can be found [here](https://www.pivotaltracker.com/projects/1001516).

Project Setup - Client
======================

#### Parse
The iPhone app uses Parse as its web server and therefore requires credentials.

Copy `ProjectMonitor/Credentials.example.plist` to `ProjectMonitor/Credentials.debug.plist`,
enter your Parse credentials.

#### Cocoa Pods
Run `pod install` in the `client/` folder to download iOS frameworks and dependencies.

##### Other Credentials
The project uses a variety of optional services (New Relic, Crashlytics, Twitter). Please refer to `ProjectMonitor/Credentials.example.plist` and `ProjectMonitor/ProjectMonitor-Info.debug.plist`.

Project Setup - Frontend (Parse)
===============================

Parse's Cloud Code is used to provide an authentication endpoint for private pusher channels. Details can be found in parse/README.md folder.

Project Setup - Backend
=======================

#### Sidekiq
[Sidekiq](https://github.com/mperham/sidekiq) is the background worker of choice for this project. Start producing work by polling Parse for builds to update with `rake produce`. These builds will then get updated by Sidekiq workers with `rake work`.

Monitoring is available with `rake monitor`.

#### Parse and Pusher
The backend interacts with Parse's REST API and pushes updates with libPusher. Therefore keys are required in `config/application.yml` file. Please see `config/application.yml.example` as reference.

Tests
=====
#### Client
iOS Client tests use [Kiwi](https://github.com/allending/Kiwi) and are run inside XCode.

#### Backend
Backend server tests can be run with RSpec with `rake` in `backend/`.

The backend tests use togglable fakes as outlined in the [Engine Yard talk](https://vimeo.com/26510145). The following command will run the same tests with full integration:

```shell
backend/ $ INTEGRATION=true rake
```

#### Travis
Travis CI runs a test matrix that runs both integration and fake runs as [seen here](https://travis-ci.org/dimroc/iOS.ProjectMonitor).

Thanks
======

Inspired by Pivotal's [Project Monitor](https://github.com/pivotal/projectmonitor)
and cppforlife's [Checkman](https://github.com/cppforlife/checkman).
