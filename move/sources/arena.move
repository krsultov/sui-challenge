module challenge::arena;

use challenge::hero::{Self as hero, Hero};
use sui::event;

// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: ID,
    loser_hero_id: ID,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {
    let arena = Arena {
        id: object::new(ctx),
        warrior: hero,
        owner: ctx.sender(),
    };

    event::emit(ArenaCreated { arena_id: object::id(&arena), timestamp: ctx.epoch_timestamp_ms() });

    transfer::share_object(arena);
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    let Arena { id, warrior, owner } = arena;

    if (hero::hero_power(&hero) >= hero::hero_power(&warrior)) {
        // the hero wins
        let winner_id = object::id(&hero);
        let loser_id = object::id(&warrior);
        transfer::public_transfer(hero, ctx.sender());
        transfer::public_transfer(warrior, ctx.sender());
        event::emit(ArenaCompleted { winner_hero_id: winner_id, loser_hero_id: loser_id, timestamp: ctx.epoch_timestamp_ms() });
    } else {
        // the warrior wins
        let winner_id = object::id(&warrior);
        let loser_id = object::id(&hero);
        transfer::public_transfer(hero, owner);
        transfer::public_transfer(warrior, owner);
        event::emit(ArenaCompleted { winner_hero_id: winner_id, loser_hero_id: loser_id, timestamp: ctx.epoch_timestamp_ms() });
    };

    object::delete(id);
}

