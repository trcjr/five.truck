# Contributing

## 🖼 Image Metadata Policy

To protect personal and sensitive data, we enforce EXIF metadata sanitation on all image assets committed to this repository.

Before pushing any changes:
- Run `pre-commit install` once after cloning to enable automatic checks.
- Do **not** commit images with GPS data, camera model information, or timestamps.
- If a commit is blocked, re-stage the cleaned file using `git add`.

To manually check or clean image metadata:

```bash
# Check all staged images for metadata
make check-exif

# Strip metadata from all staged images
make strip-exif
```

The CI and pre-commit hooks will enforce this automatically.
