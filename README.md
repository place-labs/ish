# ish

Probabilistic data structures for good-ish computation.

*Note: this library is still WIP*

Provides a set of common data structures that exhibit favourable space / time
characteristics in exchange for precision.

## TODO
- [ ] [Count-min sketch](src/ish/count_min_sketch.cr)
- [ ] Bloom filter
- [ ] HyperLogLog

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  ish:
    github: aca-labs/ish
```

## Usage

```crystal
require "ish"
```

## Contributing

1. Fork it ( https://github.com/aca-labs/ish/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [Kim Burgess](https://github.com/kimburgess) - creator, maintainer
