# Fluentd Goes Gopher!

I am pleased to announce that Treasure Data just open sourced [a lightweight Fluentd forwarder written in Go](https://github.com/fluent/fluentd-forwarder). Creatively christened as Fluentd Forwarder, it was designed and written with the following goals in mind.

1. **A simple forwarder for simple use cases**: Fluentd is very versatile and extendable, but sometimes you need something simple. Fluentd Forwarder is meant to be an alternative for such cases.
2. **Support for Windows**: Yes, Fluentd has an experimental Windows branch in active development, but some community members expressed that they wanted something simpler and less experimental that runs in a Windows environment. Thanks to Go's cross-compilation, Fluentd Forwarder should work well out of the box on Windows.
3. **Go is a good fit**: For a program written in Ruby, Fluentd is pretty fast and has a tiny memory footprint at 40MB. Also, it has leveraged Ruby's flexibility and popularity to build [a rich plugin ecosystem](/plugins). That said, Go was designed to write efficient middleware productively, and this project was a natural fit in that regard. Plus, Go, like Fluentd, has a cute logo.

Here are some of the salient features of the first release.

1. **TCP input and output**: By default, Fluentd Forwarder accepts data on 127.0.0.1:24224 and forwards it to 127.0.0.1:24225. You can think of this as in\_forward and out\_forward.
2. **Treasure Data output**: Because this project was conceived to help Treasure Data's customers collect data on Windows servers, it also support Treasure Data as an output option.

It is just as important to mention what Fluentd Forwarder does NOT have.

1. Fluentd Forwarder does not have a pluggable architecture, at least not yet. At the moment, the output destination (either TCP or Treasure Data) is determined by a command line option or configuration parameter URL.
2. Also, the forwarding logic is not as sophisticated as that of [out_forward](https://docs.fluentd.org/articles/out_forward).
3. Fluentd Forwarder does not have downloadable binaries yet, although we plan to make it available soon. Right now, you have to get a Go runtime (**v1.3 and above**) and compile it yourself.

This project is still in its infancy. If you have any feedback, bug report, questions or PULL REQUESTS, they are all welcome!

Finally, many thanks to [Moriyoshi Koizumi](https://github.com/moriyoshi) for writing the initial version. I am excited to see where we go with this sibling project =)

TAG: Fluentd Announcement Golang
AUTHOR: masa