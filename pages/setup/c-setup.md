---
layout: page
title: C Environment Setup
permalink: /setup/c-setup/
---

Welcome! Here you will find the necessary tools for programming in C. Be sure to follow along carefully so you can be up and ready in no time.

= Installing the SDK =

First, you will need the C development SDK for the CE. You can find that [**here**](https://github.com/CE-Programming/toolchain/releases/latest).

Please pay careful attention to the instructions on that screen, and then your toolchain setup will be installed.

= Building your first program =

Now that the toolchain is set up, navigate to the 'examples\demo_0' folder inside of the 'CEdev' folder. Once inside, open a command shell, and type the command 'make'. This will produce a .8xp file which you can then transfer to your calculator in order to test the program. 'make' is used to build the programs; you can type 'make clean' to delete all the produced files, and 'make -B' in order to perform a total rebuild.

Let us begin with the first tutorial.

1. [Getting started]({{ site.baseurl }}/tutorials/c/getting-started)

= Troubleshooting =

**Q:** I'm using Windows, and it says 'Makefile:00: *** multiple target patterns.  Stop.'
**A:** Add a SHELL:=cmd.exe to the top line of the Makefile file.

**Q:** When I type 'make', is says 'command not found'
**A:** Be sure you have added 'CEdev/bin' to a PATH variable, and the 'CEdev' enviornment varaible points to the CEdev folder.

**Q:** I have an error that isn't described here. Help.
**A:** Be sure that the installation directory is close to your root drive, and there are no spaces in the path name. You can also check under the external links on the sidebar to browse forums and ask questions.