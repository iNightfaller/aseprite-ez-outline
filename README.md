# Aseprite EZ Outline

Easily create and remove non-intrusive outlines which follow an outline standard for your sprites. 

With the current outline by itself, outlines are added to the active layer and are baked in. This means if you want to make minor edits and then re-outline, you must delete the entire outline and then re-run the outline tool, or do the outlines by hand. _gross_!

Outlines generated here are in a locked layer so don't worry about accidentally drawing on it.

https://user-images.githubusercontent.com/4659170/218849188-1fded15c-9d9d-48b7-9b34-3655c8e87446.mp4

## Setup & Usage

Add scripts into your Asesprite/scripts folder. 
In Aseprite, with a sprite open, you can run the EZOutlineCreate and EZOutlineDelete respectively
- <b>File->Scripts->EZOutlineCreate:</b> Create/Revalidate the outline
- <b>File->Scripts->EZOutlineDelete:</b> Delete the outline

I HIGHLY recommend adding these actions to your hotkeys!!
- <b>Edit->Keyboard Shortcuts:</b> Search for "ez" and you'll find the lua scripts. Add the kindings here

## Default Behaviors

- Outlines are added to their own locked group under everything else in the scene
- Outline group is called "\_outline_"
- Outline color is the first color in your color palette
- Outline will do a circle pass and then a square pass

## Changing Behaviors

- <b>outlineGroupName:</b> Change the name of the outline group
- <b>GetOutlineColor:</b> Override this to change the generated outline color
- <b>ExecuteOutlineCreation:</b> Configure this to get the exact outline behavior you want


