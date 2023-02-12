#!/bin/sh

# Load all environment variables from 'attributes.sh' using the command 'source /path/attributes.sh'
source "docker/attributes.sh"

# This condition creates the Unix socket if 'php-fpm8.sock' does not already exist.
# This fixes an issue where Nginx starts but does not serve content
if [ ! -d "/run/php8" ] || [ ! -S "/run/php8/php-fpm8.sock" ]; then
    mkdir /run/php8
    touch /run/php8/php-fpm8.sock
fi

export OPEN_SEARCH_HOST_FOR_NGINX="$(echo "${OPEN_SEARCH_HOST}" | cut -d "/" -f 3 | cut -d ":" -f 1)"

# The lines below will replace the environment variables in the templates with the corresponding variables listed above. To accomplish this, the GNU 'envsubst' package will be used
# Although not recommended (if you do not know what you are doing), you still have the option to add new substitution file templates using any required environment variables
[[ ! -s ${CONFIG_NGINX_TEMPLATE} ]] && cat 'docker/server/nginx.conf' | envsubst '${OPEN_SEARCH_HOST_FOR_NGINX}' > ${CONFIG_NGINX_TEMPLATE};
