---
name: developer-growth-analysis
description: Analyzes your recent Claude Code and OpenCode chat history to identify coding patterns, development gaps, and areas for improvement, curates relevant learning resources from HackerNews, and automatically sends a personalized growth report to your Slack DMs.
---

# Developer Growth Analysis

This skill provides personalized feedback on your recent coding work by analyzing your **Claude Code** and **OpenCode** chat interactions and identifying patterns that reveal strengths and areas for growth.

## Supported History Sources

This skill reads from two AI coding assistant history formats:

| Source | Location | Format |
|--------|----------|--------|
| **Claude Code** | `~/.claude/history.jsonl` | Single JSONL file |
| **OpenCode** | `~/.local/share/opencode/storage/` | Multiple JSON files |

The skill will automatically detect and read from both sources when available, combining the data for a comprehensive analysis.

## When to Use This Skill

Use this skill when you want to:

- Understand your development patterns and habits from recent work
- Identify specific technical gaps or recurring challenges
- Discover which topics would benefit from deeper study
- Get curated learning resources tailored to your actual work patterns
- Track improvement areas across your recent projects
- Find high-quality articles that directly address the skills you're developing

This skill is ideal for developers who want structured feedback on their growth without waiting for code reviews, and who prefer data-driven insights from their own work history.

## What This Skill Does

This skill performs a six-step analysis of your development work:

1. **Reads Your Chat History**: Accesses your local **Claude Code** and **OpenCode** chat history from the past 24-48 hours to understand what you've been working on. Data from both sources is combined for comprehensive analysis.

2. **Identifies Development Patterns**: Analyzes the types of problems you're solving, technologies you're using, challenges you encounter, and how you approach different kinds of tasks.

3. **Detects Improvement Areas**: Recognizes patterns that suggest skill gaps, repeated struggles, inefficient approaches, or areas where you might benefit from deeper knowledge.

4. **Generates a Personalized Report**: Creates a comprehensive report showing your work summary, identified improvement areas, and specific recommendations for growth.

5. **Finds Learning Resources**: Uses HackerNews to curate high-quality articles and discussions directly relevant to your improvement areas, providing you with a reading list tailored to your actual development work.

6. **Sends to Your Slack DMs**: Automatically delivers the complete report to your own Slack direct messages so you can reference it anytime, anywhere.

## How to Use

Ask Claude to analyze your recent coding work:

```
Analyze my developer growth from my recent chats
```

Or be more specific about which time period:

```
Analyze my work from today and suggest areas for improvement
```

The skill will generate a formatted report with:

- Overview of your recent work
- Key improvement areas identified
- Specific recommendations for each area
- Curated learning resources from HackerNews
- Action items you can focus on

## Instructions

When a user requests analysis of their developer growth or coding patterns from recent work:

1. **Access Chat History (Both Sources)**

   Read chat history from **both** Claude Code and OpenCode sources when available:

   ### Source A: Claude Code (`~/.claude/history.jsonl`)

   This file is a JSONL format where each line contains:

   - `display`: The user's message/request
   - `project`: The project being worked on
   - `timestamp`: Unix timestamp (in milliseconds)
   - `pastedContents`: Any code or content pasted

   ### Source B: OpenCode (`~/.local/share/opencode/storage/`)

   OpenCode uses a directory-based structure with multiple JSON files:

   ```
   ~/.local/share/opencode/storage/
   ├── session/                    # Session metadata
   │   ├── global/                 # Global sessions (no specific project)
   │   │   └── ses_*.json
   │   └── {project_hash}/         # Project-specific sessions
   │       └── ses_*.json
   ├── message/                    # Conversation messages
   │   └── ses_*/                  # One folder per session
   │       └── msg_*.json          # Individual messages
   └── part/                       # Message content parts
   ```

   **Session files** (`ses_*.json`) contain:
   ```json
   {
     "id": "ses_xxx",
     "version": "0.9.11",
     "projectID": "global" | "{project_hash}",
     "directory": "/path/to/project",
     "title": "Session title describing the work",
     "time": {
       "created": 1758248495226,  // Unix timestamp in ms
       "updated": 1758248784627
     }
   }
   ```

   **Message files** (`msg_*.json`) contain:
   ```json
   {
     "id": "msg_xxx",
     "sessionID": "ses_xxx",
     "role": "user" | "assistant",
     "time": { "created": 1767029604694 },
     "summary": {
       "title": "Brief title of what was done",
       "body": "Longer description of the work",
       "diffs": [
         {
           "file": "path/to/file.ts",
           "before": "...",
           "after": "...",
           "additions": 218,
           "deletions": 0
         }
       ]
     },
     "agent": "general",
     "model": {
       "providerID": "anthropic",
       "modelID": "claude-sonnet-4-20250514"
     }
   }
   ```

   ### Reading Strategy

   1. **Check both sources exist**:
      - Claude Code: Check if `~/.claude/history.jsonl` exists
      - OpenCode: Check if `~/.local/share/opencode/storage/session/` exists

   2. **Filter by time**: For each source, filter entries from the past 24-48 hours based on:
      - Claude Code: `timestamp` field
      - OpenCode: `time.created` or `time.updated` in session/message files

   3. **For OpenCode**, iterate through:
      - First, read session files to get recent sessions
      - Then, read corresponding message files from `message/ses_*/` directories
      - Extract `summary.title`, `summary.body`, and `summary.diffs` for context

   4. **Combine data** from both sources into a unified analysis dataset

2. **Analyze Work Patterns**

   Extract and analyze the following from the filtered chats (combining both sources):

   - **Projects and Domains**: What types of projects was the user working on? (e.g., backend, frontend, DevOps, data, etc.)
     - From Claude Code: Use `project` field
     - From OpenCode: Use `directory` field in sessions and file paths in `summary.diffs`
   - **Technologies Used**: What languages, frameworks, and tools appear in the conversations?
     - From Claude Code: Parse `display` and `pastedContents`
     - From OpenCode: Analyze file extensions in `summary.diffs`, parse `summary.body`
   - **Problem Types**: What categories of problems are being solved? (e.g., performance optimization, debugging, feature implementation, refactoring, setup/configuration)
   - **Code Changes**: Analyze the actual code modifications
     - From OpenCode: Use `summary.diffs` with `additions`, `deletions`, `before`, and `after` content
   - **Challenges Encountered**: What problems did the user struggle with? Look for:
     - Repeated questions about similar topics
     - Problems that took multiple attempts to solve
     - Questions indicating knowledge gaps
     - Complex architectural decisions
     - Multiple iterations on the same file (visible in OpenCode diffs)
   - **Approach Patterns**: How does the user solve problems? (e.g., methodical, exploratory, experimental)
   - **Models Used** (OpenCode only): Track which AI models were used via `model.modelID`

3. **Identify Improvement Areas**

   Based on the analysis, identify 3-5 specific areas where the user could improve. These should be:

   - **Specific** (not vague like "improve coding skills")
   - **Evidence-based** (grounded in actual chat history)
   - **Actionable** (practical improvements that can be made)
   - **Prioritized** (most impactful first)

   Examples of good improvement areas:

   - "Advanced TypeScript patterns (generics, utility types, type guards) - you struggled with type safety in [specific project]"
   - "Error handling and validation - I noticed you patched several bugs related to missing null checks"
   - "Async/await patterns - your recent work shows some race conditions and timing issues"
   - "Database query optimization - you rewrote the same query multiple times"

4. **Generate Report**

   Create a comprehensive report with this structure:

   ```markdown
   # Your Developer Growth Report

   **Report Period**: [Yesterday / Today / [Custom Date Range]]
   **Last Updated**: [Current Date and Time]

   ## Work Summary

   [2-3 paragraphs summarizing what the user worked on, projects touched, technologies used, and overall focus areas]

   Example:
   "Over the past 24 hours, you focused primarily on backend development with three distinct projects. Your work involved TypeScript, React, and deployment infrastructure. You tackled a mix of feature implementation, debugging, and architectural decisions, with a particular focus on API design and database optimization."

   ## Improvement Areas (Prioritized)

   ### 1. [Area Name]

   **Why This Matters**: [Explanation of why this skill is important for the user's work]

   **What I Observed**: [Specific evidence from chat history showing this gap]

   **Recommendation**: [Concrete step(s) to improve in this area]

   **Time to Skill Up**: [Brief estimate of effort required]

   ---

   [Repeat for 2-4 additional areas]

   ## Strengths Observed

   [2-3 bullet points highlighting things you're doing well - things to continue doing]

   ## Action Items

   Priority order:

   1. [Action item derived from highest priority improvement area]
   2. [Action item from next area]
   3. [Action item from next area]

   ## Learning Resources

   [Will be populated in next step]
   ```

5. **Search for Learning Resources**

   Use Rube MCP to search HackerNews for articles related to each improvement area:

   - For each improvement area, construct a search query targeting high-quality resources
   - Search HackerNews using RUBE_SEARCH_TOOLS with queries like:
     - "Learn [Technology/Pattern] best practices"
     - "[Technology] advanced patterns and techniques"
     - "Debugging [specific problem type] in [language]"
   - Prioritize posts with high engagement (comments, upvotes)
   - For each area, include 2-3 most relevant articles with:
     - Article title
     - Publication date
     - Brief description of why it's relevant
     - Link to the article

   Add this section to the report:

   ```markdown
   ## Curated Learning Resources

   ### For: [Improvement Area]

   1. **[Article Title]** - [Date]
      [Description of what it covers and why it's relevant to your improvement area]
      [Link]

   2. **[Article Title]** - [Date]
      [Description]
      [Link]

   [Repeat for other improvement areas]
   ```

6. **Present the Complete Report**

   Deliver the report in a clean, readable format that the user can:

   - Quickly scan for key takeaways
   - Use for focused learning planning
   - Reference over the next week as they work on improvements
   - Share with mentors if they want external feedback

7. **Send Report to Slack DMs**

   Use Rube MCP to send the complete report to the user's own Slack DMs:

   - Check if Slack connection is active via RUBE_SEARCH_TOOLS
   - If not connected, use RUBE_MANAGE_CONNECTIONS to initiate Slack auth
   - Use RUBE_MULTI_EXECUTE_TOOL to send the report as a formatted message:
     - Send the report title and period as the first message
     - Break the report into logical sections (Summary, Improvements, Strengths, Actions, Resources)
     - Format each section as a well-structured Slack message with proper markdown
     - Include clickable links for the learning resources
   - Confirm delivery in the CLI output

   This ensures the user has the report in a place they check regularly and can reference it throughout the week.

## Example Usage

### Input

```
Analyze my developer growth from my recent chats
```

### Output

```markdown
# Your Developer Growth Report

**Report Period**: November 9-10, 2024
**Last Updated**: November 10, 2024, 9:15 PM UTC

## Work Summary

Over the past two days, you focused on backend infrastructure and API development. Your primary project was an open-source showcase application, where you made significant progress on connections management, UI improvements, and deployment configuration. You worked with TypeScript, React, and Node.js, tackling challenges ranging from data security to responsive design. Your work shows a balance between implementing features and addressing technical debt.

## Improvement Areas (Prioritized)

### 1. Advanced TypeScript Patterns and Type Safety

**Why This Matters**: TypeScript is central to your work, but leveraging its advanced features (generics, utility types, conditional types, type guards) can significantly improve code reliability and reduce runtime errors. Better type safety catches bugs at compile time rather than in production.

**What I Observed**: In your recent chats, you were working with connection data structures and struggled a few times with typing auth configurations properly. You also had to iterate on union types for different connection states. There's an opportunity to use discriminated unions and type guards more effectively.

**Recommendation**: Study TypeScript's advanced type system, particularly utility types (Omit, Pick, Record), conditional types, and discriminated unions. Apply these patterns to your connection configuration handling and auth state management.

**Time to Skill Up**: 5-8 hours of focused learning and practice

### 2. Secure Data Handling and Information Hiding in UI

**Why This Matters**: You identified and fixed a security concern where sensitive connection data was being displayed in your console. Preventing information leakage is critical for applications handling user credentials and API keys. Good practices here prevent security incidents and user trust violations.

**What I Observed**: You caught that your "Your Apps" page was showing full connection data including auth configs. This shows good security instincts, and the next step is building this into your default thinking when handling sensitive information.

**Recommendation**: Review security best practices for handling sensitive data in frontend applications. Create reusable patterns for filtering/masking sensitive information before displaying it. Consider implementing a secure data layer that explicitly whitelist what can be shown in the UI.

**Time to Skill Up**: 3-4 hours

### 3. Component Architecture and Responsive UI Patterns

**Why This Matters**: You're designing UIs that need to work across different screen sizes and user interactions. Strong component architecture makes it easier to build complex UIs without bugs and improves maintainability.

**What I Observed**: You worked on the "Marketplace" UI (formerly Browse Tools), recreating it from a design image. You also identified and fixed scrolling issues where content was overflowing containers. There's an opportunity to strengthen your understanding of layout containment and responsive design patterns.

**Recommendation**: Study React component composition patterns and CSS layout best practices (especially flexbox and grid). Focus on container queries and responsive patterns that prevent overflow issues. Look into component composition libraries and design system approaches.

**Time to Skill Up**: 6-10 hours (depending on depth)

## Strengths Observed

- **Security Awareness**: You proactively identified data leakage issues before they became problems
- **Iterative Refinement**: You worked through UI requirements methodically, asking clarifying questions and improving designs
- **Full-Stack Capability**: You comfortably work across backend APIs, frontend UI, and deployment concerns
- **Problem-Solving Approach**: You break down complex tasks into manageable steps

## Action Items

Priority order:

1. Spend 1-2 hours learning TypeScript utility types and discriminated unions; apply to your connection data structures
2. Document security patterns for your project (what data is safe to display, filtering/masking functions)
3. Study one article on advanced React patterns and apply one pattern to your current UI work
4. Set up a code review checklist focused on type safety and data security for future PRs

## Curated Learning Resources

### For: Advanced TypeScript Patterns

1. **TypeScript's Advanced Types: Generics, Utility Types, and Conditional Types** - HackerNews, October 2024
   Deep dive into TypeScript's type system with practical examples and real-world applications. Covers discriminated unions, type guards, and patterns for ensuring compile-time safety in complex applications.
   [Link to discussion]

2. **Building Type-Safe APIs in TypeScript** - HackerNews, September 2024
   Practical guide to designing APIs with TypeScript that catch errors early. Particularly relevant for your connection configuration work.
   [Link to discussion]

### For: Secure Data Handling in Frontend

1. **Preventing Information Leakage in Web Applications** - HackerNews, August 2024
   Comprehensive guide to data security in frontend applications, including filtering sensitive information, secure logging, and audit trails.
   [Link to discussion]

2. **OAuth and API Key Management Best Practices** - HackerNews, July 2024
   How to safely handle authentication tokens and API keys in applications, with examples for different frameworks.
   [Link to discussion]

### For: Component Architecture and Responsive Design

1. **Advanced React Patterns: Composition Over Configuration** - HackerNews
   Explores component composition strategies that scale, with examples using modern React patterns.
   [Link to discussion]

2. **CSS Layout Mastery: Flexbox, Grid, and Container Queries** - HackerNews, October 2024
   Learn responsive design patterns that prevent overflow issues and work across all screen sizes.
   [Link to discussion]
```

## Tips and Best Practices

- Run this analysis once a week to track your improvement trajectory over time
- Pick one improvement area at a time and focus on it for a few days before moving to the next
- Use the learning resources as a study guide; work through the recommended materials and practice applying the patterns
- Revisit this report after focusing on an area for a week to see how your work patterns change
- The learning resources are intentionally curated for your actual work, not generic topics, so they'll be highly relevant to what you're building

## How Accuracy and Quality Are Maintained

This skill:

- Analyzes your actual work patterns from timestamped chat history (both Claude Code and OpenCode)
- Combines data from multiple AI coding assistants for comprehensive coverage
- Uses OpenCode's detailed `summary.diffs` for precise code change analysis
- Generates evidence-based recommendations grounded in real projects
- Curates learning resources that directly address your identified gaps
- Focuses on actionable improvements, not vague feedback
- Provides specific time estimates based on complexity
- Prioritizes areas that will have the most impact on your development velocity

## Troubleshooting

### No history found

If the skill reports no history:

1. **Claude Code**: Verify `~/.claude/history.jsonl` exists and contains recent entries
2. **OpenCode**: Verify `~/.local/share/opencode/storage/session/` contains recent `ses_*.json` files

### Missing data from one source

The skill works with whatever sources are available. If only one source has data, the analysis will still run using that source alone.

### Timestamps seem off

Both tools use Unix timestamps in milliseconds. The skill filters for the past 24-48 hours from the current time. Ensure your system clock is accurate.
