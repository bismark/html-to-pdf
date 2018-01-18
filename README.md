# HTML to PDF Explorations

Inspired by [Evadne Wu's Elixir London 2016 talk][1], I took the
opportunity during a [HelloSign][2] hackathon to explore how to improve
the overhead of using [`wkhtmltopdf`][3] with `System.cmd`.

I've created a simple C server using `wkhtmltopdf`'s C bindings that
accepts commands over stdin.

`HtmlToPdf.run\0` performs a basic benchmark. On my 2 core 2.5 GHz i7
Macbook Pro, I see approximately 30%-40% speedup.

[1]: https://github.com/evadne/supervised-scaler/
[2]: https://app.hellosign.com/info/jobs
[3]: https://wkhtmltopdf.org/
