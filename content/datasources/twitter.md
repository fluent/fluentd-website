#Collecting Tweets with Fluentd

##Scenario

Here are some cases where Fluentd is useful:

1. Collecting Tweets related to your business to measure share of voice.
2. Building an archive of past Tweets to perform sentiment analysis.

##Prerequisites

We assume that you already have Fluentd installed and have created a Twitter app (we just need the consumer key/secret and OAuth token/secret).

##Setup

1. Install the [Twitter input plugin](https://github.com/y-ken/fluent-plugin-twitter) by running the following command

    ```
    $ fluent-gem install fluent-plugin-twitter
    ```

2. Open your Fluentd configuration file and add the following lines:

    ```
    <source>
      @type twitter
      consumer_key        YOUR_CONSUMER_KEY # Required
      consumer_secret     YOUR_CONSUMER_SECRET # Required
      oauth_token         YOUR_OAUTH_TOKEN # Required
      oauth_token_secret  YOUR_OAUTH_TOKEN_SECRET # Required
      tag                 input.twitter  # Required
      timeline            userstream # Required (sampling or userstream)
    </source>
    ```

    The above configuration starts streaming data from your timeline and apply the tag `input.twitter`. Alternatively, if you want to search for a particular keyword(s), you can configure it as

    ```
    <source>
      @type twitter
      consumer_key        YOUR_CONSUMER_KEY # Required
      consumer_secret     YOUR_CONSUMER_SECRET # Required
      oauth_token         YOUR_OAUTH_TOKEN # Required
      oauth_token_secret  YOUR_OAUTH_TOKEN_SECRET # Required
      tag                 input.twitter  # Required
      keyword         fluentd, muffins
      timeline            sampling # Required (sampling or userstream)
    </source>
    ```

    It will search for "fluentd" and "muffins" and return the sampled timeline.
