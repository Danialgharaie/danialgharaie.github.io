# Danial Gharaie Amirabadi - Research Notebook

This repository contains the personal research notebook and academic website of Danial Gharaie Amirabadi, built using a minimal configuration of the `al-folio` Jekyll theme.

## Navigation Structure

- **About**: Homepage featuring candidate overview and research areas.
- **Notebook**: Collection of research notes and essays.
- **Projects**: Summary of active academic/computational projects.
- **CV**: Curriculum Vitae.
- **GitHub**: Redirect to GitHub profile.

---

## How to Run Locally

You can run the site locally using Docker/Podman to avoid installing Ruby dependencies directly.

### Prerequisites

- Docker or Podman
- Docker Compose or Podman Compose

### Build the Site Container

```bash
podman compose build
# or
docker-compose build
```

### Run the Development Server

```bash
podman compose up
# or
docker-compose up
```

Once started, the site will be available locally at [http://localhost:8080](http://localhost:8080) with automatic hot-reloading.

---

## How to Add Notebook Posts

To add a new notebook entry:

1. Create a new Markdown file in the `_posts/` directory.
2. Follow the filename convention: `YYYY-MM-DD-title-slug.md` (e.g., `2026-06-07-a-battle-against-brute-forcing-information-asymmetry.md`).
3. Add the following YAML front matter at the top:
   ```yaml
   ---
   layout: post
   title: "Your Post Title"
   date: YYYY-MM-DD
   category: notebook
   tags: tag1 tag2 tag3
   ---
   ```
4. Write the post body in Markdown format.

---

## How to Deploy

The site uses GitHub Actions to automate deployment to GitHub Pages.

1. Any changes pushed or merged into the `main` or `master` branches will trigger the `.github/workflows/deploy.yml` workflow.
2. The workflow installs Jekyll and Python dependencies, builds the production bundle, runs PurgeCSS to optimize styles, and deploys the output to the `gh-pages` branch.
3. Your site will automatically go live at `https://danialgharaie.github.io/`.
