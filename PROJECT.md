# Project

This file is public. Do not include personal context, private goals, names of
people from the vault, health information, private decisions, or local vault
paths.

**Last updated:** 2026-10-07  
**Status:** active  
**Type:** other

## Goal

A watch app for the person picking up known surplus food from a nearby restaurant. She swipes between a map of the closest restaurants and each listing. Every pickup has the same small price. From the listing she is looking at, a simulated Wallet sheet takes that price. Nothing is charged. That same listing then becomes ready to show at the counter.

## Done when

- The watch shows the map and the three nearest listings, in order of distance.
- Swiping left and right moves between those pages.
- Each listing shows the dish, the restaurant, the walk time, the same price, and a pay button.
- The pay button opens a sheet with the price and one card. Confirming it turns that listing into the ready state on the same page.
- When nothing is nearby, the map says so and there is nothing to swipe to.

## Current state

Cerca runs on the watch. It opens with a splash, then the map and the three listings. Each listing has an Apple Pay button that opens a simulated sheet for S/ 8.50. Confirming the sheet marks that listing ready. Nothing is charged.

## Next action

Use the flow on the watch simulator: swipe, pay, dismiss, and confirm.

## Links

- Production:
- Documentation:
