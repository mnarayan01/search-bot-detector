# Search Bot Detector

Detect and verify select (i.e. `Google` and `Yandex`) search bots. Similar functionality is provided by the
[`browser`](https://github.com/fnando/browser) gem; this goes further in that we use DNS lookups to validate that a bot
is actually what it says it is.

## Supported Bots

*   `Googlebot`. Detected and verified as suggested [here](https://support.google.com/webmasters/answer/80553?hl=en).
*   `Yandex robot`. Detected and verified as suggested [here](https://yandex.com/support/webmaster/robot-workings/check-yandex-robots.xml).

## Installation

Simply add `search-bot-detector` to your `Gemfile`:

```ruby
gem "search-bot-detector"
```

## Usage

Super simple example:

```ruby
require "search-bot-detector"

# IP address of `example.com` returns false.
SearchBotDetector.new("93.184.216.34", "Googlebot").any_bot?
# => false

# IP address of `crawl-66-249-66-1.googlebot.com` returns true.
SearchBotDetector.new("66.249.66.1", "Googlebot").any_bot?
# => true

# IP address of `spider-100-43-81-144.yandex.com` returns true.
SearchBotDetector.new("100.43.81.144", "+http://yandex.com/bots").any_bot?
# => true
```
