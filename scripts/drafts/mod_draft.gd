extends Object
class_name ModDraft


const COOLDOWN_PLAYER_MOD = preload("res://mods/cooldown_player_mod.tscn")
const DAMAGE_PLAYER_MOD = preload("res://mods/damage_player_mod.tscn")
const LUCK_PLAYER_MOD = preload("res://mods/luck_player_mod.tscn")
const SPEED_PLAYER_MOD = preload("res://mods/speed_player_mod.tscn")
const VITALITY_PLAYER_MOD = preload("res://mods/vitality_player_mod.tscn")
const MAGNET_PLAYER_MOD = preload("res://mods/magnet_player_mod.tscn")


# Dagger Mods
const HITS_DAGGER_MOD = preload("res://mods/dagger/hits_dagger_mod.tscn")


enum ModType {
	UNKNOWN = 0,
	COOLDOWN = 1,
	DAMAGE = 2,
	SPEED = 3,
	LUCK = 4,
	WEAPON_MOD = 5,
	VITALITY = 6,
	MAGNET = 7,
}

# Rarity defines the quality of upgrades and gear. The order of the enum values
# from highest to lowest is very important! If you want to know why, check the roulette code.
enum Rarity {
	UNKNOWN = 0,
	LEGENDARY = 1,
	ARTIFACT = 2,
	RARE = 3,
	UNCOMMON = 4,
	COMMON = 5,
}

# When creating a new weapon, you must include it here in order to get the draft
# working for it.
enum Weapon {
	UNKNOWN = 0,
	DAGGER = 1,
}

enum DaggerMods {
	UNKNOWN = 0,
	HITS = 1,
}

var _player: PlayerCharacter
var _rarity_roulette: Array[float]
var _config: GameConfig
var all_mod_types: Array[ModType]


func _init(player: PlayerCharacter, config: GameConfig) -> void:
	_player = player
	_rarity_roulette = []
	_rarity_roulette.resize(Rarity.size())
	_rarity_roulette.fill(Rarity.UNKNOWN)
	for rarity in config.mod_draft_config.rarity_chances:
		_rarity_roulette[rarity] = config.mod_draft_config.rarity_chances[rarity]
	_config = config
	for mod_type in ModType.values():
		if mod_type == ModType.UNKNOWN:
			continue
		all_mod_types.append(mod_type)


func roll() -> Array[ModData]:
	var draft: Array[ModData] = []
	for i in range(3):
		draft.append(_roll_mod())
	return draft


func _roll_mod() -> ModData:
	var mod_type: ModType = _roll_mod_type()
	if mod_type == ModType.WEAPON_MOD:
		return _build_weapon_mod_data()
	var rarity: Rarity = _roll_rarity()
	return _build_player_mod_data(mod_type, rarity)


func _roll_rarity() -> Rarity:
	var number: float = randf()
	var acc: float = 0.0
	for i in range(1, _rarity_roulette.size()):
		acc += _rarity_roulette[i] + _player.luck_modifier
		if number < acc:
			return i
	print("UNKNOWN RARITY ROLLED")
	return Rarity.UNKNOWN


func _build_weapon_mod_data() -> ModData:
	var weapon: Weapon = _roll_weapon()
	match weapon:
		Weapon.DAGGER:
			return _build_dagger_mod_data()
		_:
			var mod_data: ModData = ModData.new()
			return mod_data


func _roll_weapon() -> Weapon:
	var player_weapons: Array[WeaponNode] = []
	for child in _player.get_children():
		if child.is_in_group("weapons"):
			player_weapons.append(child)
	var chosen_weapon: WeaponNode = player_weapons.pick_random()
	return _to_draft_weapon(chosen_weapon)


func _to_draft_weapon(weapon_node: WeaponNode) -> Weapon:
	if weapon_node is DaggerWeapon:
		return Weapon.DAGGER
	return Weapon.UNKNOWN


func _build_dagger_mod_data() -> ModData:
	var candidates: Array[DaggerMods] = []
	for dagger_mod in DaggerMods.values():
		if dagger_mod != DaggerMods.UNKNOWN:
			candidates.append(dagger_mod)
	var dagger_mod: DaggerMods = candidates.pick_random()
	match dagger_mod:
		DaggerMods.HITS:
			var mod_data: ModData = ModData.new()
			mod_data.effect = 1.0
			mod_data.mod_scene = HITS_DAGGER_MOD
			mod_data.weapon_name = "Dagger"
			mod_data.mod_name = "Hits"
			mod_data.description = "Dagger hits +1 enemy in its path"
			mod_data.rarity = Rarity.UNKNOWN
			mod_data.mod_type = ModType.WEAPON_MOD
			return mod_data
		_:
			return ModData.new()


func _build_player_mod_data(mod_type: ModType, rarity: Rarity) -> ModData:
	var effect: float
	var scene: PackedScene
	var description: String
	var mod_name: String
	match mod_type:
		ModType.COOLDOWN:
			effect = _config.mod_draft_config.cooldown_mod_percentages[rarity]
			scene = COOLDOWN_PLAYER_MOD
			mod_name = "Cooldown"
			description = "Reduces all cooldowns by %1.1f%%" % (effect * 100)
		ModType.DAMAGE:
			effect = _config.mod_draft_config.damage_mod_percentages[rarity]
			scene = DAMAGE_PLAYER_MOD
			mod_name = "Damage"
			description = "Increases all damage by %1.1f%%" % (effect * 100)
		ModType.SPEED:
			effect = _config.mod_draft_config.speed_mod_percentages[rarity]
			scene = SPEED_PLAYER_MOD
			mod_name = "Speed"
			description = "Increases character run speed by %1.1f%%" % (effect * 100)
		ModType.LUCK:
			effect = _config.mod_draft_config.luck_mod_percentages[rarity]
			scene = LUCK_PLAYER_MOD
			mod_name = "Luck"
			description = "Increases chance of finding higher quality mods and gear"
		ModType.VITALITY:
			effect = _config.mod_draft_config.vitality_mod_values[rarity]
			scene = VITALITY_PLAYER_MOD
			mod_name = "Vitality"
			description = "Increases the character's maximum health by %.0f points" % effect
		ModType.MAGNET:
			effect = _config.mod_draft_config.magnet_mod_percentages[rarity]
			scene = MAGNET_PLAYER_MOD
			mod_name = "Maget"
			description = "Increases the area where the character attracts XP by %1.1f%%" % (effect * 100)
		_:
			effect = 0.0
			scene = null
			mod_name = ""
			description = ""
	var mod_data: ModData = ModData.new()
	mod_data.effect = effect
	mod_data.mod_scene = scene
	mod_data.weapon_name = ""
	mod_data.mod_name = mod_name
	mod_data.description = description
	mod_data.rarity = rarity
	mod_data.mod_type = mod_type
	return mod_data

func _roll_mod_type():
	var idx: int = randi_range(0, all_mod_types.size() - 1)
	var aux: ModType = all_mod_types[0]
	all_mod_types[0] = all_mod_types[idx]
	all_mod_types[idx] = aux
	return all_mod_types.pop_front()
