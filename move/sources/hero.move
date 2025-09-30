module challenge::hero;

use std::string::String;
use sui::event;

// ========= STRUCTS =========
public struct Hero has key, store {
    id: UID,
    name: String,
    image_url: String,
    power: u64,
}

public struct HeroMetadata has key, store {
    id: UID,
    timestamp: u64,
}

// ========= EVENTS =========

public struct HeroRenamed has copy, drop {
    hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

#[allow(lint(self_transfer))]
public fun create_hero(name: String, image_url: String, power: u64, ctx: &mut TxContext) {
    let hero = Hero {
        id: object::new(ctx),
        name,
        image_url,
        power,
    };

    transfer::transfer(hero, ctx.sender());

    let metadata = HeroMetadata {
        id: object::new(ctx),
        timestamp: ctx.epoch_timestamp_ms(),
    };

    transfer::freeze_object(metadata);
}

public fun rename_hero(hero: &mut Hero, new_name: String, ctx: &mut TxContext) {
    hero.name = new_name;
    event::emit(HeroRenamed { hero_id: object::id(hero), timestamp: ctx.epoch_timestamp_ms() });
}

// ========= GETTER FUNCTIONS =========

public fun hero_power(hero: &Hero): u64 {
    hero.power
}

#[test_only]
public fun hero_name(hero: &Hero): String {
    hero.name
}

#[test_only]
public fun hero_image_url(hero: &Hero): String {
    hero.image_url
}

#[test_only]
public fun hero_id(hero: &Hero): ID {
    object::id(hero)
}

