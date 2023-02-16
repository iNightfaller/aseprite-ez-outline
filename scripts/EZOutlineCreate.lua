outlineGroupName = "_outline_"

-- Change this to modify the outline color.
function GetOutlineColor(sprite)
	-- Gets the first color in your palette
	return sprite.palettes[1]:getColor(0)
end

-- Change this to modify the outline behavior.
--	See: https://www.aseprite.org/api/command/Outline#outline
function ExecuteOutlineCreation(outlineColor)
	-- Create a circle outline
	app.command.Outline {
		ui=false,
		channels=FilterChannels.RGBA,
		place='outside',
		matrix='circle',
		color=outlineColor,
		bgColor=Color(),
		tiledMode='none'
	}
	-- Create a square outline
	app.command.Outline {
		ui=false,
		channels=FilterChannels.RGBA,
		place='outside',
		matrix='square',
		color=outlineColor,
		bgColor=Color(),
		tiledMode='none'
	}
end

function ProcessLayer(sprite, outlineGroup, layers)
	-- Find layers to outline
	toOutline = {}
	for i,layer in ipairs(layers) do
		table.insert(toOutline, layer)
	end
	
	local rgbaA = app.pixelColor.rgbaA
	outlineColor = GetOutlineColor(sprite)
	
	-- Create the outlines in the Outline Group
	for i,layer in ipairs(toOutline) do
		-- If this is a group, then traverse inside of it
		if layer.isGroup then
			ProcessLayer(sprite, outlineGroup, layer.layers)
		else
			-- Create a new layer
			app.activeLayer = layer
			app.command.DuplicateLayer{}
			outlineLayer = app.activeLayer
			outlineLayer.name = layer.name
			outlineLayer.parent = outlineGroup
			
			-- Make all of the existing pixels the same color as the outline
			hasPixels = false
			for i,cel in ipairs(outlineLayer.cels) do
				for it in cel.image:pixels() do
					alpha = rgbaA(it())
					if alpha ~= 0 then
						it(app.pixelColor.rgba(outlineColor.red, outlineColor.green, outlineColor.blue, alpha))
						hasPixels = true
					end
				end
			end
			
			-- If there are any pixels to outline, run the outline commands
			if hasPixels then
				--ExecuteOutlineCreation(outlineColor)
			end
		end
	end
end

function ProcessSprite(sprite)
	-- Find the outline group
	toRemove = {}
	for i,layer in ipairs(sprite.layers) do
		if string.sub(layer.name,1,string.len(outlineGroupName))==outlineGroupName then
			table.insert(toRemove, layer)
		end
	end

	-- Delete the old outline group
	for i,layer in ipairs(toRemove) do
		sprite:deleteLayer(layer)
	end
	
	prevActiveLayer = app.activeLayer
	prevActiveFrame = app.activeFrame
	
	-- Create the new outline group
	outlineGroup = sprite:newGroup()
	outlineGroup.name = outlineGroupName
	outlineGroup.isCollapsed = true
	outlineGroup.stackIndex = 0
	
	-- Go through each frame
	for i,frame in ipairs(sprite.frames) do
		app.activeFrame = frame
		-- Start processing on the sprite's layers
		ProcessLayer(sprite, outlineGroup, sprite.layers)
	end
	
	-- Finally make the outline un-editable
	outlineGroup.isEditable = false
	
	if prevActiveLayer ~= nil then
		app.activeLayer = prevActiveLayer
	end
	if prevActiveFrame ~= nil then
		app.activeFrame = prevActiveFrame
	end
end


-- Run the script
app.transaction(
	function()
		-- Only process the active sprite
		if app.activeSprite ~= nil then
			ProcessSprite(app.activeSprite)
		end
	end
)

