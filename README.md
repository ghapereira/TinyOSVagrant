# TinyOS Vagrant
The [official installing instructions](http://tinyos.stanford.edu/tinyos-wiki/index.php/Installing_TinyOS) were not sufficient for me to use TinyOS. The [provided VM](https://systembash.com/ubuntos-ubuntu-9-10-tinyos-2-x-virtualbox-image/) works just fine, but being a Ubuntu 9 version it cannot be
easily updated and it is hard to get files in and out of the machine. This way,
I made my own Vagrant machine with instructions scattered on the web. I automated
what I could, but some steps are still manual.

## Steps

## Tips and comments

* TOSSIM does not work with the Iris sensors, in this setup. I could compile for
simulation only with `micaz` and `telosb`.

## Resources
[The updated and most complete installing docs I found](http://www.cse.wustl.edu/%7Elu/cse467s/slides/tinyos-installation.pdf)


[This thread contains the make location, in which the Python and GCC versions must be changed](http://tinyos-help.millennium.berkeley.narkive.com/LZohJqEO/tinyos-compilation-error-fatal-error-python-h-no-such-file-or-directory)

[This thread explains the correct GCC version](https://github.com/tinyos/tinyos-main/issues/373)

[How to install older GCC versions](https://askubuntu.com/questions/39628/old-version-of-gcc-for-new-ubuntu)

[Fix a problem I had with UTF8 locales; not linked to TinyOS but useful](https://gist.github.com/panchicore/1269109)

