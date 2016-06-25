==============
Docker + Nginx
==============

This is a repository_ for hosting a configurable docker + nginx container running on CentOS 7. I use this container for hosting my blog with the sphinx-bootstrap container:

http://jaypjohnson.com

Docker Hub Image: `jayjohnson/nginx`_

Date: **2016-06-24**

.. role:: bash(code)
      :language: bash

Overview
--------

I built this container so I could have an extensible nginx container that could utilize a mounted volume for static files and ssl certs. By default this container will start by installing the necessary configuration files, install a robots.txt file, and then start a backgrounded nginx process.

Environment Variables
~~~~~~~~~~~~~~~~~~~~~

Here are the available environment variables that are used by the start_container.sh_ script as the container starts up. These are used by `docker compose`_ for  

+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 
| Variable Name                          | Purpose                                                            | Default Value                                               | 
+========================================+====================================================================+=============================================================+ 
| **ENV_BASE_NGINX_CONFIG**              | Provide a path to a `base nginx.conf`_                             | /root/containerfiles/base_nginx.conf                        | 
+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 
| **ENV_DERIVED_NGINX_CONFIG**           | Provide a path to a `derived nginx.conf`_                          | /root/containerfiles/derived_nginx.conf                     | 
+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 
| **ENV_DEFAULT_ROOT_VOLUME**            | Path to shared volume for static html, js, css, images, and assets | /usr/share/nginx/html                                       | 
+----------------------------------------+--------------------------------------------------------------------+-------------------------------------------------------------+ 


Getting Started
---------------

By default this container exposes ports: ``80`` and ``443`` from the container to the host OS. For development purposes, I usually have this container using host ports 81 and 444 so to prevent collisions with existing apache or nginx services.

Building
~~~~~~~~

To build the container you can run build using the properties.sh_ file: 

::

    $ ./build.sh 
    Building new Docker image(docker.io/jayjohnson/nginx)
    Sending build context to Docker daemon 37.38 kB
    Step 1 : FROM centos:7
     ---> 904d6c400333

    ...

    ---> 8bfb9d8ca828
    Successfully built 8bfb9d8ca828
    $

Here is the full the command:

    :code:`docker build --rm -t <your name>/nginx --build-arg registry=docker.io --build-arg maintainer=<your name> --build-arg imagename=nginx .`


Start the Container
~~~~~~~~~~~~~~~~~~~

To start the container run:

::

    $ ./start.sh 
    Starting new Docker image(docker.io/jayjohnson/nginx)
    ad836abf4f30eb629d501b4c1cf5b9709001293dab4e3e6b886639bd00ab4d33
    $ 

Looking into the start.sh_ you can see that there are quite a few defaults taken from the properties.sh_ file:

::

    $ cat start.sh 
    #!/bin/bash

    source ./properties.sh .

    echo "Starting new Docker image($registry/$maintainer/$imagename)"
    docker run --name=$imagename \
                -e ENV_BASE_NGINX_CONFIG=$ENV_BASE_NGINX_CONFIG \
                -e ENV_DERIVED_NGINX_CONFIG=$ENV_DERIVED_NGINX_CONFIG \
                -e ENV_DEFAULT_ROOT_VOLUME=$ENV_DEFAULT_ROOT_VOLUME \
                -v $EXT_MOUNTED_VOLUME:$INT_MOUNTED_VOLUME \
                -p 82:80 \
                -p 444:443 \
                -d $maintainer/$imagename 

    exit 0
    $


Test the Container
~~~~~~~~~~~~~~~~~~

To test the container is working try wget-ting the index.html file and confirm there is a returned ``200`` response status code:

::

    $ wget http://localhost:82/ 
    --2016-06-24 13:29:38--  http://localhost:82/
    Resolving localhost (localhost)... 127.0.0.1
    Connecting to localhost (localhost)|127.0.0.1|:82... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 13534 (13K) [text/html]
    Saving to: ‘index.html’

    index.html               100%[====================================>]  13.22K  --.-KB/s   in 0s     

    2016-06-24 13:29:38 (264 MB/s) - ‘index.html’ saved [13534/13534]
    $


Stop the Container
~~~~~~~~~~~~~~~~~~

To stop the conatiner run:

::

    $ ./stop.sh 
    Stopping Docker image(docker.io/jayjohnson/nginx)
    nginx
    $ 

Or run the command:

::
    
    $ docker stop nginx


Licenses
--------

This repository is licensed under the MIT License.

The nginx license: http://nginx.org/LICENSE


.. _docker compose: https://docs.docker.com/compose/
.. _repository: https://github.com/jay-johnson/docker-nginx
.. _jayjohnson/nginx : https://hub.docker.com/r/jayjohnson/nginx/
.. _start.sh: https://github.com/jay-johnson/docker-nginx/blob/master/containerfiles/start.sh
.. _start_container.sh: https://github.com/jay-johnson/docker-nginx/blob/master/containerfiles/start-container.sh
.. _base nginx.conf : https://github.com/jay-johnson/docker-nginx/blob/master/containerfiles/base_nginx.conf
.. _derived nginx.conf : https://github.com/jay-johnson/docker-nginx/blob/master/containerfiles/derived_nginx.conf
.. _properties.sh : https://github.com/jay-johnson/docker-nginx/blob/master/properties.sh


