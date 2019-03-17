## Assembly Setup

Welcome! Here you will find the necessary tools for programming in eZ80 assembly. Be sure to follow along carefully so you can be up and ready in no time.

# Steps

As it is a good idea to get familiar with a command shell when doing actual development, this guide will aid you in that process. Simply open a command window, either the command prompt in windows or a similar variant. You can find information on using the shell and available commands for Windows [**here**](http://ss64.com/nt/).

If you haven't already, download the `programs` directory located in this repository. You can use the green "download" button on the main page to do this. It has everything preconfigured and downloaded for your ease of use.

We use the latest version of fasmg for development, adapted by [jacobly0](https://github.com/jacobly0/fasmg-ez80) for the best in CE development. These have already been added to the `programs/tools` directory, so no need to download them, but you can check them out [here](https://github.com/jacobly0/fasmg-ez80) and [here](https://flatassembler.net/download.php).

A provided `main.asm` demo file has been placed in the `programs` directory. This is the best place to add all the code in the following tutorials.

To assemble the main file, simply type the following command in the command window, from within the `programs` directory (where main.asm is located):

    .\fasmg.exe main.asm DEMO.8xp

If you are on linux, the command would look like this:

    ./fasmg-linux main.asm DEMO.8xp

And the output binary (DEMO.8xp) file will be placed in the same directory as the source file. It can then be loaded onto the calculator via TI Connect CE or TILP.
