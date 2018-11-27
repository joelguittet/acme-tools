acme-tools
==

Acme Systems Yocto tools.

This layer contains tools to flash and use the Acme Systems boards.


Flashing
--

One bash script is available to flash the Acme Systems boards:
* acme-flash-arietta.sh: to flash Arietta-G25 and Arietta-G25-256 boards.

Instructions to use them are available in my Github at https://github.com/myfreescalewebpage/meta-acme.


Debug
--

Connecting to the Acme Systems boards is possible to access the linux console. Several possibilities exists:
* Throw the USB CDC Gadget interface.
* Throw the 3.3V TTL serial interface.

The 3.3V TTL serial interface is available on debug pins on Acme Systems boards.

The following schema can be used to interface the 3.3V TTL interface to an RS232 compatible port.

![acme-serial-debug-rs232](https://github.com/myfreescalewebpage/acme-tools/blob/master/acme-serial-debug-rs232.png)

It is also possible to use an FTDI USB to 3.3V TTL converter.


Contributing
--

All contributions are welcome :-)

Use Github Issues to report anomalies or to propose enhancements (labels are available to clearly identify what you are writing) and Pull Requests to submit modifications.
