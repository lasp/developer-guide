# How to write technical documentation

## Overview/main goals

The main goals of our technical documentation are:

- **Be clear**: Documentation should be easy to read and understand, with acronyms defined and referenced information linked out
- **Be findable**: Documentation pages should be in a logical location, with clear focus and scope, and an accurate title
- **Be in existence**: Documentation should be created, rather than not. This also means that it should be easy to write documentation, without excessive requirements, rules, or expectations 
- **Be accurate**: This goal is aided by the first two goals, but it also requires a team commitment to remove or correct inaccurate documentation. It is better to have no documentation than it is to have inaccurate documentation, so delete anything you see that is wrong. 

This documentation should be focused on internal team members, without worrying about external partners, but it should also be easy to read for even new team members who have very little context or background knowledge.

## Rules and Best Practices

- Documentation pages should be short and refined in scope. This helps with goals 1 + 2, by making each piece of information in a page directly related to the title, and to make linking information in other pages easier. 
- Be cautious about adding additional broad categories or top-level pages. This helps with goal 2, by making sure it is easy to start a search at a high level and dig down. Try to keep organization flat.
- In existence is better than perfect. A documentation page doesn't need to be complete. It doesn't need to cover every piece of information. Having an incomplete page is better than no page. This ties into rule 3. If you aren't sure about something, write it down anyway and note that.
- If you're writing out a long explanation or context, make a docs page and link it instead. Instead of having broader context, technical designs, or frequently asked questions scattered across the ephemeral world of tickets, slack messages, and emails, create it once and link it from then on.
- It should be easy to create documentation. This ties into rule 3 and 1. It should be easy to create documentation, without excessive requirements or rules either from the team or from yourself. 
- Correct or remove outdated information as you find it. The other side of making documentation easy to write is making it easy to remove. Every team member should feel empowered to move, edit, or delete any and all pages. Again, missing information is preferable to inaccurate documentation. All documentation is ephemeral. 
- Reduce the amount of duplicate information. Writing something down in multiple places makes it more difficult to find, and makes it harder to correct. Ways to reduce this happening are 1) keeping pages short 2) linking instead of making subsections and 3) combining pages if you do find duplicates.
- Avoid "misc" or catch-all pages or places. These make finding and organizing information very difficult.

## Types of Pages

This is a brief description of some of the pages that you may find or create within this sphere. Not every page neatly fits into these categories and they are not prescriptive.

### Overview Pages

These are basic descriptions of the world as it is. This could describe relationships with external partners, background on the mission, documentation on the existing design of infrastructure. Resist the urge to make this too detailed - it shouldn't replace documentation of the code, but should instead act as an easy place to point people if they ask questions like - "what is the camera radiometry? What is it doing? When should it be used?"

### Flow diagrams

Similarly to overview pages, these are images or flow diagrams which supplement overview pages. These can be a powerful visualization for difficult to convey information. 

### How-to pages

These are descriptions of how to accomplish a specific task. This might include "how to open a pull request" or "how to fix this specific bug"

### Design Documents and Whitepapers

These are documents which describe some proposed future work or a future design. They can be as detailed as including a complete description of future work and the roadmap to get there, or as simple as a comparison between two technologies or a proposed solution for a problem. The key factor is that they are for future work, and therefore, should try to avoid descriptions of existing designs. Rather, they should link out to existing overview pages, to reduce duplicate work and ensure that any new information is not lost once the design doc is complete and no longer used.
