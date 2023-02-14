--local spr = app.activeSprite
--app.alert(tostring (spr))
function string.starts(String,Start)
   return string.sub(String,1,string.len(Start))==Start
end

function ProcessLayer(sprite, outlineGroup, layers)
	-- Find to outline
	toOutline = {}
	for i,layer in ipairs(layers) do
		table.insert(toOutline, layer)
	end
	
	-- Outline
	for i,layer in ipairs(toOutline) do
		if layer.isGroup then
			ProcessLayer(sprite, outlineGroup, layer.layers)
		else
			app.activeLayer = layer
			app.command.DuplicateLayer{}
			outlineLayer = app.activeLayer
			outlineLayer.name = layer.name
			outlineLayer.parent = outlineGroup
			firstColor = sprite.palettes[1]:getColor(0)
			local rgbaA = app.pixelColor.rgbaA
			hasPixels = false
			for i,cel in ipairs(outlineLayer.cels) do
				for it in cel.image:pixels() do
					alpha = rgbaA(it())
					if alpha ~= 0 then
						it(app.pixelColor.rgba(firstColor.red, firstColor.green, firstColor.blue, alpha))
						hasPixels = true
					end
				end
			end
			if hasPixels then
				app.command.Outline {
					ui=false,
					channels=FilterChannels.RGBA,
					place='outside',
					matrix='circle',
					color=firstColor,
					bgColor=Color(),
					tiledMode='none'
				}
				app.command.Outline {
					ui=false,
					channels=FilterChannels.RGBA,
					place='outside',
					matrix='square',
					color=firstColor,
					bgColor=Color(),
					tiledMode='none'
				}
			end
		end
	end
end

app.transaction(
	function()
		for i,sprite in ipairs(app.sprites) do
			if app.activeSprite == sprite then
				toRemove = {}
				for i,layer in ipairs(sprite.layers) do
					if string.starts(layer.name, "_outline_") then
						table.insert(toRemove, layer)
					end
				end
			
				-- Delete
				for i,layer in ipairs(toRemove) do
					sprite:deleteLayer(layer)
				end
			end
		end
	end
)
--app.command.Outline{
--	ui=false
--}