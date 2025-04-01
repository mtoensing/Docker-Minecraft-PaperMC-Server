# Simplify container with fixed UID/GID

This PR makes the following changes:

1. Removes the entrypoint script entirely, simplifying container startup
2. Creates a fixed minecraft user (UID/GID 9001/9001) during image build
3. Runs container processes as that user from the start
4. Adds instructions for handling data directory permissions with busybox
5. Preserves all functionality from environment variables (JAVAFLAGS, MEMORYSIZE, PAPERMC_FLAGS)

## Benefits:
- Faster container startup (no runtime user creation/verification)
- Less complicated/more predictable permissions model
- Reduced use of chown operations during runtime
- Better security by running as non-root throughout

## Migration:
For existing users who need to fix permissions on their data directories:
```sh
docker run --rm -v /path/to/your/data:/data busybox chown -R 9001:9001 /data
```

This ensures backwards compatibility while providing a simpler approach going forward.
