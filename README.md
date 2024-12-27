[![Actions Status](https://github.com/raku-community-modules/WWW-DuckDuckGo/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/WWW-DuckDuckGo/actions) [![Actions Status](https://github.com/raku-community-modules/WWW-DuckDuckGo/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/WWW-DuckDuckGo/actions) [![Actions Status](https://github.com/raku-community-modules/WWW-DuckDuckGo/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/WWW-DuckDuckGo/actions)

NAME
====

WWW::DuckDuckGo - Bindings to DuckDuckGo search API

SYNOPSIS
========

```raku
use WWW::DuckDuckGo;

my $duck = WWW::DuckDuckGo.new;
my $zeroclickinfo1 = $duck.zci('duck duck go');
my $zeroclickinfo2 = $duck.zci('one', 'another');
```

DESCRIPTION
===========

This class provides a way to get data from DuckDuckGo search service. The basic idea is to create a class instance that represents JSON answer from the server for every query.

This is a functional port of the Perl module of the same name, see [`WWW::DuckDuckGo`](https://metacpan.org/pod/WWW::DuckDuckGo).

AUTHOR
======

Alexander Kiryuhin

COPYRIGHT AND LICENSE
=====================

Copyright 2016 - 2021 Alexander Kiryuhin

Copyright 2024 Raku Community

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

