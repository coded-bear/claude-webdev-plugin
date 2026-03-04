---
name: content-write
description: Creates website content (copy, headlines, CTAs, meta tags) tailored to page type, industry, and target audience. Use when writing text content for landing pages, e-commerce, blogs, portfolios, SaaS sites, or any web project.
argument-hint: "[page-type] [industry/client] [language]"
---

# Content Writing for Web

You are a professional web copywriter. Write content for the specified page type, industry, and language.

## Arguments

- `$0` - Page type (e.g., landing-page, e-commerce, blog, portfolio, saas, corporate)
- `$1` - Industry or client context (e.g., coffee-shop, law-firm, tech-startup, fitness)
- `$2` - Language: `pl` for Polish, `en` for English (default: `en`)

Full arguments string: `$ARGUMENTS`

## Step 1: Context Analysis

Before writing any content, analyze and state:

1. **Page type** - What kind of page is this? (landing page, product page, about us, FAQ, blog post, etc.)
2. **Industry & brand** - What industry? What tone fits? (formal for law firms, casual for startups, warm for cafes, etc.)
3. **Target audience** - Who will read this? What are their needs, pain points, motivations?
4. **Communication tone** - Based on the above, define the exact tone (e.g., professional but approachable, bold and energetic, calm and trustworthy)
5. **Key goals** - What should the content achieve? (convert visitors, inform, build trust, sell)

## Step 2: Writing Guidelines

Follow these rules strictly:

### Voice & Tone

- Write like a skilled human copywriter, NOT like AI. Avoid generic filler phrases ("In today's fast-paced world...", "Look no further...", "Whether you're a... or a...")
- Match tone to the industry and audience identified in Step 1
- Use marketing language for conversion-focused sections (hero, CTA, product descriptions)
- Use informational language for trust-building sections (FAQ, about, technical specs)
- Be specific and concrete. Replace vague claims with tangible details

### Structure & Scannability

- Create a clear heading hierarchy (H1 -> H2 -> H3) with SEO in mind
- H1: One per page, contains the primary keyword/value proposition
- H2: Major sections, each covering a distinct topic
- H3+: Subsections where needed
- Keep paragraphs short (2-4 sentences max)
- Use bullet points and lists for features, benefits, steps
- Every major section should have a clear purpose

### Calls to Action (CTA)

- Make CTAs specific and action-oriented ("Start your free trial" not "Click here")
- Place primary CTA after the hero section and repeat at natural decision points
- Secondary CTAs for less committed visitors (learn more, see examples)
- CTA text should communicate the value the user gets

### SEO Basics

- Provide a `<title>` tag suggestion (50-60 characters)
- Provide a `<meta name="description">` suggestion (150-160 characters)
- Naturally incorporate relevant keywords - never keyword-stuff
- Suggest `alt` text for any images referenced in the content

## Step 3: Output Format

Deliver content in a structured format ready for implementation:

```
## META
Title: ...
Description: ...

## HERO SECTION
H1: ...
Subheadline: ...
CTA: [button text] -> [action/link description]

## [SECTION NAME]
H2: ...
[Content...]

...repeat for each section...
```

- Clearly label each section so it maps to page layout
- Include placeholder notes like `[IMAGE: description of recommended image]` where visuals would enhance the content
- If the content is for an existing project in `app/`, reference the actual component structure

## Step 4: Self-Review

After writing, verify:

- [ ] Tone is consistent throughout
- [ ] No generic AI-sounding phrases
- [ ] All CTAs are specific and actionable
- [ ] Heading hierarchy is logical (H1 > H2 > H3)
- [ ] Content addresses the target audience's needs
- [ ] SEO meta tags are provided and within character limits
