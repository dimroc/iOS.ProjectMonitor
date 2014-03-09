[![Build Status](https://travis-ci.org/dimroc/iOS.ProjectMonitor.png?branch=master)](https://travis-ci.org/dimroc/iOS.ProjectMonitor)

iOS Project Monitor
===================

An iPhone app that monitors continuous integration servers for the status
of your builds. Should a build fail, a push notification will be sent to your
phone with information about the faulty commit.

Currently supports [Semaphore](http://www.semaphoreapp.com) and [Travis](http://travis-ci.com/).

Jenkins and TeamCity support coming soon. Feel free to fork the repo and contribute!

Project Setup
=============

The iPhone app uses Parse as its backend and therefore requires credentials.

Copy `ProjectMonitor/Credentials.example.plist` to `ProjectMonitor/Credentials.plist`,
enter your Parse credentials and you're good to go.

Thanks
======

Inspired by Pivotal's [Project Monitor](https://github.com/pivotal/projectmonitor)
and cppforlife's [Checkman](https://github.com/cppforlife/checkman).
