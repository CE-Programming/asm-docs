---
layout: page
title: ASM Enviornment Setup
permalink: /setup/asmsetup.html
---

Welcome! Here you will find the nessasary tools for programming in eZ80 assembly. Be sure to follow along carefully so you can be up and ready in no time.

# Steps

As it is a good idea to get familiar with a command shell when doing actual development, this guide will aid you in that process. Simply open a command window, either the command prompt in windows or a similar variant. You can find information on using the shell and available commands [here](http://ss64.com/nt/).

Now, input the following command:
{% highlight %}
md CEasm/include CEasm/tools
{% endhighlight %}
The **md** command creates a directory called *CEasm*, with two subdirectories called *include* and *tools*. We will be placing some things in these folders shortly.

Now, input the following command:
{% highlight %}
echo.>CEasm/include/ti84pce.inc
{% endhighlight %}
This will create an empty file called *ti84pce.inc* in the *./CEasm/include/* directory.

Now, we are going to add some inforamtion to this file. Open the *ti84pce.inc* file in your favorite editing software, such as notepad. If you aren't sure where the *ti84pce.inc* file is if you are used to the nice GUI provided by Windows, simply type **echo %cd%/CEasm/include** into the shell, and it will give you an exact path of the file location.

Open the the CE [Include File](http://wikiti.brandonw.net/index.php?title=84PCE:OS:Include_File) and copy everything in the gray container box, paste into the *ti84pce.inc* file, save, and exit.

Now, you are going to need an assembler. Simply put, this assembler will translate your assembly-flavored code into something that the calculator can execute. Remember, the calculator has no idea what 'code' even is, and can only do what you tell it to.

The latest version of spasm-ng, an eZ80 assembler, can be found [here](https://github.com/alberthdev/spasm-ng/releases).

Place spasm-ng into *./CEasm/tools/* directory, and rename it to **spasm.exe**, if it is not already.

Now you are ready to begin your journey into programming in assembly! Let us begin with the first tutorial.
