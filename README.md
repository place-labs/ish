# ish

[![GitHub release](https://img.shields.io/github/release/aca-labs/ish.svg)](https://github.com/aca-labs/ish/releases)
[![Build Status](https://travis-ci.org/aca-labs/ish.svg?branch=master)](https://travis-ci.org/aca-labs/ish)
[![Docs](https://img.shields.io/badge/docs-available-brightgreen.svg)](https://aca-labs.github.io/ish/)

![](https://www.charbase.com/images/glyph/8776)

Probabilistic data structures for good-ish computation.

*Note: this library is still WIP*

Provides a set of common data structures that exhibit favourable space / time
characteristics in exchange for precision.

## TODO
- [x] [Count-min sketch](https://en.wikipedia.org/wiki/Count%E2%80%93min_sketch)
- [ ] [Bloom filter](https://en.wikipedia.org/wiki/Bloom_filter)
- [ ] [HyperLogLog](https://en.wikipedia.org/wiki/HyperLogLog)

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  ish:
    github: aca-labs/ish
```

## Usage

See https://aca-labs.github.io/ish/

## Contributing

1. Fork it ( https://github.com/aca-labs/ish/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Kim Burgess](https://github.com/kimburgess) - creator, maintainer
