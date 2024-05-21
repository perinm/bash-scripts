#!/bin/bash
# Replace placeholder with environment variable
sed -i "s/{{HOST_DOMAIN}}/${HOST_DOMAIN}/g" /etc/apache2/sites-available/000-default.conf

# Start the Apache server
exec apache2-foreground