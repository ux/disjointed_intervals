# Disjointed Intervals

Disjointed Intervals allows you to add and remove numerical ranges which are converted into disjointed intervals.

## Setup

1. Install ruby 2.4.1
2. Install bundler - `gem install bundler`
3. Clone `disjointed_intervals` repository - `git clone git@github.com:ux/disjointed_intervals.git`
4. Navigate into cloned repository - `cd disjointed_intervals`
5. Run `bundle install`
6. Start `disjointed_intervals` - `bin/disjointed_intervals`

## Example usage

```ruby
Start: []
Call: add(1, 5) => [[1, 5]]
Call: remove(2, 3) => [[1, 2], [3, 5]]
Call: add(6, 8) => [[1, 2], [3, 5], [6, 8]]
Call: remove(4, 7) => [[1, 2], [3, 4], [7, 8]]
Call: add(2, 7) => [[1, 8]]
```

## Supported commands

* `show` - display current disjointed intervals
* `add from, to` - add range
* `remove from, to` - remove range
* `exit` - exit

## Notes

This is not performant solution, it just shows possible way of implementing disjointed intervals.
It uses [binary search](https://en.wikipedia.org/wiki/Binary_search_algorithm) to find nearest interval - `O(log(N))`,
but it fails on insertions and removals - `O(N)`.
In order to improve its performance it's better to replace flat array with
[self-balancing binary search tree](https://en.wikipedia.org/wiki/Self-balancing_binary_search_tree), like
[Red–black tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree) or
[AVL tree](https://en.wikipedia.org/wiki/AVL_tree).
Also, implementing it on compilable language, like [Go](https://golang.org/),
and threads usage will improve its performance as well.
Another one way to improve performance is to use a database and have a `BTREE` index on `from`/`to` fields.
This may be simple `SQLite` or the better one (or even the best) is a
[Tarantool](https://tarantool.org/) in-memory database with a `TREE` or `AVLTREE` index
and implement this algorithm on a [Lua](https://en.wikipedia.org/wiki/Lua_(programming_language))
as a Tarantool's stored procedures.
