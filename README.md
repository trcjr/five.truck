# 🛻 five.truck

## 🛻 Project Overview

**five.truck** is a Hugo-based static site designed to provide a seamless workflow for content creation, preview, and deployment. The project’s goal is to enable efficient local development and continuous deployment to GitHub Pages, with a focus on simplicity, speed, and customization. Using Hugo’s powerful static site generation capabilities combined with the PaperMod theme, five.truck offers a modern, clean, and responsive website ideal for blogs, documentation, or personal projects.

---

## 📦 Project Structure

- `public/` – Build output directory where the generated static site files are placed.
- `content/` – Markdown posts and pages; your site’s actual content lives here.
- `layouts/` – Custom templates and overrides to extend or modify the theme’s default layouts.
- `themes/` – Contains the PaperMod theme (or any other theme you choose to add).
- `Makefile` – Automation commands for building, serving, linting, and publishing the site.
- `.github/workflows/` – GitHub Actions CI pipelines that automate testing and deployment.

---

## 🔧 What is Hugo? Why PaperMod?

**Hugo** is a fast and flexible static site generator written in Go. It allows you to write content in Markdown and generate a complete website with optimized HTML, CSS, and JavaScript, without needing a backend server.

**PaperMod** is a popular Hugo theme known for its clean design, lightweight footprint, and extensive customization options. In five.truck, PaperMod is used as the base theme, with optional customizations in the `layouts/` folder to tailor the site’s look and behavior to your needs.

---

## 🛠️ Makefile Commands

The Makefile provides convenient commands to manage your site lifecycle. Here’s what each target does:

### 🚧 Development

- `make serve`  
  Starts a local Hugo development server at `http://localhost:1313/`, enabling live reload on content or template changes. This is ideal for previewing your site as you work.

- `make build`  
  Builds the complete static site into the `public/` directory. Useful for generating production-ready files without serving them locally.

### 📝 Content Management

- `make new title="My Post Title"`  
  Creates a new Markdown post in `content/posts/` with today’s date and a slugified version of the provided title. This helps maintain consistent naming and organization.

### 🧹 Maintenance

- `make clean`  
  Removes the `public/` directory and any temporary files, ensuring a fresh build environment.

- `make lint`  
  Runs linters or format checks on your Markdown and configuration files to catch errors or style inconsistencies early.

- `make validate`  
  Validates the Hugo site configuration and content to detect broken links, missing metadata, or other issues that could break the build or site behavior.

### 🚀 Deployment

- `make ci-deploy-main`  
  Used by GitHub Actions to build and deploy the site automatically when changes are pushed to the `main` branch. It builds the site with `baseURL: /` and publishes the contents of `public/` to the root of the `gh-pages` branch, which GitHub Pages serves.

---

## 🔁 CI Pipelines (GitHub Actions)

### ✅ Main Deployment Pipeline (`.github/workflows/deploy-main.yml`)

This workflow triggers on every push to the `main` branch and includes the following jobs:

- **Checkout**: Pulls the latest code from the repository.
- **Setup Hugo**: Installs the Hugo version specified for the project to ensure consistent builds.
- **Build Site**: Runs `make build` to generate the static site files.
- **Deploy**: Pushes the generated site to the `gh-pages` branch at the root (`/`), making the site live on GitHub Pages.

This pipeline ensures that every change pushed to `main` is automatically built and deployed, keeping the live site up to date without manual intervention.

---

## 💻 Local Development Workflow

To develop and preview the site locally, follow these steps:

1. **Ensure Hugo is installed**  
   The project requires Hugo version 0.111.3 or higher for compatibility with PaperMod and build features.

2. **Run the development server**  
   Execute `make serve` to start the local server at `http://localhost:1313/`. The server supports live reload for instant feedback on changes.

3. **Create new content**  
   Use `make new title="Your Post Title"` to scaffold new posts with proper filenames and front matter.

4. **Build the site manually**  
   Run `make build` when you want to generate the static files without serving them, useful for testing production builds or deploying manually.

5. **Clean build artifacts**  
   Use `make clean` to remove generated files and ensure a fresh build environment.

---

## 📄 Custom 404 Page

To provide a friendly user experience for not-found pages:

- Create or customize the 404 page at `layouts/404.html`.  
- Hugo automatically emits this as `static/404.html` during the build process, which GitHub Pages serves when a page is missing.

**Testing locally:**  
When running `make serve`, visit a non-existent URL (e.g., `http://localhost:1313/nonexistent`) to verify your 404 page renders correctly.

---

## ❗ Troubleshooting

Here are some common issues and tips to resolve them:

- **CSS not applying or site looks broken**  
  - Ensure the `baseURL` is set correctly in `config.toml` or during build. For local dev, it should be `/`. For GitHub Pages, it might need to be your repository URL if not deploying to root.
  - Clear browser cache or try a hard refresh.

- **Build fails or errors during deployment**  
  - Check Hugo version compatibility.
  - Run `make lint` and `make validate` to catch configuration or content errors.
  - Review GitHub Actions logs for detailed error messages.

- **New posts not appearing**  
  - Confirm the post file is saved in the correct directory (`content/posts/`).
  - Verify front matter metadata is complete and valid.
  - Run `make build` or restart the server.

---

## 📚 Resources

- [Hugo Documentation](https://gohugo.io/documentation/) – Official Hugo docs for site generation and configuration.
- [PaperMod Theme](https://adityatelange.github.io/hugo-PaperMod/) – Documentation and customization options for the PaperMod theme.

---

## 🪪 License

This project is licensed under the [MIT License](LICENSE). Feel free to use, modify, and distribute it as you like.

---

## 🤝 Contributing

Contributions are welcome! Please open issues or pull requests for bug fixes, enhancements, or documentation improvements. Before contributing, please review the [CONTRIBUTING.md](CONTRIBUTING.md) guidelines (to be added) for details on the process.

---

🧃 Built with joy by [@trcjr](https://github.com/trcjr)