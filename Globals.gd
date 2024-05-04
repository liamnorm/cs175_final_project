extends Node

var Map = []

var textures = {}

const DIMENSION = Vector3(16, 64, 16)
const TEXTURE_ATLAS_SIZE = Vector2(8,2)

enum {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
	FRONT,
	BACK,
	SOLID,
}

enum {
	AIR,
	DIRT,
	GRASS,
	STONE,
	YELLOW_TILE,
	RED_TILE,
	WOOD,
	WOOD_PLANK,
	WATER,
	PLANT
}


const grass_top = Vector2(1,0)
const grass_side = Vector2(2,0)
const dirt_face = Vector2(3,0)
const stone_face = Vector2(4,0)
const yellow_tile_face = Vector2(5,0)
const red_tile_face = Vector2(6,0)
const wood_side = Vector2(7,0)
const wood_top = Vector2(0,1)
const wood_plank_face = Vector2(1,1)
const water_face = Vector2(3,1)


const types = {
	AIR: {
		SOLID:false,
	},
	DIRT: {
		TOP:dirt_face, BOTTOM:dirt_face, LEFT:dirt_face,
		RIGHT:dirt_face, FRONT:dirt_face, BACK:dirt_face,
		SOLID:true,
	},
	GRASS: {
		TOP:grass_top, BOTTOM:dirt_face, LEFT:grass_side,
		RIGHT:grass_side, FRONT:grass_side, BACK:grass_side,
		SOLID:true,
	},
	STONE: {
		TOP:stone_face, BOTTOM:stone_face, LEFT:stone_face,
		RIGHT:stone_face, FRONT:stone_face, BACK:stone_face,
		SOLID:true,
	},
	YELLOW_TILE: {
		TOP:yellow_tile_face, BOTTOM:yellow_tile_face, LEFT:yellow_tile_face,
		RIGHT:yellow_tile_face, FRONT:yellow_tile_face, BACK:yellow_tile_face,
		SOLID:true,
	},
	RED_TILE: {
		TOP:red_tile_face, BOTTOM:red_tile_face, LEFT:red_tile_face,
		RIGHT:red_tile_face, FRONT:red_tile_face, BACK:red_tile_face,
		SOLID:true,
	},
	WOOD: {
		TOP:wood_top, BOTTOM:wood_top, LEFT:wood_side,
		RIGHT:wood_side, FRONT:wood_side, BACK:wood_side,
		SOLID:true,
	},
	WOOD_PLANK: {
		TOP:wood_plank_face, BOTTOM:wood_plank_face, LEFT:wood_plank_face,
		RIGHT:wood_plank_face, FRONT:wood_plank_face, BACK:wood_plank_face,
		SOLID:true,
	},
	WATER: {
		TOP:water_face, BOTTOM:water_face, LEFT:water_face,
		RIGHT:water_face, FRONT:water_face, BACK:water_face,
		SOLID:true,
	},
	PLANT: {
		SOLID:false,
		TOP:Vector2(2,1)
	}
}
