
# Godot bulk mesh collision shape exporter

## Description

Quickly export collision shapes for all Meshes that are children of a Node3D. Very useful if you are working with asset packs.

## System Requirements

There is a decent chance the plugin will work on other versions as well.
__Tested Versions:__
- Godot 4.4

## Installation

The easiest way to install the Plugin will be using Godots Integrated AssetLib. Refer to the [Godot Docs](https://docs.godotengine.org/en/stable/tutorials/plugins/editor/installing_plugins.html)
for details.

## Usage
- Go to the [3D workspace](https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html#d-workspace)
- Select any node that inherits from `Node3D`
- In the [viewport toolbar](https://docs.godotengine.org/en/stable/tutorials/3d/introduction_to_3d.html#main-toolbar) there will be a button called `Bulk Mesh2Collision`
- Upon Selecting this button you will be presented with 4 options
    * `Export Collision Shapes`  
    	Export the collision shapes with the  configured settings. If you don't care about the settings you can just use this without reading the rest of the docs.
    * `General Search Depth`  
    	Specifys how far away a children can be until it will no longer be included in the export.  
__Example__: If this is `1` the base node and its direct Children will be included in the export. Children of Children will not be included.
If this is `0` only the selected Nodes will be used for the export and not their children
    * `Search Depth After Fist Mesh`  
    	Specifys how far away a children can be until it will no longer be included in the export only counting Nodes of type `MeshInstance3D`.  
__Example__: If this is `0` the first meshes found after the selected Node will be included in the export but not their children. If your selected Node has 3 children which are all Meshes all these 3 children would be included. But if the children are nested (children of 1 another) only the highest level child would be included.
If his is `1` and your selected Node is a Mesh and has any Node which doesn't inherit from `MeshInstance3D` which itself has a Meshinstance3D as a child. Both the selected Node and the nested `MeshInstance3D` would be included in the export despite the `Meshinstance3D` not beeing a direct child of the selected Node.
    * `Simplify Shapes`  
    	Toggles the `simplify` parameter of [create_convex_collision](https://docs.godotengine.org/en/stable/classes/class_meshinstance3d.html#class-meshinstance3d-method-create-convex-collision) 
(Simplifys the generated Collision Shapes for better performance)