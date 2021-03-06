----------
-- Payday 2 GoonMod, Weapon Customizer Beta, built on 1/3/2015 12:28:05 AM
-- Copyright 2014, James Wilkinson, Overkill Software
----------

local Mutator = class(BaseMutator)
Mutator.Id = "BulldozersWithShields"
Mutator.OptionsName = "Armour Plating"
Mutator.OptionsDesc = "Bulldozers spawn with shields"
Mutator.AllPlayersRequireMod = true

Mutator.CheckShield = "CopInventoryCheckSpawnShield_" .. Mutator:ID()
Mutator.UpdateShield = "CopInventoryUpdate_" .. Mutator:ID()

Mutator.ShieldUnits = {
	[1] = "units/payday2/characters/ene_acc_shield_lights/ene_acc_shield_lights",
	[2] = "units/payday2/characters/ene_acc_shield_small/shield_small",
}

Hooks:Add("GoonBaseRegisterMutators", "GoonBaseRegisterMutators_" .. Mutator:ID(), function()
	GoonBase.Mutators:RegisterMutator( Mutator )
end)

function Mutator:OnEnabled()
	
	Hooks:Add("CopInventoryCheckSpawnShield", self.CheckShield, function(inventory, weapon_unit)
	
		if inventory._unit:base()._tweak_table == "tank" then
			inventory._shield_unit_name = self.ShieldUnits[ math.random(1, #self.ShieldUnits) ]
			inventory._shield_attach_point = Idstring("a_weapon_right_front")
		end

		if inventory._shield_unit_name and not alive(inventory._shield_unit) then
			local align_name = inventory._shield_attach_point or Idstring("a_weapon_left_front")
			local align_obj = inventory._unit:get_object(align_name)
			inventory._shield_unit = World:spawn_unit(Idstring(inventory._shield_unit_name), align_obj:position(), align_obj:rotation())
			inventory._unit:link(align_name, inventory._shield_unit, inventory._shield_unit:orientation_object():name())
			inventory._shield_unit:set_enabled(false)
		end

	end)

	Hooks:Add("CopInventoryUpdate", self.UpdateShield, function(inventory, unit, t, dt)
		
		if alive(inventory._shield_unit) and inventory._unit:base()._tweak_table == "tank" then

			local align_name = inventory._shield_attach_point or Idstring("a_weapon_left_front")
			local align_obj = inventory._unit:get_object(align_name)
			inventory._shield_unit:set_local_position( Vector3(0, 10, 0) )

		end

	end)

end

function Mutator:OnDisabled()
	Hooks:Remove(self.CheckShield)
	Hooks:Remove(self.UpdateShield)
end
-- END OF FILE
