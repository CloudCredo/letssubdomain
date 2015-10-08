## What we learned

Even though this app was well intended, we've realises that it's not actually
required. AWS Route53 supports multi-level wildcard records. In plain English,
if `*.cf-hero.cloudcredo.io` is resolved, all subdomains, regardless of level,
will resolve to the same endpoints, e.g.:

```
$ dig +noall +answer baz.cf-hero.cloudcredo.io
baz.cf-hero.cloudcredo.io. 300	IN	A	54.175.58.208
baz.cf-hero.cloudcredo.io. 300	IN	A	52.20.111.137

$ dig +noall +answer bar.baz.cf-hero.cloudcredo.io
bar.baz.cf-hero.cloudcredo.io. 300 IN	A	52.20.111.137
bar.baz.cf-hero.cloudcredo.io. 300 IN	A	54.175.58.208

$ dig +noall +answer foo.bar.baz.cf-hero.cloudcredo.io
foo.bar.baz.cf-hero.cloudcredo.io. 300 IN A	54.175.58.208
foo.bar.baz.cf-hero.cloudcredo.io. 300 IN A	52.20.111.137
```

We've also learned that when we a new record gets registered, it takes a few
minutes for it to propagate, even to the uber popular Google's Public DNS
resolution service.

In conclusion, we've avoided all the extra hassle associated with any new code
and manually resolved the wildcard record.

## About this app

[A web app](https://letssubdomain.platform.cloudcredo.io) to enable
[Cloud Foundry for Beginners: Zero to Hero](https://github.com/CloudCredo/training-cf-for-beginners)
trainees to integrate a custom domain with their Cloud Foundry app.

The app itself talks to the AWS Route53 API to register custom subdomains.
Once registered, they will be used by the trainees e.g.
`cf add-domain cf-hero gerhard.cf-hero.cloudcredo.io` for their own apps.

All registered subdomains are listed on the web app's index page.
