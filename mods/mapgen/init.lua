local node = "default:cobble"

minetest.register_on_mapgen_init(function(mgparams)
	minetest.set_mapgen_params({mgname="singlenode", flags="nolight"})
end)

minetest.register_on_generated(function(minp, maxp)
	if minp.y <= 0 then
		local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
		local data = vm:get_data()
		local area = VoxelArea:new({MinEdge=emin, MaxEdge=emax})
		local node_id = minetest.get_content_id(node)
		
		local y = minp.y
		for x = minp.x, maxp.x do
			for z = minp.z, maxp.z do
				y = minp.y
				while y <= 0 and y <= maxp.y do
					local p_pos = area:index(x, y, z)
					data[p_pos] = node_id
					y = y+1
				end
			end
		end
		vm:set_data(data)
		vm:calc_lighting()
		vm:update_liquids()
		vm:write_to_map()
	end
end)
