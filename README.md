Radiatr2

This code was originally stolen/borrowed/forked from
[here](https://github.com/ajb/statuspanic). It was used as a starting
point because it emulated the beautiful Panic dashboard. From there, it
was served up via a Sinatra back end and added some little touches.

The reason for the move from greasemonkey (the technology stack for
Radiatr) is that greasemonkey was acting up on us and it was very
difficult to test and debug. So, we are going to use a proper server and
proper web technologies.

To use this, you'll need ruby to run Sinatra. Your monitor doesn't have
to be the Sinatra server but it might make sense to do it that way (as
we have done). The server itself is very light and easy to run. It'll
also make debugging easier.

So, you'd fork this repository and edit the config.yaml. It currently
only has two properties. Url is the base url for your hudson job
(something like http://buildserver/job/Project) and project name is the
name of the project (not the job).

Hopefully, we can make this better and provide more useful and
interesting information. We can create new connectors to connect to
other CIs, to other project-related tools, etc.

To contribute you may download this code and submit pull requests. 
