# Install Git version control system using Alpine Package Keeper (apk)
# This command adds the git package without caching the package index locally,
# which helps reduce the Docker image size when used in containers.
# The --no-cache flag prevents apk from storing downloaded package files.
#

apk add --no-cache git