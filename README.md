# Surpass The Limit

### To get running:

Grab a copy of the repo, either forking or cloning and configure your keys to point to the repo. cd into it.

``rake db:create:all``

``rake db:schema:load``

For facebook auth to work properly, use [pow](http://pow.cx) and configure it to "stl.dev".

Use [guard](https://github.com/guard/guard) for specs via ``bundle exec guard``.

### When Pushing:

Push to a branch on the repo and issue a pull request.

### Getting Email Notifications in Development

run ``rake jobs:work`` in a separate terminal tab to start the worker