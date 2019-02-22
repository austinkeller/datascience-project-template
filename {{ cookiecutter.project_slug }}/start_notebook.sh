image={{ cookiecutter.project_slug }}
platform={{ cookiecutter.platform_slug }}

if [ $platform = "jupyter" ]; then
	port=8888
	home_dir=/home/jovyan/work
else
	port=8787
	home_dir=/home/rstudio
fi

docker build -t $image .
image_id=$(docker run -d --rm -p 80:$port -v "$(pwd):$home_dir" $image)
alias kill-container="docker kill $image_id"

echo "Waiting for container to start..."
sleep 5
echo ""
echo "Notebook server running in container $image_id"
echo "Use alias 'kill-container' to kill it."
echo ""
{% if cookiecutter.platform_slug == 'jupyter' %}
url_attributes=$(docker container logs $image_id --tail 1 2>&1 | grep -o \?.*)
token=$(echo $url_attributes | grep -o token=.* | cut -d"=" -f2)
echo "If the notebook did not open automatically, point your browser to http://127.0.0.1$url_attributes"
echo "Login with:"
echo "token: $token"
open http://127.0.0.1
{% else %}
echo "If the notebook did not open automatically, point your browser to http://localhost."
echo "Login with:"
echo "user: rstudio"
echo "password: rstudio"
open http://localhost
{% endif %}
