[A web app](https://letssubdomain.platform.cloudcredo.io) to enable
[Cloud Foundry for Beginners: Zero to Hero](https://github.com/CloudCredo/training-cf-for-beginners)
trainees to integrate a custom domain with their Cloud Foundry app.

The app itself talks to the AWS Route53 API to register custom subdomains.
Once registered, they will be used by the trainees e.g.
`cf add-domain cf-z2h gerhard-cf-hero.platform.cloudcredo.io` for their own apps.

All registered subdomains can be listed and deleted from the web app itself.
