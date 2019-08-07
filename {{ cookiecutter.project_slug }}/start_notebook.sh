### Helper functions

try_find_open_port()
{
	local  __out__host_port=$1
	local DEFAULT_HOST_PORT=80
	read LOWERPORT UPPERPORT < /proc/sys/net/ipv4/ip_local_port_range
	local MINPORT=49152
	local MAXPORT=65535
	LOWERPORT=$(( LOWERPORT > MINPORT ? LOWERPORT : MINPORT))
	UPPERPORT=$(( UPPERPORT < MAXPORT ? UPPERPORT : MAXPORT))
	echo "Searching port range ${LOWERPORT}-${UPPERPORT} for an available port..."
	count=$(( MAXPORT - MINPORT ))
	while [ $count -gt 0 ]
	do
		HOST_PORT="`shuf -i $LOWERPORT-$UPPERPORT -n 1`"
		ss -lpn | grep -q ":$PORT " || break
		count=$(( count - 1 ))
	done
	__out__host_port=$(( count == 0 ? 80 : DEFAULT_HOST_PORT ))
}

try_find_external_ip()
{
	echo $(/sbin/ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')
}

### Main

image={{ cookiecutter.project_slug }}
platform={{ cookiecutter.platform_slug }}

if [ $platform = "jupyter" ]; then
	port=8888
	home_dir=/home/jovyan/work
else
	port=8787
	home_dir=/home/rstudio
fi

echo ""
echo ""
echo "#### Figuring out networking configuration"
echo ""

try_find_open_port HOST_PORT
echo "Using port $HOST_PORT"

EXTERNAL_IP=$(try_find_external_ip)
[ ! -z "$EXTERNAL_IP" ] && echo "Found external ip address $EXTERNAL_IP"

echo ""
echo ""
echo "#### Building Docker image"
echo ""

docker build -t $image .
image_id=$(docker run -d --rm -p $HOST_PORT:$port -v "$(pwd):$home_dir" $image)
kill_container_script=kill-container-${image_id}.sh
echo '#!/bin/bash' > $kill_container_script
echo "docker kill $image_id" >> $kill_container_script

echo "Waiting for container to start..."
sleep 8
url_attributes=$(docker container logs $image_id --tail 1 2>&1 | grep -o \?.*)
token=$(echo $url_attributes | grep -o token=.* | cut -d"=" -f2)

echo ""
echo ""
echo "#### Instructions for end-user"
echo ""
echo "Notebook server running in container $image_id"
echo "Use 'bash kill-container-${image_id}.sh' to kill it."
echo ""
{% if cookiecutter.platform_slug == 'jupyter' %}
echo "If the notebook did not open automatically, point your browser to http://localhost:${HOST_PORT}${url_attributes}"
[ ! -z "$EXTERNAL_IP" ] && echo "If this machine is a server on your local network, point your browser to http://$(try_find_external_ip):${HOST_PORT}${url_attributes}"
echo "Login with:"
echo "token: $token"

echo ""
echo ""
echo "#### Attempting to open browser"
echo ""
xdg-open "http://localhost:${HOST_PORT}${url_attributes}"
{% else %}
echo "If the notebook did not open automatically, point your browser to http://localhost."
[ ! -z "$EXTERNAL_IP" ] && echo "If this machine is a server on your local network, point your browser to http://$(try_find_external_ip):${HOST_PORT}${url_attributes}"
echo "Login with:"
echo "user: rstudio"
echo "password: rstudio"

echo ""
echo ""
echo "#### Attempting to open browser"
echo ""
xdg-open http://localhost
{% endif %}
