---
layout: page
title: Getting Started
permalink: /tutorials/c/getting-started/
---

# Creating Tilemaps with Tiled

Tiled is a nifty tool that you can use to create advanced tilemaps for your programs. You will need to download and install it from [**here**](http://www.mapeditor.org/) first. Once Tiled is installed, start it up and let's get going.

# The First Steps

First, click on the `New` button to start creating a tilemap.
![New Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image1.png "Creating a new tilemap")

It will then ask you for a bunch of different options; you can leave most of them as standard but you will have to change the `Tile Size` option if your tiles are not 16x16, and are instead 8x8 or something similar.
![New Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image2.png "Creating a new tilemap")

Next, you will have to add the image tiles you wish to use for your tilemap. You can find it under `Map -> New Tileset`
![New Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image3.png "Creating a new tilemap")

It will then ask you for an image of where to pull your tiles. Select the image you wish to use; keep in mind that ConvPNG can only handle images without any padding around tiles.
![New Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image4.png "Creating a new tilemap

You can then choose the transparent color you wish to use when working with multiple layer tilemaps.
![New Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image5.png "Creating a new tilemap")

# Editing the Tilemap

Using Tiled, you can then build the non-transparent base layer of your tilemap. Once you are done creating your tilemap, choose the `Rectangular Select`
![Editing Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image6.png "Choosing the rectangular select")

Select the tiles that you have placed, and then choose `Crop to Selection` from the `Map` menu bar.
![Editing Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/crop.png "Crop the tilemap")

Next, we are going to add our second transparent layer. Choose `Add Tile Layer` from the `Layer` menu bar. You can switch between the two layers by using the right side pane.
![Editing Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image7.png "Choosing 'Add Tile Layer'")

This is what our final tilemap looks like:
![Editing Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image8.png "Do it and you're cool")

# Exporting the Tilemap

Next, we need to export the tilemap so we can use it in our program. Choose the `Export As...` option from the `File` menu bar.
![Exporting Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image9.png "Export As...")

Save the tilemap using the `.csv` format.
![Exporting Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image10.png "JUST DO IT")

From there, navigate to the folder where you saved the tilemap. There should be layers for each; *please rename them so that the files have no spaces*
![Exporting Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image11.png "Please, please, please rename it. Please.")

# Building the tilemap

The last step is to make it possible to use the tilemap in your code. Assuming you have the toolchain set up correctly, simply enter in 'convtile' and the name of the header file you wish to reference.
![Building Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image12.png "Awesomeness")

ConvTile will then create two files; a .c and .h file. You can #include the .h file to use the outputted tilemap arrays in your program.
![Building Tilemap]({{site.baseurl}}/images/tutorials/c/tiled/image12.png "#include \"pokemon_tilemaps.h\"")

If you have any questions, feel free to post on GitHub. Enjoy!