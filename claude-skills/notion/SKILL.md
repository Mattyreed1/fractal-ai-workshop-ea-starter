---
name: notion
description: Notion operations via the Notion MCP server. Search pages, query databases, create + update pages, append blocks, manage properties. Use whenever the user mentions Notion, asks to "save to Notion", "find a page", "query my database", "update a property", or any read/write operation against their Notion workspace. Requires the `notion` MCP server configured (see SETUP section below if missing).
license: MIT
---

# Notion Operations

Skill for working with Notion via the Notion MCP server. Covers common operations + setup verification.

## Triggers

- "save to Notion" / "create a Notion page" / "add to Notion"
- "search Notion for X" / "find my Notion page about X"
- "query my [database name]" / "what's in my Tasks database"
- "update [property] on [page]"
- "what does Notion say about X"

## Prerequisites

The user needs:
1. A Notion account
2. An **Internal Integration Token** (from https://www.notion.so/my-integrations)
3. The `notion` MCP server configured in `~/.claude.json`
4. **Pages or databases shared with the integration** — otherwise queries return 404

If MCP isn't configured, run the `claude-code-setup` skill (or its setup section).

## Quick Reference — MCP Tools You'll Use

The Notion MCP server exposes tools prefixed `mcp__notion__API-*`. The most useful:

| Tool | Use case |
|------|----------|
| `API-post-search` | Find pages or databases by name |
| `API-retrieve-a-page` | Get a page's properties + metadata |
| `API-retrieve-a-database` | Get a DB's schema |
| `API-query-data-source` | Filter + sort rows in a database |
| `API-post-page` | Create a new page (in a workspace, parent page, or DB) |
| `API-patch-page` | Update a page's properties |
| `API-get-block-children` | Read the content blocks of a page |
| `API-patch-block-children` | Append blocks (text, headings, lists) to a page |
| `API-update-a-block` | Edit an existing block |
| `API-delete-a-block` | Remove a block |
| `API-retrieve-a-page-property` | Read one specific property of a page |

## Common Operations

### Find a page or database by name

```
API-post-search with { "query": "Project Notes", "filter": {"property": "object", "value": "page"} }
```

Use `"value": "database"` to filter for databases instead.

### Read a page's content

Two-step: retrieve metadata, then get blocks.

```
API-retrieve-a-page with page_id → metadata + properties
API-get-block-children with block_id (= page_id) → list of content blocks
```

If a page has nested blocks (e.g. toggle lists), recurse with `API-get-block-children` on each block ID that has `has_children: true`.

### Query a database (filter + sort)

```
API-query-data-source with database_id and a filter object:
{
  "filter": {
    "property": "Status",
    "select": { "equals": "In Progress" }
  },
  "sorts": [{"property": "Created", "direction": "descending"}],
  "page_size": 25
}
```

Filter property types must match the column type (`select`, `multi_select`, `checkbox`, `date`, `number`, `rich_text`, `title`, etc.).

### Create a new page in a database

```
API-post-page with {
  "parent": { "database_id": "<DB_ID>" },
  "properties": {
    "Name": { "title": [{ "text": { "content": "New entry" }}] },
    "Status": { "select": { "name": "Todo" }},
    "Tags": { "multi_select": [{"name": "work"}, {"name": "urgent"}] }
  }
}
```

The exact property structure depends on the column type. **Always retrieve the database schema first** (`API-retrieve-a-database`) if you don't know the column types.

### Update a property on an existing page

```
API-patch-page with page_id and { "properties": { "Status": { "select": { "name": "Done" }}}}
```

### Append content to a page

```
API-patch-block-children with block_id (= page_id) and:
{
  "children": [
    { "object": "block", "type": "heading_2", "heading_2": { "rich_text": [{"type": "text", "text": {"content": "Notes"}}]}},
    { "object": "block", "type": "paragraph", "paragraph": { "rich_text": [{"type": "text", "text": {"content": "..."}}]}}
  ]
}
```

Block types: `paragraph`, `heading_1`, `heading_2`, `heading_3`, `bulleted_list_item`, `numbered_list_item`, `to_do`, `toggle`, `code`, `quote`, `callout`, `divider`, `image`.

## Critical Gotchas

### Pages must be shared with the integration

If `API-retrieve-a-page` returns a 404, the page isn't shared. Tell the user:
> "I can't see that page. Open it in Notion → click the `...` menu → Connect to → select **Claude Code** (or whatever you named the integration). Then I'll be able to read it."

### Property names are case-sensitive

`"Status"` ≠ `"status"`. If a query fails with "property not found", retrieve the DB schema and copy the property name exactly.

### Page IDs vs database IDs vs block IDs

Notion uses UUIDs (with or without dashes) for everything. The same value works whether represented as `abc12345-...` or `abc12345...` — the API normalizes either form. A page's "block_id" is the same as its "page_id".

### Title properties are special

Every database has exactly one `title`-type property (often called "Name"). When creating a page, you MUST include a title — even if it's empty:
```json
"Name": { "title": [{ "text": { "content": "Untitled" }}]}
```

### Pagination

Search and query results are paginated. Default `page_size` is 100, max is 100. If `has_more: true` in the response, use the `next_cursor` value to get the next page.

### Don't dump entire pages into your context

Pages with lots of nested content can blow your context window. Read selectively — query the DB for what you need, retrieve only the specific page properties you care about, and only fetch block children when the user wants the actual page content.

## Workflow Patterns

### "Save this to Notion"

1. Ask the user: which page or database should it go in?
2. Search for the target (`API-post-search`)
3. If a database: ask which properties matter, build the payload, `API-post-page`
4. If a page: append blocks with `API-patch-block-children`
5. Confirm with the URL of the new/updated page

### "What's the status of X?"

1. Search for X (`API-post-search`)
2. Retrieve the page or DB row
3. Surface only the relevant properties
4. If they want details, fetch the page's blocks

### "Update [property] on [page]"

1. Search to confirm the page exists
2. Retrieve the page to know the current value + property type
3. Patch the property — match the type structure exactly
4. Confirm the update

### Daily / weekly summaries from a DB

1. Query the DB with a date filter (e.g. last 7 days)
2. Group/format results
3. Optionally write the summary back to a page (`API-post-page` or append blocks)

## Anti-Patterns

| Avoid | Why | Instead |
|-------|-----|---------|
| Guessing property names | Case sensitivity, plus the user might rename them | `API-retrieve-a-database` first, copy names exactly |
| Reading entire DBs into context | Burns context for no reason | Query with filters + `page_size` limits |
| Creating pages without a title property | Notion rejects the request | Always include a `title`-type property |
| Storing the integration token in plain text in messages | Security | Token lives in `~/.claude.json` env block only |
| Accessing pages the integration isn't connected to | Returns 404 silently confusing | Always confirm sharing first if a page isn't found |
| Recursing every block on every page | Slow + token-heavy | Only fetch block content when user asks for it |

## Verification

After setup, confirm everything works:

```
mcp__notion__API-get-self
```

Returns the integration's bot user info if the MCP is wired correctly. If this errors, the MCP server isn't connected — restart Claude Code, or run the `claude-code-setup` skill.

```
mcp__notion__API-post-search with empty query
```

Returns up to 100 pages and databases shared with the integration. If empty, no pages are shared yet — direct user to share a page first.

## Setup (if MCP not yet configured)

If the `notion` MCP server isn't in `~/.claude.json`, the user needs to:

1. Get an Internal Integration Token from https://www.notion.so/my-integrations
2. Add the server to `~/.claude.json`:

```json
{
  "mcpServers": {
    "notion": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@notionhq/notion-mcp-server"],
      "env": {
        "OPENAPI_MCP_HEADERS": "{\"Authorization\":\"Bearer ntn_...\",\"Notion-Version\":\"2022-06-28\"}"
      }
    }
  }
}
```

3. Restart Claude Code.

Or just run the `claude-code-setup` wizard, which handles all of this.
